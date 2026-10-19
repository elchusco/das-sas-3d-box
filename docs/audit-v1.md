# Audit de la v1 (`scad/boitier_8_sas_sata_atx_v1.scad`)

Audit du fichier original `boitier_8_sas_sata_atx.scad` (empilement horizontal
des disques, boîtier 300×440×390), effectué par analyse statique + rendus.

## Conforme

- Enveloppe disques 101.6 × 147 × 26.1 (standard SFF-8301)
- Pitch 33.1 mm (26.1 + 7) : généreux, favorable au flux
- Découpe ATX 150 × 86 (+1 mm de jeu), profondeur réservée 180
- Trous fans 105/⌀114 (standard 120 mm)
- Passage câbles SAS 92 × 36
- Hauteur totale OK (cage top ~312 < 390)

## Défauts bloquants

### 1. Conflit fan bas / découpe PSU (panneau arrière)
Fan bas centré z=88 (⌀114 → z 31..145) vs découpe PSU z 23.5..110.5,
x 127.5..278.5 : **les deux découpes fusionnent** (forme en arche visible sur
le rendu `renders/assembly_v1.png`). Le fan bas est inutilisable.

### 2. Fans pas derrière la cage
Fans centrés x=178, cage x 26..144 : le flux souffle à ~50–90 mm à droite des
disques — l'air court-circuite la baie.

### 3. `drive_cage` / `drive_rail` désalignés
- Le rail gauche sort à x −11..3 (à travers le montant) ; le rail droit décalé.
- Le 1er trou de vis tombe dans le vide.
- Les disques débordent de 15 mm côté connecteurs — non supportés.
Cage à refonte paramétrique complète.

### 4. Trous de rails ≠ pattern SFF-8301
Positions v1 `[12, 73.5, 147]` vs positions officielles latérales
28.50 / 130.10 (A8, A8+A9) à 6.35 (A10) de la face PCB. **Les vis ne tombent
pas dans les trous des disques.**

### 5. Impression
Panneaux de 440 mm > plateau → segmentation nécessaire (absente en v1).

### 6. Manques fonctionnels
- Rien pour court-circuiter **PS_ON** : un ATX ne démarre pas sans carte mère
  (il faut un pont sur le 24 broches + interrupteur secteur).
- Pas d'anti-vibration (8 disques 7200 rpm dans une boîte légère = résonance).
- `clearance` défini mais jamais utilisé.

## Décision

Refonte complète en v2 avec changement de concept : **disques sur tranche**
(voir README.md — avantages fans/vis/câbles), layout compact 282×360×260.
La v1 est archivée telle quelle.
