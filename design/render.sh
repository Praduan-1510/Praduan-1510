#!/bin/sh
# Renders the profile README's images from the HTML in this folder, at 2x,
# with headless Google Chrome. Needs a network connection for the Google Fonts.
#
#   sh design/render.sh
#
# Each image is a screenshot of one HTML page at its own CSS size; the
# transparent background keeps the rounded corners clean on GitHub's light
# and dark themes alike.
set -e
cd "$(dirname "$0")"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
shot() {
  "$CHROME" --headless=new --hide-scrollbars --force-device-scale-factor=2 \
    --default-background-color=00000000 --virtual-time-budget=10000 \
    --window-size="$2" --screenshot="$3" "file://$PWD/$1" >/dev/null 2>&1
  echo "rendered $3"
}
shot "banner.html?theme=dark" 800,340 ../assets/banner-dark.png
shot "banner.html?theme=light" 800,340 ../assets/banner-light.png
shot "section.html?s=work" 800,116 ../assets/section-work.png
shot "section.html?s=github" 800,116 ../assets/section-github.png
shot "section.html?s=toolkit" 800,214 ../assets/section-toolkit.png
for p in insightstap keel carebridge graphics nukkad meridian; do
  shot "card.html?p=$p" 400,380 "../assets/card-$p.png"
done

# Then shrink them (needs sharp; point NODE_PATH at any node_modules that has it):
#   NODE_PATH=/path/to/node_modules node design/optimize.cjs
