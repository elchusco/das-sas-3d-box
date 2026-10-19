# TODO — points à fignoler avant impression

Suivi des finitions de la v2.3 (`scad/boitier_8_sas_v2.scad`).
Ordre suggéré indiqué par 🔢.

## Reportés (arbitrage propriétaire — plus tard)

- [ ] **#R1 Grilles front/rear** — harmoniser les barreaux avec les découpes,
  éventuellement remplacer les barreaux intégrés par des `fan_guard` vissés.
- [ ] **#R2 Anti-vibration** — 8 disques 7200 rpm sur rails rigides = résonance.
  Options : (a) plots élastomères sous les struts/étagère, (b) rondelles
  caoutchouc sous les 16 vis 6-32 du lid, (c) grommets caoutchouc. Choisir.
- [ ] **#R2 fan_guard** — grille 120 mm prête (`part="fan_guard"`, 2×) : à
  finaliser (éprouvette fixation M3 vs insertion encastrée).
- [ ] **#R3 Vue éclatée + STL** — `part="exploded"` + export STL des pièces
  dans `stl/` (script batch).
- [ ] **#R4 Filtre à poussière amovible** sur la grille avant.
- [ ] **#R5 SSD 2.5"** ×2 dans le plenum arrière (spare OS).
- [ ] **#R6 Fenêtre latérale** (PCB visible) ou gravure logo.

## Obsolete (résolu par v2.3)

- [x] ~~Joints de segmentation~~ — panneaux monoblocs depuis bed_max=1000.

## SCAD / géométrie (à traiter avant impression)

- [ ] **#1 🔢 Chevauchement étagère/struts** — vérifier les têtes de vis des
  struts (inserts M3 dans la tête) vs l'étagère : la poche `rtx3()` est
  orientée tête vers le haut, la vis traverse l'étagère par dessous. Valider
  le sens de l'insert (montage réel) et le fraisage.
- [ ] **#2 🔢 Add2PSU : vérifier les perçages réels** — l'entraxe 64×24 vient
  de la photo ; mesurer la carte à réception et corriger `a2p_hole_dx/dy`.
- [ ] **#3 Passe-câble Molex** — le ⌀12 est positionné à (141, z 200) ; vérifier
  qu'il ne gêne pas le PSU (x 66..216) ni le plenum, et ajuster si besoin.
- [ ] **#4 Grille d'extraction arrière** — les colonnes de fentes (10×8) sont
  volontairement grossières ; possibilité de passage en fentes fines 4 mm
  (plus joli, plus d'empêchement doigts) si le temps d'impression le permet.
- [ ] **#5 Étagère : encoches d'air** — les 2 encoches 20×20 aux coins avant
  de l'étagère court-circuitent partiellement le flux ; à valider utile ou
  à supprimer.
- [ ] **#6 Ghosts** — les fantômes (disques/PSU/fans/Add2PSU %) se superposent
  aux panneaux au rendu ; cosmétique, gêne la validation visuelle.
- [ ] **#7 Pieds (`box_foot` ×4)** — trous de fixation absents du fond ;
  prévoir 4 trous M4 + inserts, ou cône imprimé incorporé au fond.
- [ ] **#8 Fraisage des trous M4 de fixation panneaux** — les trous ⌀4.3
  traversants sont prévus pour vis M4 dans insert ; ajouter un fraisage
  côté extérieur si les têtes dépassent (sinon vis TH M4 × 12 head low).

## Vérifications physiques (propriétaire)

- [ ] **Add2PSU à la réception** : mesurer l'entraxe réel des 4 trous
  (photo = ~64 × ~24) → corriger `a2p_hole_dx/dy` si besoin.
- [ ] **Câbles SAS réels** : vérifier le reach avec les queues de 200 mm une
  fois la tower et le DAS côte à côte (division au ras du grommet).
- [ ] **Vis 6-32 × 1/4"** : en quantité (16 pour le lid) ; vis M4 × 12
  (~28) et M3 × 8/12 (~30) pour les inserts.
- [ ] **Interrupteur secteur CX430** : actionnable à travers la découpe
  arrière (face arrière du PSU exposée) — vérifier au montage.
- [ ] **Molex libre dans la tour** : repérer une prise Molex/SATA free du PSU
  Dell pour l'Add2PSU (2 fils 18 AWG à tirer vers le passe-câble ⌀12).
