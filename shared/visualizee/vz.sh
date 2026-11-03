#!/usr/bin/env bash
# Visualizee REST API helper for agent skills.
# Needs: curl, jq, and VISUALIZEE_API_KEY (a vz_live_ key from visualizee.app, Pro or Max plan).
#
#   vz.sh models                 List image and 3D models with their credit cost.
#   vz.sh image BODY.json        POST /render/image, then wait for every render.
#   vz.sh 3d BODY.json           POST /render/3d, then wait for the model.
#   vz.sh status RENDER_ID       One status check.
#   vz.sh wait RENDER_ID         Poll until the render is completed or failed.
#
# Results print as JSON (the status endpoint's fields: image_url, model_3d, credits, error).
# Copied into each skill by scripts/sync-shared.sh from shared/visualizee/vz.sh; edit it there.
# Pick the level in the request body with "quality": "base" | "pro" | "ultra" (default pro).

set -euo pipefail

API="${VISUALIZEE_API_URL:-https://visualizee.app/api/v1}"

die() { echo "vz.sh: $*" >&2; exit 1; }

command -v curl >/dev/null || die "curl is required"
command -v jq >/dev/null || die "jq is required (brew install jq / apt install jq)"
[ -n "${VISUALIZEE_API_KEY:-}" ] || die "VISUALIZEE_API_KEY is not set. Create a key on the Account page at https://visualizee.app (Pro or Max plan), or use the Visualizee MCP server instead (any plan, no key)."

auth=(-H "Authorization: Bearer ${VISUALIZEE_API_KEY}")

new_key() {
  if command -v uuidgen >/dev/null; then uuidgen; else echo "vz-$(date +%s)-$RANDOM$RANDOM"; fi
}

# GET; an error answer prints its {"error": {code, message}} envelope and exits.
get() {
  local body status
  body=$(curl -sS -w '\n%{http_code}' "${auth[@]}" "$API$1")
  status=${body##*$'\n'}
  body=${body%$'\n'*}
  if [ "$status" -ge 400 ]; then
    echo "$body" >&2
    exit 1
  fi
  echo "$body"
}

submit() {
  local path=$1 file=$2 key body status
  [ -f "$file" ] || die "no such file: $file"
  key=$(new_key)
  # The Vizzy turn behind /render/image can take up to ~60 s, so allow 120 s.
  # On a network error, retry with the SAME Idempotency-Key: it returns the
  # original response instead of starting (and charging) a second render.
  for attempt in 1 2 3; do
    if body=$(curl -sS --max-time 120 -w '\n%{http_code}' "${auth[@]}" \
      -H "Content-Type: application/json" -H "Idempotency-Key: $key" \
      --data-binary "@$file" "$API$path"); then
      status=${body##*$'\n'}
      body=${body%$'\n'*}
      if [ "$status" = "409" ] && echo "$body" | jq -e '.error.code == "idempotency_key_in_use"' >/dev/null; then
        sleep 10; continue
      fi
      if [ "$status" -ge 400 ]; then
        echo "$body" >&2
        exit 1
      fi
      # Vizzy's summary and the charge, for the user; the ids go to stdout.
      echo "$body" | jq -c '{summary, credits_charged, credits_remaining}' >&2
      echo "$body"
      return 0
    fi
    echo "vz.sh: network error, retrying with the same Idempotency-Key ($attempt/3)" >&2
    sleep 5
  done
  die "request failed three times; check the API folder in your Visualizee workspace before retrying"
}

wait_for() {
  local id=$1 every=${2:-5} out status
  for _ in $(seq 1 120); do
    out=$(get "/render/status/$id") || exit 1
    status=$(echo "$out" | jq -r .status)
    if [ "$status" != "pending" ]; then
      echo "$out"
      [ "$status" = "completed" ]
      return
    fi
    sleep "$every"
  done
  die "render $id is still pending after a long wait; check it later with: vz.sh status $id"
}

case "${1:-}" in
  models)
    get /models | jq '{images: [.models[] | {id, name, quality, tier, default, credits_at_1024, transparent_background}], models_3d}'
    ;;
  image)
    res=$(submit /render/image "${2:?usage: vz.sh image BODY.json}")
    for id in $(echo "$res" | jq -r '.renders[].id'); do wait_for "$id" 5 || true; done
    ;;
  3d)
    res=$(submit /render/3d "${2:?usage: vz.sh 3d BODY.json}")
    for id in $(echo "$res" | jq -r '.renders[].id'); do wait_for "$id" 15 || true; done
    ;;
  status)
    get "/render/status/${2:?usage: vz.sh status RENDER_ID}"
    ;;
  wait)
    wait_for "${2:?usage: vz.sh wait RENDER_ID}" "${3:-5}"
    ;;
  *)
    sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
    ;;
esac
