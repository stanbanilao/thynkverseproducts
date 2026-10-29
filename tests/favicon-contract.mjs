import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

const root = resolve(process.argv[2] ?? ".");

const pages = [
  "/",
  "/downloads.html",
  "/ithynk.html",
  "/ithynk-meta.html",
  "/chatto.html",
  "/stride.html",
  "/statusflow.html",
  "/thynkly.html",
];

for (const page of pages) {
  const html = await readFile(resolve(root, page === "/" ? "index.html" : page.slice(1)), "utf8");
  assert.match(html, /<link\s+rel="icon"\s+type="image\/png"\s+sizes="192x192"\s+href="\/favicon\.png">/i, `${page} must advertise /favicon.png`);
  assert.match(html, /<link\s+rel="icon"\s+href="\/favicon\.ico">/i, `${page} must advertise /favicon.ico`);
}

const pngBytes = await readFile(resolve(root, "favicon.png"));
assert.deepEqual([...pngBytes.subarray(0, 8)], [137, 80, 78, 71, 13, 10, 26, 10]);
assert.equal(pngBytes.readUInt32BE(16), 192, "favicon.png width must be 192");
assert.equal(pngBytes.readUInt32BE(20), 192, "favicon.png height must be 192");

const icoBytes = await readFile(resolve(root, "favicon.ico"));
assert.deepEqual([...icoBytes.subarray(0, 4)], [0, 0, 1, 0]);

const robots = await readFile(resolve(root, "robots.txt"), "utf8");
assert.match(robots, /^Allow:\s*\/$/im, "robots.txt must allow crawling");

console.log(`PASS: favicon contract verified for ${root}`);
