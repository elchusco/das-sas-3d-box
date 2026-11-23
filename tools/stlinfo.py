#!/usr/bin/env python3
"""Volume et boite englobante d'un STL (ASCII ou binaire).

    tools/stlinfo.py fichier.stl [...]
Sortie par fichier : nom, nb triangles, volume mm3, bbox (dx x dy x dz).

    tools/stlinfo.py --table [--density 1.27] piece.stl:qte [...]
Tableau piece / quantite / bbox / volume plein / masse, et total (les
quantites 0 = pieces optionnelles, non comptees).
"""
import re
import struct
import sys


def triangles(path):
    data = open(path, "rb").read()
    if data[:5] == b"solid" and b"facet" in data[:400]:
        pts = [tuple(map(float, m)) for m in re.findall(
            rb"vertex\s+(\S+)\s+(\S+)\s+(\S+)", data)]
        return [pts[i:i + 3] for i in range(0, len(pts), 3)]
    n = struct.unpack_from("<I", data, 80)[0]
    tris = []
    for i in range(n):
        f = struct.unpack_from("<12f", data, 84 + 50 * i)
        tris.append([f[3:6], f[6:9], f[9:12]])
    return tris


def info(path):
    tris = triangles(path)
    vol = 0.0
    for a, b, c in tris:
        vol += (a[0] * (b[1] * c[2] - b[2] * c[1])
                - a[1] * (b[0] * c[2] - b[2] * c[0])
                + a[2] * (b[0] * c[1] - b[1] * c[0])) / 6
    if not tris:
        return 0, 0.0, (0, 0, 0)
    pts = [p for t in tris for p in t]
    bbox = tuple(max(p[k] for p in pts) - min(p[k] for p in pts) for k in range(3))
    return len(tris), abs(vol), bbox


def table(args):
    dens = 1.27
    if args[:1] == ["--density"]:
        dens, args = float(args[1]), args[2:]
    print(f"{'piece':<14} {'qte':>3}  {'bbox mm':<24} {'cm3':>7} {'g/pce':>6}")
    total = 0.0
    for a in args:
        path, q = a.rsplit(":", 1)
        _, v, b = info(path)
        g = v / 1000 * dens
        total += int(q) * g
        name = path.rsplit("/", 1)[-1][:-4]
        bb = f"{b[0]:.1f} x {b[1]:.1f} x {b[2]:.1f}"
        print(f"{name:<14} {q:>3}  {bb:<24} {v/1000:7.1f} {g:6.0f}")
    print(f"masse totale (plein, densite {dens}) : {total:.0f} g")


if __name__ == "__main__":
    if sys.argv[1:2] == ["--table"]:
        table(sys.argv[2:])
        sys.exit(0)
    for p in sys.argv[1:]:
        n, v, b = info(p)
        print(f"{p}\t{n}\t{v:.3f}\t{b[0]:.2f} x {b[1]:.2f} x {b[2]:.2f}")
