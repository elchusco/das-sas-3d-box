# Tableau de conformité — v2.6 (`scad/boitier_8_sas_v26.scad`)

> Mis à jour pour la v2.6 sur les points corrigés par l'audit v2.5
> ([audit-v25.md](audit-v25.md)).

Besoin ↔ mesure ↔ source ↔ statut. Valeurs "monde" du repère SCAD
(X largeur 0..282, Y profondeur 0..360, Z hauteur 0..260).

## Disques (8 × Seagate Constellation ES.3 ST4000NM0023, SAS 4 To)

| Besoin | Mesure v2 | Source | Statut |
|---|---|---|---|
| Enveloppe disque 101.85 × 147.0 × 26.1 max | pitch 32.6 = 26.1 + 6.5 air ; cage 254.3 de large | SFF-8301 / Seagate Fig.12 | ✅ |
| Orientation | sur tranche, PCB cote −X (panneau gauche) | choix conception | ✅ |
| Trou latéral #1 : 28.50 mm du bout connecteurs | screw_y = conn_y − 28.50 = **166.5** | SFF-8301 A8 | ✅ |
| Trou latéral #2 : 130.10 mm | screw_y = conn_y − 130.10 = **64.9** | SFF-8301 A8+A9 | ✅ |
| Offset face PCB : 6.35 mm | screw_x = drive_x[i] + 6.35 | SFF-8301 A10 | ✅ |
| Vis 6-32 UNC, pénétration 2.39..3.56 | plaque de cage ts = 3.2 à 0.3 mm des disques → 2.85 mm, trous ⌀3.9 | SFF-8301 Table 3-1 | ✅ |
| Jeu X inter-disques | 6.5 mm (canaux d'air), joues latérales 9.05 mm | conception | ✅ |
| Position cage | x 13.85..268.15, y 48..195, z 107.2..209.05 | — | ✅ |

## Alimentation (Corsair CX430, 150 × 86 × 140)

| Besoin | Mesure v2 | Source | Statut |
|---|---|---|---|
| Volume PSU | x 66..216, y 216..356, z 16..102 sur 4 plots 20×20×12 venus du fond | doc Corsair | ✅ |
| Fixation PSU | 4 trous 6-32 oblongs ±0.75 au panneau arrière, ventilateur vers le haut | mesure CX430 | ✅ |
| Découpe IEC + interrupteur | découpe suivant grille + interrupteur + IEC mesurés (+2 mm), ≥ 2.55 mm de matière autour des trous | mesure CX430 | ✅ |
| Air d'admission PSU | 7 fentes sous le PSU (x 90..191, z 6..14), entre les plots | conception | ✅ |
| Démarrage sans carte mère | **Add2PSU** (auto, cf. docs/components/add2psu.md) ou `atx_bridge` pont fixe de secours + interrupteur secteur | spec ATX | ✅ |
| Budget puissance | 8×~9 W régime / ~200 W spin-up + 2 fans ≪ 384 W 12 V | datasheet | ✅ |

## Refroidissement (2 fans 120 mm, push)

| Besoin | Mesure v2 | Source | Statut |
|---|---|---|---|
| Découpe fan ⌀114, fixations M4 carré 105 | centres (80, 202) × z 160, face avant ; poteaux 14×24 hors emprise | standard 120 mm | ✅ |
| Redondance (1 fan HS → toujours de l'air) | 2 fans indépendants | avis conception | ✅ |
| Flux forcé à travers les disques | fans → 7 canaux de 6.5 mm (cage fermée : joues + plaque + lèvre déflecteur) → plenum arrière | conception | ✅ |
| Admission filtrable | grande grille avant (x 12..276, z 100..228) | conception | ✅ |
| Évacuation | 2 rangées de 23 fentes arrière (z 106..126, 212..248) + 13 fentes du top + PSU | conception | ✅ |

## Câblage SAS (2 breakouts SFF-8643 → 4× SFF-8482, queues ~200 mm)

| Besoin | Mesure v2 | Source | Statut |
|---|---|---|---|
| Passage des 2 câbles | 2 grommets ⌀36, panneau arrière x 78 / 205, z 158 | mesure queues | ✅ |
| Reach des queues (200 mm) | division à l'intérieur (~50 mm du panneau), chute 161 mm vers connecteurs y=195 | mesure | ✅ |
| Affectation | grommet gauche → disques 1-4, droit → 5-8 | conception | ✅ |
| Alignement connecteurs | grommets z 158 vs connecteurs z ~115..131 : chute douce | — | ⚠️ à valider avec les câbles réels |

## Structure / impression

| Besoin | Mesure v2.6 | Source | Statut |
|---|---|---|---|
| Plateau 1 m² | bed_max = 1000, **panneaux monoblocs** (max 352×252) | propriétaire | ✅ |
| Assemblage panneaux | inserts **Ruthex M4×8.1** (poches ⌀5.6×9.1) dans jetées d'angle 24×24 ; vis M4 × 12 | kit Ruthex (docs/components/inserts-ruthex.md) | ✅ |
| Fixation étagère / plaque de cage / Add2PSU | inserts **M3×5.7** (⌀4.0) ×17 | kit Ruthex | ✅ |
| Vis disques | 6-32 × 1/4" à travers la plaque de cage 3.2 mm (pas d'insert : trous impériaux) | SFF-8301 | ✅ |
| Encombrement total | 282 × 360 × 260 | — | ✅ |
| Accès disques | dépose du top puis de la plaque de cage (4 M3 + 16 vis 6-32) | conception | ✅ |
| Étagère | struts 3×3, portée 117 mm → flèche ≈ 0.5 mm | calcul | ✅ |
| Anti-vibration | logement patin ⌀20 sous les pieds ; rien côté disques | — | ⚠️ partiel (TODO) |

## Démarrage automatique (Add2PSU)

| Besoin | Mesure v2.6 | Source | Statut |
|---|---|---|---|
| DAS ON/OFF synchronisé avec la tour | module Add2PSU : Molex tour → relais → PS_ON du CX430 | docs/components/add2psu.md | ✅ |
| Emplacement module (70×30×15) | sous l'étagère, x 52..122, y 137..167, 4 bossages 9.1 mm + inserts M3, entraxe 64×24 | photo produit | ⚠️ entraxe à mesurer à réception |
| Passage du fil Molex tour→module | passe-câble ⌀12 au panneau arrière (x 141, z 200) | 2 fils 18 AWG | ✅ |

## Legs

- La v1 est archivée (`scad/boitier_8_sas_sata_atx_v1.scad`), auditée dans
  [audit-v1.md](audit-v1.md).
- Toute évolution dimensionnelle passe par les paramètres en tête du SCAD.
- Les composants externes (Add2PSU, Ruthex) sont documentés dans
  [docs/components/](../docs/components/) avec photos et règles de perçage.
