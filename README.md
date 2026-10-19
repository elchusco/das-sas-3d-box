# DAS 8× SAS 3.5" — boîtier imprimé pour Precision 5820

Boîtier autonome (DAS) pour **8 disques Seagate Constellation ES.3 4 To SAS**
branchés à la **Dell PERC H330 cross-flashée HBA330 IT** du Precision 5820,
alimenté par un **Corsair CX430**. Impression 3D en panneaux segmentés.

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
| Conception v2 (disques sur tranche, fans push, PSU arrière) | 🔨 géométrie principale validée |
| Finitions v2 (joints, grilles, anti-vibration) | ⏳ voir [TODO.md](TODO.md) |
| Impression / assemblage / test | ⬜ |

## Architecture retenue (v2)

```
        face avant                 cage disques              arrière
  ┌──────────────┐   ┌──────────────────────────────┐   ┌─────────────┐
  │ grille + 2×  │ → │ 8 disques SUR TRANCHE        │ → │ grilles     │
  │ fans 120 mm  │   │ 7 canaux d'air de 7 mm       │   │ 2 grommets  │
  │ (push)       │   │ vis 6-32 par le couvercle    │   │ ⌀36 (SAS)   │
  └──────────────┘   └──────────────────────────────┘   └─────────────┘
  z 107..209 (cage)                    PSU CX430 dessous (z 16..102, pieds 12)
                                       IEC + interrupteur arrière
```

- **Disques sur tranche** (grands faces verticaux) : les 2 fans 120 côte à côte
  (240 mm) couvrent la section de la cage (258×102), les vis 6-32 sont
  accessibles **par le couvercle** (lid 3.2 mm, 2 vis/disque), les câbles SAS
  descendent verticalement derrière la cage.
- **Dimension** : 282 × 360 × 260 mm (W×D×H), panneaux 4 mm, lid/étagère 3.2 mm.
- **Flux** : admission avant grillagée → 2 fans push → 7 canaux entre disques →
  plenum arrière → grilles hautes arrière. PSU en série (exhaust externe).

## Specs de référence (vérifiées aux sources)

| Référence | Valeurs clés | Source |
|---|---|---|
| SFF-8301 Rev 1.9 | trous latéraux 6-32 à **28.50 / 130.10 mm** du bout connecteurs, à **6.35 mm** de la face PCB ; pénétration vis 2.39–3.56 mm | Table 3-1 (doc `docs/sff8301-mounting-wdc.pdf`) |
| Seagate ES.3 ST4000NM0023 | 101.85 × 147.0 × 26.1 max, conforme SFF-8301 | manuel produit (`docs/seagate-es3-product-manual.pdf`, Fig.12) |
| Corsair CX430 (75-001666) | 150 × 86 × 140 mm, non modulaire, IEC arrière | fiche Corsair |
| Fan 120 mm | découpe ⌀114, fixations M4 carré 105 | standard |
| Vis disques | 6-32 UNC × 1/4" (engagement 3.15 mm dans plaque 3.2) | SFF-8301 |

## Arborescence

```
scad/
  boitier_8_sas_sata_atx_v1.scad   # v1 originale (archivée, cf. audit docs/audit-v1.md)
  boitier_8_sas_v2.scad            # v2 courante (disques sur tranche)
docs/
  audit-v1.md                      # audit de la v1 (conflits trouvés)
  conformite.md                    # tableau besoin ↔ mesure ↔ statut
  sff8301-mounting-wdc.pdf         # positions de vis SFF-8301 (WDC/SNIA)
  seagate-es3-product-manual.pdf   # manuel ES.3 (dimensions Fig.12)
renders/                           # rendus PNG (assembly, faces, lid…)
stl/                               # exports STL (à venir)
TODO.md                            # points à fignoler
```

## Rendu / export

Le MCP OpenSCAD d'OpenCode (`openscad` server, xvfb-run) peut compiler et rendre
chaque pièce. En ligne de commande :

```sh
# vue assemblage
xvfb-run -a openscad -o /tmp/assembly.png --imgsize 1100,850 --autocenter --viewall \
  -D 'part="assembly"' scad/boitier_8_sas_v2.scad

# export STL d'une pièce
xvfb-run -a openscad -o stl/lid.stl -D 'part="lid"' scad/boitier_8_sas_v2.scad
```

`part` ∈ `assembly, front, rear, left, right, bottom, top, shelf, lid, strut,
corner_post, fan_guard, grommet_ring, atx_bridge, box_foot`.

## Points d'attention fabrication

- **Plateau d'impression** : paramètre `bed_max = 220` (à ajuster) — tous les
  panneaux sont pré-découpés en quarts avec ergots/slots.
- **Impression plate** : tous les panneaux s'impriment à plat (extrusion 4 mm).
- **Collage** : joints ergots+slots + colle (les panneaux ne sont pas vissés
  entre eux ; seuls les disques, fans et le PSU sont démontables).
- **ATX sans carte mère** : pont PS_ON↔COM obligatoire (pièce `atx_bridge` ou
  pont soudé), l'interrupteur secteur du CX430 sert d'interrupteur général.
- **Limites SCAD v2 connues** : voir [TODO.md](TODO.md) avant impression.
