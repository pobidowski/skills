#!/usr/bin/env bash
# Copies shared helpers into the scripts/ folder of every skill that uses them,
# so a skill installed on its own (npx skills add --skill) still has its helper.
# Run after editing anything in shared/.
set -euo pipefail
cd "$(dirname "$0")/.."

# Skills that call the Visualizee REST API through shared/visualizee/vz.sh
for skill in architectural-render interior-restyle product-colorways game-asset-render image-to-3d; do
  mkdir -p "skills/$skill/scripts"
  cp shared/visualizee/vz.sh "skills/$skill/scripts/vz.sh"
  chmod +x "skills/$skill/scripts/vz.sh"
done
echo "synced"
