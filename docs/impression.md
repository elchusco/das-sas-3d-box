# Impression — matériau, réglages, questions à l'imprimeur

Pièces : `stl/v27/` (générées par `tools/build.sh v27`, qui affiche aussi le
tableau des bbox et des masses). Les quantités sont dans [bom.md](bom.md).

## Questions à poser à l'imprimeur (avant d'envoyer les STL)

1. **Taille de plateau réelle.** Le modèle suppose un plateau d'environ 1 m²
   (hypothèse du projet). La plus grande pièce fait **352 × 274 mm**
   (fond, top) ; les flancs font 352 × 252, l'étagère 273 × 166 × 105.
   En dessous de 360 × 280 utiles, il faut redécouper les panneaux : à
   signaler **avant** impression.
2. **Matériau disponible : PETG ou ASA ?** Le PLA est exclu : les disques
   tournent à 40–50 °C et le PLA flue dès ~55 °C sous charge (étagère, vis).
   PETG ou ASA. L'ABS va aussi, mais il gauchit sur les grandes plaques.
3. **Enceinte fermée ?** Elle est indispensable pour l'ASA et l'ABS sur des
   panneaux de 350 mm. Sans enceinte, choisir le PETG.
4. **Quantité de filament.** Masse pleine calculée : **≈ 4.2 kg**. Avec les
   réglages ci-dessous, prévoir **≈ 2.5–3 kg**, soit 3 bobines de 1 kg.
   Qui fournit le filament ?
5. **Temps machine.** Les 6 panneaux sont longs (plusieurs heures chacun).
   Demander une estimation après tranchage, et si l'imprimeur peut les
   passer en plusieurs sessions.
6. **Buse et hauteur de couche.** Une buse de 0.4 mm suffit. Une buse de
   0.6 mm accélère les panneaux, mais les trous M3 (⌀3.2) et les poches
   d'inserts deviennent moins précis : dans ce cas, garder la 0.4 pour
   les petites pièces (struts, poteaux, cornières, barrette).
7. **Calibration des trous.** Lui demander d'imprimer d'abord le petit
   **gabarit de test** (`atx_bridge` ou un `strut`) et de vérifier qu'un
   insert M3 Ruthex rentre à chaud dans une poche ⌀4.0 et qu'une vis M4
   passe dans ⌀4.3. S'il compense les trous dans le slicer (« XY hole
   compensation »), il ne faut pas le faire en double.
8. **Pose des inserts : lui ou toi ?** Elle se fait au fer (~200 °C). Si
   c'est l'imprimeur, il lui faut le kit Ruthex (RX-M3×5.7 ×33, RX-M4×8.1 ×24).
9. **TPU** (si l'option `fan_iso` est retenue) : peut-il imprimer 2 joints
   de 1.5 mm en TPU 95A ?

## Matériau

| | PETG (recommandé) | ASA |
|---|---|---|
| Tenue en température | ~70 °C (Tg ≈ 80) | ~90 °C |
| Gauchissement grandes plaques | faible | moyen, enceinte nécessaire |
| Inserts à chaud | très bons | bons |
| Odeur / fumées | faibles | styrène, aérer |

## Réglages

| Pièce | Périmètres | Remplissage | Couches haut/bas | Remarque |
|---|---|---|---|---|
| Panneaux (front, rear, left, right, top, bottom) | 3 | 20 % gyroïde | 4 / 4 | bordure (brim) 5 mm aux coins si gauchissement |
| Étagère, plaque de cage | 4 | 30 % | 5 / 5 | portent les disques (8 × 0.7 kg) |
| Poteaux, struts | 4 | 40 % | 5 / 5 | inserts M4 et M3 dedans |
| Cornières, barrette | 4 | 40 % | 4 / 4 | — |
| Pieds | 4 | 50 % | 5 / 5 | — |
| Joints fan (TPU) | 2 | 100 % | — | vitesse lente |

Règle générale : **≥ 4 périmètres autour de toute poche d'insert**, sinon
l'insert fend la paroi à la pose ou à l'arrachement.

## Orientation (sans support, sauf les poteaux couchés)

| Pièce | Posée sur | Remarque |
|---|---|---|
| Panneaux | grande face | **arrière** : collerettes des grommets vers le haut ; **fond** : plots PSU, bossages et passants vers le haut |
| Étagère | dessous (z=0) | joues, piliers et peignes vers le haut |
| Plaque de cage | dessous (z=0) | lèvre déflecteur vers le haut |
| Struts | pied (pilote M4 en bas) | insert M3 en haut |
| Poteaux | **sur le flanc de 24 × 252** | couché : les poches pied/tête sont horizontales et le poteau est plus solide en flexion qu'imprimé debout ; il faut alors un support dans les poches M4 latérales du côté plateau, ou bien imprimer debout (252 mm, sans support, plus fragile) |
| Cornières | dos de l'aile z=0 (face contre panneau A) | |
| Barrette | face 273 × 12 | fentes de colliers verticales |
| Pieds | dessus (logement patin vers le haut) | |

## Inserts

- Fer à ~200 °C (PETG) / ~230 °C (ASA), embout Ruthex adapté.
- Collet **affleurant** la surface. Laisser refroidir avant tout vissage.
- Inventaire : M4×8.1 ×24 (poteaux), M3×5.7 ×33 (struts ×9, piliers ×4,
  Add2PSU ×4, cornières ×14, barrette ×2), cf. [bom.md](bom.md).

## Retrait / tolérances

- Les jeux sont de **0.3 mm** (étagère/flancs, plaque/disques, barrette).
  Si l'imprimeur mesure un retrait > 0.3 % sur un panneau de 352, le
  signaler : l'étagère (273.4 entre flancs de 274) peut forcer.
- Les trous 6-32 (⌀3.9) et M4 (⌀4.3) supposent une compensation nulle.
