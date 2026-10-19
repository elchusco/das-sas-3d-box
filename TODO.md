# TODO — points à fignoler avant impression

Suivi des finitions de la v2 (`scad/boitier_8_sas_v2.scad`).
Ordre suggéré indiqué par 🔢.

## SCAD / géométrie

- [ ] **#1 🔢 Joints de segmentation** — les ergots/slots existent mais certains
  recouvrements de quarts se chevauchent (z-fighting visible au rendu).
  Nettoyer les lap entre pièces front/rear/left/right/bottom/top ; vérifier
  chaque joint à la vue (rendu par face).
- [ ] **#2 🔢 Grilles** — harmoniser `front_bars()` avec les découpes fans ;
  vérifier que les barreaux ne traversent pas les découpes ; ajouter
  traverses de renfort aux bords d'ouvertures.
- [ ] **#3 🔢 Anti-vibration** — 8 disques 7200 rpm sur rails rigides = résonance.
  Options : (a) plots élastomères sous les struts/étagère, (b) rondelles
  caoutchouc sous les 16 vis 6-32 du lid, (c) grommets caoutchouc dans les
  trous du lid. Choisir + modéliser.
- [ ] **#4 `shelf_R()`** — fonction `sy_local()` provisoire, trous de vis
  latéraux du panneau droit à recalculer proprement (ou supprimer : la
  fixation lid suffit peut-être).
- [ ] **#5 `box_foot` ×4** — pieds à positionner dans bottom (trous absents
  du fond pour l'instant) ; prévoir caoutchouc/adhésif sous les pieds.
- [ ] **#6 Vue éclatée + nomenclature** — `part="exploded"` pour le montage,
  export STL de chaque pièce dans `stl/` (script de batch à ajouter au README).
- [ ] **#7 Chevauchement étagère/struts** — vérifier les têtes de vis des struts
  (vis par le dessous) vs l'étagère (z 104..107.2) : fraisage à prévoir.
- [ ] **#8 `fan_guard`** — grille OK mais à recoupler avec `fan_screw` (⌀4.5)
  et prévoir la pose par l'extérieur (vérifier le sens).
- [ ] **#9 Renfort grommets** — `grommet_ring` rendu séparément ; décider :
  imprimer fusionné avec le panneau arrière (mieux) ou coller après coup.
- [ ] **#10 Z-fight ghosts** — les fantômes (disques/PSU/fans %) se superposent
  aux panneaux au rendu ; cosmétique, mais gêne la validation visuelle.

## Vérifications physiques (propriétaire)

- [ ] **Plateau d'impression** : relever la taille réelle → ajuster `bed_max`.
- [ ] **Câbles SAS réels** : vérifier le reach avec les queues de 200 mm une
  fois la tower et le DAS côte à côte (les grommets sont à z 158 ; les
  connecteurs disques à y 195, z ~107..131).
- [ ] **Vis 6-32 × 1/4"** : en quantité (16 pour le lid + 8 fans M4 + M4 structure).
- [ ] **Interrupteur secteur CX430** : vérifier qu'il est actionnable par la
  découpe arrière (il est en face arrière du PSU).
- [ ] **Pont PS_ON** : `atx_bridge` imprimé OU pont soudé sur un snippet ATX
  24 broches (plus fiable).

## Améliorations futures (hors périmètre v2)

- [ ] Filtre à poussière amovible sur la grille avant.
- [ ] Fenêtre latérale gauche (PCB des disques visible) ou logarithme gravé.
- [ ] Variante : support SSD 2.5" ×2 dans le plenum arrière (spare OS).
- [ ] Contrôle PWM : prévoir un passage ⌀10 dans le panneau arrière pour un
      câble fan vers la MB du 5820 (si essai de régulation côté host).
- [ ] Modéliser l'affectation disques 1-8 ↔ ports HBA (documentation câblage).
