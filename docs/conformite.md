# Tableau de conformité — v2.3 (`scad/boitier_8_sas_v2.scad`)

Besoin ↔ mesure ↔ source ↔ statut. Valeurs "monde" du repère SCAD
(X largeur 0..282, Y profondeur 0..360, Z hauteur 0..260).

## Disques (8 × Seagate Constellation ES.3 ST4000NM0023, SAS 4 To)

| Besoin | Mesure v2 | Source | Statut |
|---|---|---|---|
| Enveloppe disque 101.85 × 147.0 × 26.1 max | pitch 33.1 = 26.1 + 7.0 air ; cage 257.8 de large | SFF-8301 / Seagate Fig.12 | ✅ |
| Orientation | sur tranche, PCB cote −X (panneau gauche) | choix conception | ✅ |
| Trou latéral #1 : 28.50 mm du bout connecteurs | screw_y = conn_y − 28.50 = **166.5** | SFF-8301 A8 | ✅ |
| Trou latéral #2 : 130.10 mm | screw_y = conn_y − 130.10 = **64.9** | SFF-8301 A8+A9 | ✅ |
| Offset face PCB : 6.35 mm | screw_x = drive_x[i] + 6.35 | SFF-8301 A10 | ✅ |
| Vis 6-32 UNC, pénétration ≤ 3.56 | lid/étagère ts = 3.2, trous ⌀3.9 | SFF-8301 Table 3-1 | ✅ |
| Jeu X inter-disques | 7 mm (canaux d'air) | conception | ✅ |
| Position cage | x 12.1..269.9, y 48..195, z 107.2..209.05 | — | ✅ |

## Alimentation (Corsair CX430, 150 × 86 × 140)

| Besoin | Mesure v2 | Source | Statut |
|---|---|---|---|
| Volume PSU | x 66..216, y 216..356, z 16..102 (pieds 12 mm) | doc Corsair | ✅ |
| Découpe IEC + interrupteur | cutout (151×87) +1 mm de jeu, panneau arrière — **toute la face arrière du PSU exposée**, IEC + basculeur ON/OFF accessibles | doc Corsair | ✅ |
| Air d'admission PSU | fentes sous PSU au panneau arrière (z 6..14) | conception | ✅ |
| Démarrage sans carte mère | **Add2PSU** (auto, cf. docs/components/add2psu.md) ou `atx_bridge` pont fixe de secours + interrupteur secteur | spec ATX | ✅ |
| Budget puissance | 8×~9 W régime / ~200 W spin-up + 2 fans ≪ 384 W 12 V | datasheet | ✅ |

## Refroidissement (2 fans 120 mm, push)

| Besoin | Mesure v2 | Source | Statut |
|---|---|---|---|
| Découpe fan ⌀114, fixations M4 carré 105 | centres (83, 205) × z 163, face avant | standard 120 mm | ✅ |
| Redondance (1 fan HS → toujours de l'air) | 2 fans indépendants | avis conception | ✅ |
| Flux forcé à travers les disques | fans collés à la face avant → 7 canaux de 7 mm → plenum arrière | conception | ✅ |
| Admission filtrable | grande grille avant (x 12..276, z 100..228) | conception | ✅ |
| Évacuation | grilles hautes arrière + PSU en série | conception | ✅ |

## Câblage SAS (2 breakouts SFF-8643 → 4× SFF-8482, queues ~200 mm)

| Besoin | Mesure v2 | Source | Statut |
|---|---|---|---|
| Passage des 2 câbles | 2 grommets ⌀36, panneau arrière x 78 / 205, z 158 | mesure queues | ✅ |
| Reach des queues (200 mm) | division à l'intérieur (~50 mm du panneau), chute 161 mm vers connecteurs y=195 | mesure | ✅ |
| Affectation | grommet gauche → disques 1-4, droit → 5-8 | conception | ✅ |
| Alignement connecteurs | grommets z 158 vs connecteurs z ~115..131 : chute douce | — | ⚠️ à valider avec les câbles réels |

## Structure / impression

| Besoin | Mesure v2.3 | Source | Statut |
|---|---|---|---|
| Plateau 1 m² | bed_max = 1000, **panneaux monoblocs** (max 352×252) | propriétaire | ✅ |
| Assemblage panneaux | inserts **Ruthex M4×8.1** (poches ⌀5.6×9.1) dans jetées d'angle 24×24 ; vis M4 × 12 | kit Ruthex (docs/components/inserts-ruthex.md) | ✅ |
| Fixation lid / struts | inserts **M3×5.7** (⌀4.0) | kit Ruthex | ✅ |
| Vis disques | 6-32 × 1/4" directes dans le lid 3.2 mm (pas d'insert : trous impériaux) | SFF-8301 | ✅ |
| Encombrement total | 282 × 360 × 260 | — | ✅ |
| Accès disques | capot (lid) démontable : 16 vis 6-32 accessibles par le dessus | conception | ✅ |
| Anti-vibration | — | — | ❌ **non traité** (TODO #R1) |

## Démarrage automatique (Add2PSU)

| Besoin | Mesure v2.3 | Source | Statut |
|---|---|---|---|
| DAS ON/OFF synchronisé avec la tour | module Add2PSU : Molex tour → relais → PS_ON du CX430 | docs/components/add2psu.md | ✅ |
| Emplacement module (70×30×15) | fond, zone x 24..94, y 240..270 ; 4 trous ⌀3.2 entraxe 64×24 | photo produit | ⚠️ entraxe à mesurer à réception |
| Passage du fil Molex tour→module | passe-câble ⌀12 au panneau arrière (x 141, z 200) | 2 fils 18 AWG | ✅ |

## Legs

- La v1 est archivée (`scad/boitier_8_sas_sata_atx_v1.scad`), auditée dans
  [audit-v1.md](audit-v1.md).
- Toute évolution dimensionnelle passe par les paramètres en tête du SCAD.
- Les composants externes (Add2PSU, Ruthex) sont documentés dans
  [docs/components/](../docs/components/) avec photos et règles de perçage.
