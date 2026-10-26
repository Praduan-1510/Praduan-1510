// Re-encodes every rendered PNG in ../assets to a quantised palette, which
// takes the set from about 6 MB to about 2 MB with no visible change (the
// grain and gradients survive libimagequant's dithering). Needs sharp:
//
//   NODE_PATH=/path/to/node_modules node design/optimize.cjs
const sharp = require("sharp");
const fs = require("fs");
const path = require("path");
const dir = path.join(__dirname, "..", "assets");
(async () => {
  for (const f of fs.readdirSync(dir).filter((f) => f.endsWith(".png"))) {
    const p = path.join(dir, f);
    const buf = await sharp(p)
      .png({ palette: true, quality: 92, effort: 10, dither: 0.8, compressionLevel: 9 })
      .toBuffer();
    fs.writeFileSync(p, buf);
    console.log(`optimised ${f} (${Math.round(buf.length / 1024)}K)`);
  }
})();
