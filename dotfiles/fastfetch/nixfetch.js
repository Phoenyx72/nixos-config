#!/usr/bin/env node

const { execSync } = require("child_process");

const width = 80;
const height = 22;

const C_DARK  = [248, 182, 179];
const C_LIGHT = [248, 224, 222];

let points = [];

function addLine(p1, p2, colorId) {
    let dx = p2.x - p1.x;
    let dy = p2.y - p1.y;
    let dz = p2.z - p1.z;

    let dist = Math.sqrt(dx * dx + dy * dy + dz * dz);
    let steps = Math.floor(dist * 1.0);

    for (let i = 0; i <= steps; i++) {
        let t = i / steps;

        points.push({
            x: p1.x + dx * t,
            y: p1.y + dy * t,
            z: p1.z + dz * t,
            c: colorId
        });
    }
}

function makeQuad(start, end, w) {
    let dx = end.x - start.x;
    let dy = end.y - start.y;

    let len = Math.sqrt(dx * dx + dy * dy);

    let nx = (-dy / len) * (w / 2);
    let ny = (dx / len) * (w / 2);

    return [
        { x: start.x + nx, y: start.y + ny },
        { x: end.x + nx, y: end.y + ny },
        { x: end.x - nx, y: end.y - ny },
        { x: start.x - nx, y: start.y - ny }
    ];
}

const numWedges = 6;
const depth = 2;

const rCenter = 14;

const pInnerTop = { x: -1.5, y: 7 };
const pOuterLeft = { x: -5, y: -7 };
const pOuterRight = { x: 4, y: -7 };
const pCrotch = { x: -3, y: 1 };

const strokeWidth = 3;

const spine = makeQuad(pInnerTop, pOuterLeft, strokeWidth);
const leg = makeQuad(pCrotch, pOuterRight, strokeWidth);

const shapePolys = [spine, leg];

for (let i = 0; i < numWedges; i++) {
    const angle = i * Math.PI / 3;

    function transform(p, z) {
        let px = p.x;
        let py = p.y;
        let pz = z;

        let rotY = Math.PI;
        let rotZ = 230 * Math.PI / 180;

        let c = Math.cos(rotY);
        let s = Math.sin(rotY);

        let tx = px * c - pz * s;
        let tz = px * s + pz * c;

        px = tx;
        pz = tz;

        c = Math.cos(rotZ);
        s = Math.sin(rotZ);

        tx = px * c - py * s;
        let ty = px * s + py * c;

        px = tx;
        py = ty;

        let u = rCenter + py;
        let v = px;

        return {
            x: u * Math.cos(angle) - v * Math.sin(angle),
            y: u * Math.sin(angle) + v * Math.cos(angle),
            z: pz,
            c: i % 2
        };
    }

    for (const poly of shapePolys) {
        for (let j = 0; j < poly.length; j++) {
            let a = poly[j];
            let b = poly[(j + 1) % poly.length];

            addLine(transform(a, -depth), transform(b, -depth), i % 2);
            addLine(transform(a, depth), transform(b, depth), i % 2);
            addLine(transform(a, -depth), transform(a, depth), i % 2);
        }
    }
}

let angleX = 0;
let angleY = 0;

const fastfetchLines = execSync(
    "fish -c 'fastfetch --logo none'",
    { encoding: "utf8" }
).split("\n");

let zBuffer = Array(width * height).fill(-Infinity);
let buffer = Array(width * height).fill(null);

function render() {

    zBuffer.fill(-Infinity);
    buffer.fill(null);

    let cosY = Math.cos(angleY);
    let sinY = Math.sin(angleY);

    let cosX = Math.cos(angleX);
    let sinX = Math.sin(angleX);

    for (let p of points) {

        let x1 = p.x * cosY - p.z * sinY;
        let z1 = p.x * sinY + p.z * cosY;

        let y2 = p.y * cosX - z1 * sinX;
        let z2 = p.y * sinX + z1 * cosX;

        let ooz = 1 / (z2 + 50);

        let xp = Math.floor(width / 2 + x1 * ooz * 40);
        let yp = Math.floor(height / 2 + 1 + y2 * ooz * 20);

        if (
            xp >= 0 &&
            xp < width &&
            yp >= 0 &&
            yp < height
        ) {

            let idx = yp * width + xp;

            if (ooz > zBuffer[idx]) {

                zBuffer[idx] = ooz;

                let chars = ".:-=+*#%@";
                let lum = Math.floor(((z2 + 24) / 48) * chars.length);

                lum = Math.max(
                    0,
                    Math.min(chars.length - 1, lum)
                );

                buffer[idx] = {
                    char: chars[lum],
                    colour: p.c ? C_LIGHT : C_DARK
                };
            }
        }
    }

    let out = "";

    for (let y = 0; y < height; y++) {
        for (let x = 0; x < width; x++) {

            let p = buffer[y * width + x];

            if (!p) {
                out += " ";
            } else {
                out += `\x1b[38;2;${p.colour[0]};${p.colour[1]};${p.colour[2]}m${p.char}`;
            }
        }

        out += "\n";
    }

    let final = "\x1b[H";

    let logoLines = out.split("\n");

    const gap = 4;
    const infoOffset = 1;

    for (let i = 0; i < Math.max(logoLines.length, fastfetchLines.length); i++) {

        let left = logoLines[i] ?? "";
        let right = fastfetchLines[i - infoOffset] ?? "";

        // Remove ANSI colours when measuring width
        let visibleLength = left.replace(/\x1b\[[0-9;]*m/g, "").length;

        final += left;
        final += " ".repeat(Math.max(0, width - visibleLength + gap));
        final += right;
        final += "\n";
    }

    process.stdout.write(final);

    angleY += 0.03;
    angleX += 0.005;
}

process.stdout.write("\x1b[2J\x1b[?25l");

setInterval(render, 50);

function cleanup() {
    process.stdout.write("\x1b[?25h\x1b[0m\x1b[?1049l");
    process.exit();
}

process.stdin.setRawMode(true);
process.stdin.resume();

process.stdin.on("data", cleanup);
process.on("SIGINT", cleanup);
process.on("exit", cleanup);