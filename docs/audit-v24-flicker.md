# Audit v2.4 → v2.5 (`scad/boitier_8_sas_v2.scad`)

Audit du fichier v2.4, déclenché par un **scintillement (flicker) important
de l'aperçu F5 dans OpenSCAD** (visible sur la découpe PSU du panneau arrière,
les fentes de ventilation, certains trous du lid/top). Méthode : analyse
statique du SCAD + rendus F6 + tests d'intersection CGAL sur copies.

Le rendu F6/STL n'a **jamais été faux** — le flicker est un artefact
d'affichage du moteur d'aperçu (OpenCSG, profondeur par z-buffer), qui
n'arrive pas à départager deux surfaces **exactement coplanaires**. Mais
l'analyse a mis au jour **6 vrais bugs géométriques** au passage.

## Cause du flicker : surfaces coplanaires

OpenSCAD 2021.01 (version locale) utilise OpenCSG en F5 : les primitives sont
rendues avec des tests de profondeur, sans booléen exact. Deux faces au même Z
rendent au même depth → le z-buffer tranche par pixel, ce qui dépend de
l'angle caméra → scintillement dès qu'on bouge la vue.

Deux familles de coplanarité dans la v2.4 :

1. **Volumes soustraits affleurants** — un cutter qui commence pile à la face
   du panneau (au lieu de dépasser) : sa face de départ est coplanaire avec
   la face du panneau. La v1 n'avait pas le problème car **tous ses cutters
   partent à `-1`** et font `t+2` (débordent des deux faces).
2. **Faces de solides coplanaires** — anneaux noyés dans l'épaisseur du
   panneau, faces de ghosts (témoin `%`) touchant exactement la face
   intérieure d'un panneau.

## Correctifs anti z-fighting (géométrie finale inchangée)

| Endroit | v2.4 | v2.5 |
|---|---|---|
| rear : découpe PSU (l.149) | extrusion `t+2` partant à `z=0` | part à `z=-1`, hauteur `t+4` |
| rear : fentes colonnes + sous-PSU | idem, affleurantes | idem, débordantes |
| top : events plenum | affleurants face intérieure | débordants |
| lid : 16 trous 6-32 + 2 trous M3 | `clrh(h=ts+2)` à `z=0` | décalés à `-1`, `h=ts+4` |
| bottom : 4 trous Add2PSU | `clrh(h=6)` affleurants | décalés à `-1` (traversants : identique) |
| rear : collerettes grommets | anneau `h=t` noyé dans le panneau (inutile en F6, faces coplanaires) | **saillante 1 mm côté intérieur** (`z=t..t+1`) : renfort réel, aucune face coplanaire |
| ghosts PSU/fans/drives/Add2PSU | faces témoin touchant exactement les panneaux | jeu +0.3 mm (0.3 pour fans, profondeur −0.3 PSU) |
| fan_guard : 16 rayons | 2 boucles se doublaient sur 90..157.5° + faces coplanaires avec le carré | 12 rayons uniques, enfoncés 0.2 mm de chaque face |

Convention à retenir pour tout futur SCAD : **un cutter dépasse toujours des
deux faces** (`translate(...,-1)` + hauteur `+2`), et un ghost ne touche
jamais exactement une surface réelle.

## Bugs géométriques trouvés (et corrigés)

### 1. Grille avant : fop calculées en coordonnées monde (bug +4 mm)
`fop_x0/x1/y0/y1()` utilisaient `fan_cx=[83,205]`/`fan_cz=163` (monde) alors
que `front()` travaille en local (`lx=Xm-4`, `ly=Zm-4`) : toute la grille
(barreaux + traverses) était décalée de **+4 mm** vers x/y par rapport aux
découpes fans. Corrigé : `-4-` ajouté dans les 4 fonctions.

### 2. Barreaux bouchant des trous de vis fans
Barreaux verticaux tous les 14 mm sur toute la hauteur : le barreau à
x=129 couvrait le trou de vis fan à x=131.5 (61 % du ⌀4.5 scellé), idem
x=257.5 ; la traverse basse rognait 0.75 mm sur le haut des 4 trous bas.
Correctif v2.5 : barreaux percés aux 8 positions (passage ⌀5), traverses
**supprimées** (une fois les fop recalées, elles étaient entièrement noyées
dans la matière — donc déjà inutiles en F6).

### 3. Trou M4 rear (137,12) dans la découpe PSU
Le trou milieu-bas du panneau arrière (monde x=141, z=16) tombe **dans la
découpe PSU** (x 65.5..216.5, z 15.5..102.5) : plus aucune matière à cet
endroit (trou + fraisage = no-op). Supprimé de la liste ; le rear reste fixé
aux 4 coins + milieu-haut.

### 4. Strut : trou M4 traversant avalant la poche insert M3
`strut()` perçait un passage M4 **traversant** (`h=102`, axe 12,12) qui
détruisait la poche insert M3 de la tête (même axe, visée de l'étagère) :
la vis M4 fond→strut traversait jusqu'à l'insert. Corrigé : pilote M4
**borgne** `h=13` (M4×12 = 4 mm fond + 8 mm dans le strut).

### 5. Struts décalés de 12 mm vs leurs trous
`assembly()`/`exploded()` plaçaient les struts à `translate([xx, yy-12, 4])`
(avec un `xx-12+12-12+12` résiduel = `xx`) alors que les trous du fond et de
l'étagère sont aux axes `(xx, yy)`. Corrigé : `translate([xx-12, yy-12, 4])`
(strut = cube 24×24 posé par son coin, centre aux axes de trous).

### 6. Étagère : fraises M3 du mauvais côté
Les fraisages des vis M3 strut→étagère étaient côté **dessous** (z=0), donc
les têtes de vis saillaient **sous l'étagère** — côté où reposent les
disques (faces basses sur l'étagère) : blocage du montage. Corrigé : fraisage
côté dessus (`z=ts-1.9..ts+0.1`), têtes affleurantes côté disques.

### 7. front/top : fraisages M4 côté intérieur
`m4_csk()` fraise côté `z=0`. Pour rear/side/bottom, le local z=0 est la face
extérieure — correct. Pour **front et top** (placés par `rotate([90,0,0])`
pour le front ; le top est suspendu), le local z=0 est la face **intérieure**
→ têtes de vis M4 saillantes de 1.2 mm à l'extérieur. Corrigé : nouveau
module `m4_csk_ext()` (fraise côté `z=t`) utilisé par `front()` et `top()`.

### 8. Lid ∩ poteaux d'angle : collision 147 mm³
Le lid est posé à y=26 (couvre y 26..352) ; les poteaux d'angle avant occupent
y 4..28 → **2 mm de chevauchement** sous le lid aux 2 coins avant (vérifié
par intersection CGAL : 147.6 mm³). Par ailleurs les trous M3 du lid visaient
les poteaux à monde y=38 et y=340 au lieu des centres 16/332, et les 16 trous
de vis disques étaient décalés de −4 mm (`sy-30` au lieu de `sy-26`).
Correctif : **encoches d'angle 24×2** dans le lid (les poteaux avant passent),
trous M3 repositionnés sur les poteaux **arrière** uniquement (les avant sont
sous le lid, non vissables — le lid tient aussi par le top), offset vis
disques corrigé (`sy-26` → les vis tombent pile sur `screw_y`).

## Validation

- 14 pièces rendues F6 : toutes `Simple: yes`, 1 volume (assembly = 10
  volumes, normal : pièces disjointes).
- Volumes comparés v2.4/v2.5 (script STL) : deltas uniquement sur les
  changements volontaires — rear +2249 mm³ (= 2 collerettes), strut +1262
  (pilote borgne), front −7441 (grille), fan_guard −899 (rayons) ;
  **top/left/right/bottom/lid/corner_post : ±0.00 mm³**.
- Intersection poteau avant × lid : vide après encoches (avant : 147.6 mm³).
- STL régénérés (13) + renders `*_v25.png` ; grommet ⌀36 : trou devenu 5 mm
  d'épaisseur avec la collerette — clip à vérifier à réception (TODO).
