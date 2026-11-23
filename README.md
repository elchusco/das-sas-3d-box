# DAS 8× SAS 3.5" — boîtier imprimé pour Precision 5820

Boîtier autonome (DAS) pour **8 disques Seagate Constellation ES.3 4 To SAS**
branchés à la **Dell PERC H330 cross-flashée HBA330 IT** du Precision 5820,
alimenté par un **Corsair CX430**. Impression 3D en panneaux monoblocs (plateau 1 m²).

> Contexte matériel : voir les sessions OpenCode `ses_f40ea9f43ffeisUVqz8XG1jY7k`
> (cross-flash H330 → HBA330 IT, réussi) et `ses_f4009159affeNv8XwPuKBRRTae`
> (PERC RAID vs HBA, alimentation des disques SAS).
> Documentation flash : `~/h330-flash/` (JOURNAL.md, HANDOFF.md, PROCEDURE.md).

## État du projet

| Étape | Statut |
|---|---|
| Analyse du besoin (8× SAS, refroidissement, PSU ATX) | ✅ |
| Collecte des specs officielles (SFF-8301, ES.3, CX430) | ✅ |
| Audit v1 (`scad/boitier_8_sas_sata_atx_v1.scad`) | ✅ 3 défauts bloquants trouvés |
| Conception v2 (disques sur tranche, fans push, PSU arrière) | ✅ |
| **v2.3** (plateau 1 m² : panneaux monoblocs, inserts Ruthex, Add2PSU) | ✅ géométrie validée |
| **v2.4** (finitions : fraisages, pieds, grilles fines, fan_guard, exploded, STL) | ✅ géométrie validée |
| **v2.5** (anti z-fighting F5 + corrections : grille recalée, struts, fraisages, lid/poteaux, STL régénérés) | ⚠️ **audit v2.5 : 6 bloquants** (cf. `docs/audit-v25.md`) — ne pas imprimer |
| **v2.6** (`scad/boitier_8_sas_v26.scad` : plaque de cage au ras des disques, poteaux 14×24 en miroir, struts 3×3, berceau + trous ATX PSU, Add2PSU sous l'étagère, sorties d'air) | ✅ géométrie validée CGAL : 0 collision, 100 % des vis sur insert (cf. `docs/audit-v25.md` § v2.6) |
| **v2.7** (`scad/boitier_8_sas_v27.scad` : canaux d'air des disques de bord, peignes de calage, barrette serre-câbles, cornières d'arêtes, passants, options `sas_ext` / `fan_iso` ; tests CGAL versionnés `tools/check.sh`) | ✅ 72 tests CGAL OK (2 configurations), 18 pièces manifold |
| Impression / assemblage / test | ⬜ (cf. [docs/impression.md](docs/impression.md), [docs/assemblage.md](docs/assemblage.md)) |

## Architecture retenue (v2)

```
        face avant                 cage disques              arrière
  ┌──────────────┐   ┌──────────────────────────────┐   ┌─────────────┐
  │ grille + 2×  │ → │ 8 disques SUR TRANCHE        │ → │ grilles     │
  │ fans 120 mm  │   │ 9 canaux d'air (6.5 ; 7 bords)│   │ 2 grommets  │
  │ (push)       │   │ vis 6-32 par plaque de cage  │   │ ⌀36 (SAS)   │
  └──────────────┘   └──────────────────────────────┘   └─────────────┘
  z 107..209 (cage)                    PSU CX430 dessous (z 16..102, plots 12),
                                       ventilateur vers le haut (extracteur)
                                       IEC + interrupteur arrière
```

- **Disques sur tranche** (grands faces verticaux) : les 2 fans 120 côte à côte
  (240 mm) couvrent la section de la cage (258×102), les vis 6-32 sont
  accessibles **par la plaque de cage** (3.2 mm, au ras des disques, 2 vis/disque,
  v2.6) après dépose du top ; les câbles SAS partent dans le plenum arrière.
- **Dimension** : 282 × 360 × 260 mm (W×D×H), panneaux 4 mm, étagère/plaque de cage 3.2 mm.
- **Flux** : admission avant grillagée → 2 fans push → 9 canaux (7 entre disques
  + 2 de 7 mm entre les joues et les disques 1/8, v2.7) →
  plenum arrière → fentes arrière (2 rangées) + fentes du top. Lèvre avant de la
  plaque de cage = déflecteur (pas de by-pass au-dessus des disques).

## Specs de référence (vérifiées aux sources)

| Référence | Valeurs clés | Source |
|---|---|---|
| SFF-8301 Rev 1.9 | trous latéraux 6-32 à **28.50 / 130.10 mm** du bout connecteurs, à **6.35 mm** de la face PCB ; pénétration vis 2.39–3.56 mm | Table 3-1 (doc `docs/sff8301-mounting-wdc.pdf`) |
| Seagate ES.3 ST4000NM0023 | 101.85 × 147.0 × 26.1 max, conforme SFF-8301 | manuel produit (`docs/seagate-es3-product-manual.pdf`, Fig.12) |
| Corsair CX430 (75-001666) | 150 × 86 × 140 mm, non modulaire, IEC arrière ; trous 6-32, IEC, interrupteur et grille **mesurés** | fiche Corsair + mesures (`docs/components/cx430.md`) |
| Fan 120 mm | découpe ⌀114, fixations M4 carré 105 | standard |
| Vis disques | 6-32 UNC × 1/4" (engagement 3.15 mm dans plaque 3.2) | SFF-8301 |

## Arborescence

```
scad/
  boitier_8_sas_sata_atx_v1.scad   # v1 originale (archivée, cf. audit docs/audit-v1.md)
  boitier_8_sas_v2.scad            # v2.5 (archivée, cf. audit docs/audit-v25.md)
  boitier_8_sas_v26.scad           # v2.6 (archivée)
  boitier_8_sas_v27.scad           # v2.7 COURANTE
tools/
  check.sh / check.scad            # tests CGAL : collisions, vis sur insert
  build.sh                         # export STL + rendus + tableau des masses
  stlinfo.py                       # volume / bbox d'un STL
  hdd-temp.sh                      # température des disques (côté hôte)
docs/
  audit-v1.md                      # audit de la v1 (conflits trouvés)
  audit-v24-flicker.md             # audit v2.4→v2.5 (z-fighting + 8 bugs)
  audit-v25.md                     # audit v2.5 (6 bloquants, 4 majeurs) → v2.6
  conformite.md                    # tableau besoin ↔ mesure ↔ statut
  bom.md                           # nomenclature (pièces, inserts, visserie, composants)
  impression.md                    # matériau, réglages, questions à l'imprimeur
  assemblage.md                    # ordre de montage
  components/                      # composants externes intégrés
    add2psu.md                     #   module démarrage auto (15,19 €, lot de 2)
    cx430.md                       #   alim : orientation, mesures face arrière, fenêtre
    add2psu_dkey_70x30mm.jpg       #   photo produit
    inserts-ruthex.md              #   inserts laiton M3/M4 (perçages, plan)
    ruthex-kit-dimensions.jpg      #   étiquette kit Ruthex (cotes inserts)
    ruthex-kit-contenu.jpg         #   contenu du kit Ruthex
  sff8301-mounting-wdc.pdf         # positions de vis SFF-8301 (WDC/SNIA)
  seagate-es3-product-manual.pdf   # manuel ES.3 (dimensions Fig.12)
renders/                           # rendus PNG (assembly, faces, lid…)
stl/v25/                           # exports STL v2.5 (13 pièces, archivés)
stl/v26/                           # exports STL v2.6 (14 pièces)
stl/v27/                           # exports STL v2.7 (18 pièces)
TODO.md                            # points à fignoler / reportés
```

## Rendu / export

```sh
tools/build.sh v27                 # 18 STL dans stl/v27/ + rendus renders/*_v27.png
tools/check.sh                     # 72 tests CGAL sur la v2.7 (~1 min, parallèle)
tools/check.sh scad/boitier_8_sas_v27.scad -D sas_ext=true -D fan_iso=true
ONLY='probe|seat' tools/check.sh   # sous-ensemble de tests

# pièce isolée
xvfb-run -a openscad -o /tmp/shelf.png -D 'part="shelf"' scad/boitier_8_sas_v27.scad
```

`part` ∈ `assembly, exploded, cutaway, front, rear, left, right, bottom, top,
shelf, cage_plate, strut, corner_post, corner_post_m, edge_rail_x, edge_rail_y,
cable_bar, fan_guard, fan_gasket, atx_bridge, box_foot`. Quantités :
[docs/bom.md](docs/bom.md). Options : `sas_ext` (équerres SFF-8644 au lieu des
grommets), `fan_iso` (joints TPU sous les fans).

`tools/check.sh` vérifie, pièces placées comme dans `assembly()` : panneaux ∩
intérieur (contact plan toléré, volume nul), groupes internes 2 à 2,
intérieur ∩ composants, et pour chaque vis une sonde ⌀1 (le trou débouche
jusqu'au fond de la poche) et un tube (la poche est entourée de matière de
la pièce cible). Il exige les modules de placement de la v2.7 : il ne
s'applique pas aux fichiers v2.6 et antérieurs.

Supervision : `tools/hdd-temp.sh [seuil]` (smartctl, code retour 1 au-delà
du seuil ; limite ES.3 : 60 °C boîtier).

Nouvelle version = nouveau fichier `scad/boitier_8_sas_vXY.scad` (+ `stl/vXY/`,
`renders/*_vXY.png`) ; les versions précédentes restent intactes.

## Points d'attention fabrication

- **Plateau d'impression : 1 m²** (hypothèse, à confirmer avec l'imprimeur : la plus grande pièce fait 352 × 274) : tous les panneaux
  s'impriment **monoblocs** (plus de segmentation).
- **Impression plate** : tous les panneaux s'impriment à plat (extrusion 4 mm,
  étagère/plaque 3.2 mm, l'étagère avec ses joues de 102 mm et la plaque avec
  sa lèvre s'impriment à plat, parois vers le haut). Les découpes débordent de 1 mm des faces (v2.5 :
  anti z-fighting de l'aperçu F5) — sans effet sur la géométrie finale.
  La face renforcée (collerettes grommets saillantes 1 mm) s'imprime vers le
  haut, sans support.
- **Assemblage par inserts Ruthex** : M4×8.1 dans les jetées d'angle (poches
  ⌀5.6 × 9.1), M3×5.7 dans les struts et supports fins — voir
  [docs/components/inserts-ruthex.md](docs/components/inserts-ruthex.md).
  Les vis de **disques restent en 6-32 UNC × 1/4"** directes dans la plaque
  de cage (standard impérial des trous HDD, pas d'insert).
- **Alimentation** : ventilateur **vers le haut** (aspire le plenum), vissée au
  panneau arrière par 4 × 6-32 × 3/8" ; mesures et choix détaillés dans
  [docs/components/cx430.md](docs/components/cx430.md).
- **Démarrage automatique** : module **Add2PSU** (~15 €) — allumer la tour
  démarre le DAS. Détails + référence + emplacement :
  [docs/components/add2psu.md](docs/components/add2psu.md). Le pont `atx_bridge`
  imprimé reste la solution de secours.
- **Démarrage des disques** : ≈ 2.9 A de crête par disque sur le 12 V →
  au moins 2 câbles SATA du CX430 (cf. [docs/components/cx430.md](docs/components/cx430.md)).
- **Impression** : PETG ou ASA, pas de PLA — [docs/impression.md](docs/impression.md).
- **Limites connues** : voir [TODO.md](TODO.md) avant impression.
