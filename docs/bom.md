# Nomenclature — v2.7

Source unique des quantités (remplace la liste « Visserie » de `TODO.md`).
Modèle : `scad/boitier_8_sas_v27.scad`. Pièces imprimées : `stl/v27/`.

## Pièces imprimées

`tools/build.sh v27` régénère les STL et affiche bbox, volume et masse.

| Pièce (`part`) | Qté | Bbox (mm) | Rôle |
|---|---|---|---|
| `front` | 1 | 274 × 252 × 4 | face avant, 2 fans 120 |
| `rear` | 1 | 274 × 252 × 5 | PSU, grommets SAS, fentes |
| `left`, `right` | 1 + 1 | 352 × 252 × 4 | flancs |
| `bottom` | 1 | 274 × 352 × 16 | fond, plots PSU, bossages Add2PSU, passants |
| `top` | 1 | 274 × 352 × 4 | plafond, évent plenum |
| `shelf` | 1 | 273 × 166 × 105 | étagère + joues + piliers + peignes |
| `cage_plate` | 1 | 273 × 166 × 46 | plaque de cage + lèvre déflecteur |
| `strut` | 9 | 24 × 24 × 100 | colonnes sous l'étagère |
| `corner_post` | 2 | 14 × 24 × 252 | poteaux AV-G, AR-D (tourné 180°) |
| `corner_post_m` | 2 | 14 × 24 × 252 | poteaux AV-D, AR-G |
| `edge_rail_x` | 3 | 245 × 9 × 9 | cornières avant-bas, avant-haut, arrière-haut |
| `edge_rail_y` | 4 | 303 × 9 × 9 | cornières flancs bas et haut |
| `cable_bar` | 1 | 273 × 12 × 10 | barrette serre-câbles SAS |
| `box_foot` | 4 | 30 × 30 × 12 | pieds |
| `atx_bridge` | 1 | 14 × 10 × 8 | pont PS_ON de secours |
| `fan_guard` | 0–2 | 124 × 124 × 3 | option : grille vissée |
| `fan_gasket` | 0–2 | 120 × 120 × 1.5 | option `fan_iso` : joint TPU |

Masse pleine ≈ 4.2 kg PETG ; avec les réglages de
[impression.md](impression.md), compter ≈ 2.5–3 kg de filament.

## Inserts Ruthex

| Insert | Qté | Où |
|---|---|---|
| RX-M4×8.1 | 24 | poteaux : 2 faces × 2 hauteurs + pied + tête, × 4 |
| RX-M3×5.7 | 33 | struts ×9, piliers d'étagère ×4, Add2PSU ×4, cornières ×14, barrette ×2 |

## Visserie

| Vis | Qté | Où |
|---|---|---|
| 6-32 UNC × 1/4" | 16 | disques (plaque de cage, 2 par disque) |
| 6-32 UNC × 3/8" | 4 | PSU → panneau arrière |
| M4 × 12 fraisée | 24 | panneaux → poteaux |
| M4 × 12 (autotaraudeuse plastique ou standard) | 9 | fond → struts (pilote ⌀3.3) |
| M4 × 14 | 4 | fond → pieds (par l'intérieur) |
| M3 × 8 fraisée | 9 | étagère → struts |
| M3 × 8 fraisée | 4 | plaque de cage → piliers |
| M3 × 8 fraisée | 14 | panneaux → cornières |
| M3 × 8 | 2 | flancs → barrette |
| M3 × 6 | 4 | Add2PSU → bossages |
| vis fan (5 × 10 auto ou M4 × 10 + écrou) | 8 | fans → face avant |
| (option `sas_ext`) M3 × 6 + écrou | 2 | équerres SFF-8644 |

Total M3 × 8 : 29. Avec `fan_iso` : vis fan M4 × 14 + rondelles caoutchouc.

## Composants

| Composant | Qté | Remarque |
|---|---|---|
| Seagate ES.3 ST4000NM0023 (SAS 4 To) | 8 | disponibles |
| Corsair CX430 | 1 | disponible, cf. [components/cx430.md](components/cx430.md) |
| Ventilateur 120 mm PWM (Arctic P12 PWM PST / Noctua NF-P12 redux-1700) | 2 | à commander |
| Add2PSU (lot de 2) | 1 | cf. [components/add2psu.md](components/add2psu.md) |
| Câble SFF-8643 → 4× SFF-8482 (avec alim SATA) | 2 | queues ≥ 200 mm |
| Passe-câble / grommet ⌀36 | 2 | panneau arrière (sauf `sas_ext`) |
| (option `sas_ext`) équerre PCIe SFF-8644 → SFF-8643 | 4 | 2 côté DAS, 2 côté tour, + 2 câbles SFF-8644 externes |
| Répartiteur SATA alim (si < 4 prises par câble) | selon CX430 | voir le budget de démarrage dans cx430.md |
| Patins élastomère ⌀20 × 1.5 | 4 | logement sous les pieds |
| Colliers de serrage 2.5 mm | ~20 | barrette (8) + passants du fond (8) + divers |
| Kit inserts Ruthex GE-KASTEN-001 | 1 | cf. [components/inserts-ruthex.md](components/inserts-ruthex.md) |
