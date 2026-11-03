#!/usr/bin/env bash
# Copies each plugin's shared/ helpers into the scripts/ folder of every skill
# that uses them, so a skill installed on its own (npx skills add --skill) still
# has its helper. Run after editing anything in plugins/*/shared/.
set -euo pipefail
cd "$(dirname "$0")/.."

# plugin:skill pairs that need plugins/<plugin>/shared/vz.sh
for skill in architectural-render interior-restyle product-colorways game-asset-render image-to-3d; do
  dir="plugins/visualizee/skills/$skill/scripts"
  mkdir -p "$dir"
  cp plugins/visualizee/shared/vz.sh "$dir/vz.sh"
  chmod +x "$dir/vz.sh"
done
echo "synced"
