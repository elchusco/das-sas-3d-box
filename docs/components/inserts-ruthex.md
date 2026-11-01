# Inserts Ruthex — assemblage des panneaux

Kit utilisé : **Ruthex GE-KASTEN-001**
(photos : `ruthex-kit-dimensions.jpg` — étiquette cotes, `ruthex-kit-contenu.jpg` — contenu du kit).

| Réf | Dimensions (⌀d1 ext. / ⌀d2 / L / min. w) | Stock kit | Usage dans le projet |
|---|---|---|---|
| **RX-M4×8.1** | ⌀6.3 / 5.5 / 5.6, L 8.1, collet 2.1 | 50 pcs | poteaux/jetées (24×24), struts |
| **RX-M3×5.7** | ⌀4.6 / 3.9 / 4.0, L 5.7, collet 1.6 | 100 pcs | lid, supports fins (Add2PSU, fan guards) |
| RX-M5×9.5 | ⌀7.1 / 6.3 / 6.4 | 50 pcs | (réserve) |
| RX-M2×4 | ⌀3.6 / 3.1 / 3.2 | 70 pcs | (réserve) |

## Règles de perçage (données Ruthex)

- Trou plastique : **⌀d3** (M3 → 4.0, M4 → 5.6), profondeur **L + 1 mm** minimum.
- L'insert se pose **à chaud** (fer à souder ou pistolet à insert, ~200 °C),
  collet affleurant la surface.
- Jamais d'insert dans une paroi < L : les M4×8.1 vont uniquement dans les
  **poteaux et bosses ≥ 9 mm**, jamais à plat dans un panneau de 4 mm.

## Plan d'affectation

| Assemblage | Insert | Vis |
|---|---|---|
| Poteaux d'angle ↔ panneaux (avant/arrière/flancs) — v2.6 | M4×8.1 ×16 (2 faces par poteau) | M4 × 12 |
| Poteaux ↔ fond / plafond | M4×8.1 ×8 (pied + tête) | M4 × 12 |
| Struts ↔ étagère | M3×5.7 ×9 en tête de strut | M3 × 8 |
| Joues d'étagère ↔ plaque de cage | M3×5.7 ×4 | M3 × 8 |
| Add2PSU ↔ bossages du fond | M3×5.7 ×4 | M3 × 6 |
| Fond ↔ struts (pas d'insert) | pilote ⌀3.3 | M4 × 12 autotaraudeuse |
| fan guards (si vissées) | traversant ⌀4.5 | vis fan M4 / 5×30 |

## ⚠️ Exception : les disques

Les trous des HDD sont au standard **6-32 UNC (impérial)** : ni M3 ni M4 ne
s'y visse. Les 16 vis de disques sont des **6-32 × 1/4"** qui traversent la
plaque de cage (3.2 mm, 0.3 mm au-dessus des disques → pénétration 2.85 mm,
SFF-8301 : 2.39..3.56). Pas d'insert. Idem PSU : 4 × 6-32 × 3/8" à travers le
panneau arrière.
