# TODO — points à fignoler avant impression

État v2.5 : v2.4 (structurelles #1/#7/#8, grilles fines #4, encoches #5,
ghosts #6, fan_guard #R2, vue éclatée + STL #R3) **+ anti z-fighting F5**
(découpes débordantes, collerettes grommets saillantes 1 mm, ghosts +0.3)
**+ corrections** : grille avant recalée (fop en coords locales, bug +4 mm,
barreaux bouchant 2 vis fans), struts (pilote M4 borgne, placement −12),
fraises M3 étagère côté dessus, fraisages M4 front/top côté extérieur,
lid (encoches d'angle poteaux, trous M3 poteaux arrière, offset vis) →
**faits**. STL régénérés (13 pièces, solides valides).

## v2.6 — corrections audit v2.5 (`scad/boitier_8_sas_v26.scad`) ✅

- [x] **B1** Plaque de cage au ras des disques (z 209.35, pénétration 6-32 = 2.85 mm)
- [x] **B2** Fans recentrés x 80/202 + poteaux 14×24 : 0 collision
- [x] **B3** Poteaux en miroir (`corner_post`/`corner_post_m`), poches 2 faces + pied + tête M4 ; trous orphelins supprimés
- [x] **B4** Plus de lid sous le top (plaque limitée à la cage)
- [x] **B5** Struts en coordonnées monde (`strut_x/strut_y`), trous dérivés
- [x] **B6** 4 plots 12 mm sous le PSU + 4 trous ATX 6-32 (fenêtre arrière réduite de 11 mm)
- [x] **M1** Sorties : fentes du top débouchées, 2 rangées de fentes arrière entre poteaux, lèvre déflecteur
- [x] **M2** Add2PSU sous l'étagère (x 52..122, y 137..167) sur 4 bossages 9.1 mm
- [x] **M3** Struts 3×3 (portée 117 mm, flèche ≈ 0.5 mm) + joues latérales
- [x] **M4** sideR : `m4_csk_ext`
- [x] Mineurs : grille avant pas 12, fan_guard 16 rayons uniques, pieds (fraisage intérieur + logement patin ⌀20)

### Reste à vérifier sur pièces (v2.6)

- [x] **Trous ATX** : mesurés sur le CX430 (2026-11-01), ventilateur **vers le haut**
  (aspire le plenum) : (6.5,81.5) (144.5,81.5) (6.5,16.5) (120.5,6.5), oblongs ±0.75.
- [x] **Fenêtre PSU** : découpe en 3 rectangles suivant grille / interrupteur / IEC
  mesurés (IEC x 97..146 dépassait l'ancienne fenêtre) ; ≥ 2.55 mm de matière
  autour des trous.
- [ ] **Vis PSU** : 6-32 × 3/8" (panneau 4 mm).
- [ ] **Rainures 4×4 sur les 12 arêtes** (panneaux aux cotes intérieures) : esthétique,
  non traité.
- [ ] **Anti-vibration disques** : non traité (patins sous les pieds seulement).

## v2.7 — fiabilisation + outillage (`scad/boitier_8_sas_v27.scad`) ✅

- [x] **A1** Joues ajourées (paroi 2.5 + piliers 9×10) : canal de 7 mm côté
  extérieur des disques 1 et 8 (9 canaux au total)
- [x] **A2** Peignes de calage sur l'étagère (2 rangées, h 5)
- [x] **A3** Barrette serre-câbles `cable_bar` (y 235, z 140), vissée par les flancs
- [x] **A4** 8 passants pour colliers dans le fond (câbles du CX430)
- [x] **A5** Option `sas_ext` : fenêtres 15×90 pour équerres SFF-8644 (cote à confirmer à la commande)
- [x] **A6** Courant de démarrage documenté (`docs/components/cx430.md`)
- [x] **B1** 7 cornières `edge_rail_x/y` (arêtes horizontales sauf arrière-basse)
- [x] **B2** Option `fan_iso` : joints TPU `fan_gasket`, trous ⌀5.5 (l'étagère recule de 1.5 mm)
- [x] **B3** `docs/impression.md` (matériau, réglages, questions à l'imprimeur)
- [x] **C** `tools/check.sh` (72 tests CGAL), `tools/build.sh`, constantes dérivées, STL v2.5 → `stl/v25/`
- [x] **D** `docs/bom.md`, `docs/assemblage.md`, `tools/hdd-temp.sh`

### Reste à vérifier (v2.7)

- [ ] **Équerres SFF-8644** (si `sas_ext`) : cote réelle de la fenêtre et des pattes.
- [ ] **Prises SATA du CX430** : nombre de câbles / prises (répartition 4 + 4 minimum).
- [ ] **Démarrage échelonné** HBA330 : observer à la première mise sous tension.
- [ ] **Rainures 4×4 extérieures** des arêtes : toujours non traitées (esthétique ;
  les cornières sont intérieures).
- [ ] **Anti-vibration disques** : peignes = calage, pas amortissement.

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
- [x] ~~Z-fighting F5 (flicker) + bugs géométriques associés~~ — v2.5 :
  découpes débordantes, collerettes grommets saillantes, ghosts +0.3,
  grille avant recalée (bug +4 mm, barreaux bouchant des vis), struts
  (pilote borgne, placement), fraises étagère, fraisages front/top,
  lid/poteaux (encoches, trous M3) → cf. `docs/audit-v24-flicker.md`.

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
- [ ] **Visserie** : liste à jour (v2.7) dans [docs/bom.md](docs/bom.md).
- [ ] **Interrupteur secteur CX430** : actionnable via la découpe (face
  arrière PSU exposée) — vérifier au montage.
- [ ] **Molex libre dans la tour** : repérer une prise Molex/SATA free du PSU
  Dell pour l'Add2PSU.
- [ ] **Fans à commander** : 2× 120 mm PWM (Arctic P12 PWM PST ou Noctua
  NF-P12 redux-1700) ± contrôleur NA-FC1 (choix non figé, voir session).
- [ ] **Documentation câblage** : affectation disques 1-8 ↔ ports HBA
  (`docs/cablage.md` à créer à la mise en service, cf. assemblage.md étape 17).
