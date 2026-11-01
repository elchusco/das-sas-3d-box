# TODO — points à fignoler avant impression

État v2.5 : v2.4 (structurelles #1/#7/#8, grilles fines #4, encoches #5,
ghosts #6, fan_guard #R2, vue éclatée + STL #R3) **+ anti z-fighting F5**
(découpes débordantes, collerettes grommets saillantes 1 mm, ghosts +0.3)
**+ corrections** : grille avant recalée (fop en coords locales, bug +4 mm,
barreaux bouchant 2 vis fans), struts (pilote M4 borgne, placement −12),
fraises M3 étagère côté dessus, fraisages M4 front/top côté extérieur,
lid (encoches d'angle poteaux, trous M3 poteaux arrière, offset vis) →
**faits**. STL régénérés (13 pièces, solides valides).

## Reportés (arbitrage propriétaire — plus tard)

- [ ] **#R1 Grilles front** — barreaux intégrés conservés (reco validée) ;
  option : passer les fans en `fan_guard` vissés si filtre à poussière voulu.
- [ ] **#R4 Filtre à poussière amovible** sur la grille avant — dépend du
  choix fan_guard vissé ; à traiter si besoin.
- [ ] **#R5 SSD 2.5"** ×2 dans le plenum arrière (spare OS).
- [ ] **#R6 Fenêtre latérale** (PCB des disques visible) ou gravure logo.
- [ ] **#R7 Contrôle PWM fans** — passage ⌀10 arrière + NA-FC1 (choix fans
  non figé, voir session).

## Obsolete (résolu par v2.3/v2.4)

- [x] ~~Joints de segmentation~~ — panneaux monoblocs (bed_max=1000).
- [x] ~~Chevauchement struts/étagère~~ — lumière M3.2 + fraisage tête dans
  l'étagère, insert M3 en tête de strut, vis M4 fond→strut traversante (#1).
- [x] ~~Pieds sans fixation~~ — 4 trous M4 fraisés au fond, `box_foot` ×4 (#7).
- [x] ~~Têtes de vis M4 saillantes~~ — fraisage ⌀8.6 côté extérieur sur tous
  les panneaux (front/rear/side/bottom/top) + lid côté supérieur (#8).
- [x] ~~Grilles arrière grossières~~ — fentes fines 5×8 (#4).
- [x] ~~Encoches étagère court-circuitant le flux~~ — supprimées (#5).
- [x] ~~Ghosts superposés au rendu des pièces seules~~ — `show_ghosts=false`
  disponible (#6).
- [x] ~~fan_guard décentré~~ — carré 124 recentré + 16 rayons + trous M4
  carré 105 alignés (#R2).
- [x] ~~Vue éclatée + STL manquants~~ — `part="exploded"` (explode=60) +
  13 STL exportés dans `stl/`, dimensions vérifiées par script (#R3).

## SCAD — reste éventuel

- [ ] **#2 Add2PSU : vérifier les perçages réels** — l'entraxe 64×24 vient de
  la photo ; mesurer à réception et corriger `a2p_hole_dx/dy`.
- [ ] **#3 Passe-câble Molex (141, z 200)** — vérifier l'absence de conflit
  avec le plenum une fois le câblage simulé.

## Vérifications physiques (propriétaire)

- [ ] **Add2PSU à la réception** : mesurer l'entraxe réel des 4 trous.
- [ ] **Grommets SAS à la réception** : avec la collerette saillante 1 mm
  (v2.5), le trou fait 5 mm d'épaisseur au lieu de 4 — vérifier que le
  grommet ⌀36 clippe flush ; sinon réduire la collerette.
- [ ] **Câbles SAS réels** : reach des queues 200 mm, division au ras du
  grommet (tower et DAS côte à côte).
- [ ] **Visserie** : 6-32 × 1/4" ×16 (disques), M4 × 12 (~28), M3 × 6/8 (~30).
- [ ] **Interrupteur secteur CX430** : actionnable via la découpe (face
  arrière PSU exposée) — vérifier au montage.
- [ ] **Molex libre dans la tour** : repérer une prise Molex/SATA free du PSU
  Dell pour l'Add2PSU.
- [ ] **Fans à commander** : 2× 120 mm PWM (Arctic P12 PWM PST ou Noctua
  NF-P12 redux-1700) ± contrôleur NA-FC1 (choix non figé, voir session).
- [ ] **Documentation câblage** : affectation disques 1-8 ↔ ports HBA.
