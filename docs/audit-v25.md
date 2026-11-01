# Audit v2.5 (`scad/boitier_8_sas_v2.scad`, commit b1dd150)

Audit complet du modèle v2.5 avant impression. Méthode : lecture statique du
SCAD et des docs, tests d'intersection CGAL (F6) sur les pièces placées comme
dans `assembly()`, calculs de flèche à la main.

**Verdict : non imprimable en l'état.** Il y a 6 défauts bloquants. Certains
viennent de correctifs v2.5 incomplets (lid/poteaux, struts).

## Tests CGAL

Script de test (à lancer depuis n'importe quel répertoire de travail) :

```scad
include </chemin/vers/scad/boitier_8_sas_v2.scad>
module P_lid() translate([4,26,H-t-ts]) lid();
module P_posts() for (px=[4,W-28], py=[4,D-28]) translate([px,py,4]) corner_post();
module G_fans() for (cx=fan_cx) translate([cx-fan_side/2, 4.3, fan_cz-fan_side/2]) cube([fan_side,25,fan_side]);
module G_psu() translate([psu_x0, psu_y0, psu_z0]) cube([psu_w, psu_d, psu_h]);
module G_a2p() translate([a2p_x, a2p_y, t]) cube([a2p_l, a2p_w, 15]);
if (test=="lid_posts")  intersection(){ P_lid();  P_posts(); }
if (test=="fans_posts") intersection(){ G_fans(); P_posts(); }
if (test=="a2p_psu")    intersection(){ G_a2p();  G_psu();   }
```

```sh
openscad -o lid_posts.stl -D 'part="none"' -D 'test="lid_posts"' chk.scad
# volume = somme des volumes signés des facettes (script Python ~10 lignes)
```

| Test | Volume d'intersection | Attendu |
|---|---|---|
| lid ∩ poteaux d'angle | **2 911 mm³** | 0 (audit v24 annonçait « vide ») |
| fans 120 ∩ poteaux d'angle | **45 322 mm³** | 0 |
| Add2PSU ∩ PSU CX430 | **2 520 mm³** | 0 |

## Défauts bloquants

### B1. Lid 43.5 mm au-dessus des disques
Le lid est à z 252.8..256 (`H-t-ts`, l.423). Le haut des disques est à
z = 107.5 + 101.85 = **209.35**. Les vis 6-32 × 1/4" (pénétration 3.15 mm)
n'atteignent donc pas les trous latéraux. Les disques, posés sur tranche sur
l'étagère, ne sont tenus par **rien**.

### B2. Fans ∩ poteaux d'angle avant (45 322 mm³)
Fan gauche x 23..143 / poteau avant-gauche x 4..28 : 5 mm de recouvrement.
Fan droit x 145..265 / poteau avant-droit x 254..278 : 11 mm. Les deux sur
z 103..223, y 4..28. Les fans ne se montent pas. Les poteaux masquent aussi
une partie des découpes ⌀114.

### B3. Poteaux d'angle tous identiques : inserts manquants
`corner_post()` (l.310) a ses poches M4 uniquement sur les faces **−Y** et
**+X**, et il est posé sans miroir aux 4 coins (l.429). Bilan des vis
panneau → poteau :

| Panneau | Inserts en face des trous |
|---|---|
| avant | 4/4 |
| flanc droit | 4/4 |
| **arrière** | **0/4** (la face +Y des poteaux arrière n'a pas de poche) |
| **flanc gauche** | **0/4** (la face −X n'a pas de poche) |
| **fond** | **0/4** (aucune poche en pied de poteau) |
| **top** | **0/4** : la tête porte un insert **M3** (⌀4.0) alors que le top perce en **M4** |

Les 11 trous « milieu de bord » ne tombent en face d'aucune pièce : avant
(137,12)/(137,240), arrière (137,240), côtés (176,12)/(176,240) ×2,
fond/top (137,12)/(137,340). La poche z=130 des poteaux n'a pas de trou
correspondant.

### B4. Lid ∩ poteaux (2 911 mm³) : correctif v2.5 incomplet
- Le lid couvre y 26..352 et les poteaux arrière occupent y 332..356 :
  **18 mm de recouvrement** sur chaque coin arrière.
- La 2ᵉ encoche (l.277, `326-2`) est en fait au coin **arrière-gauche** et ne
  fait que 2 mm. Le coin **avant-droit** n'est pas entaillé (24×2 mm de
  collision).
- Les trous M3 du lid visent y = 332 (commentaire l.282, « centre 332 »). Le
  centre réel des poteaux arrière est **y = 344**.

### B5. Struts décalés de (−4, −4) mm : correctif v2.5 #5 faux
`assembly()`/`exploded()` (l.426, l.398) placent les struts avec les
coordonnées **locales** du fond/de l'étagère (20/254, 53/123/193) dans le
repère **monde**. Les trous réels sont en monde à (24/258, 57/127/197). Le
commentaire l.425 le dit lui-même. Conséquences :
- la vis M3 de l'étagère tombe à 5.7 mm de l'insert de tête ;
- la vis M4 du fond rate le pilote.

### B6. PSU sans support
Rien ne porte le CX430 à z 16 : pas de berceau, et les « pieds 12 mm » ne sont
pas modélisés. Le panneau arrière n'a **aucun trou de fixation ATX**. La
découpe 151×87 est traversante, donc l'alim peut reculer et sortir par
l'arrière.

## Défauts majeurs

### M1. Flux d'air : sorties obstruées + by-pass
- Le lid, plein sur y 26..352, recouvre **toutes** les fentes du top
  (y 200..330).
- Les colonnes de fentes arrière (monde x 14..19 et 263..268, z 148..254) sont
  **plaquées contre les poteaux arrière** (x 4..28 / 254..278).
- 2 des 6 fentes sous le PSU (x 18..23, 258..263) sont aussi masquées par ces
  poteaux.
- Il reste donc comme sorties : 4 fentes 5×8 sous le PSU, le PSU lui-même et
  les fuites des grommets.
- Lame d'air de 43 mm au-dessus des disques (274 × 43 ≈ 11 800 mm²) contre
  ≈ 6 700 mm² de canaux entre et autour des disques : **≈ 2/3 du débit contourne
  la cage**.

### M2. Add2PSU
- Collision avec le PSU : **2 520 mm³** (x 66..94, y 240..270, z 16..19). Le
  module fait ~15 mm de haut sous un PSU posé à 12 mm du fond.
- Trous percés à x 24/88 au lieu de 27/91 : le retrait (70−64)/2 = 3 mm est
  oublié l.238. En Y le retrait est correct.
- Inserts M3×5.7 (poche 6.7) prévus dans un fond de 4 mm : ça viole la règle de
  `docs/components/inserts-ruthex.md` (« jamais d'insert dans une paroi < L »).
  Il faut des bossages.

### M3. Étagère sous-dimensionnée
3.2 mm d'épaisseur, portée de 234 mm entre les deux rangées de struts,
~5.6 kg de disques. Avec b=164, I = 448 mm⁴ et E ≈ 2.5 GPa (PLA imprimé), la
flèche est ≈ 5wL⁴/384EI ≈ **8 mm**, plus le fluage. De plus le trou arrière
(y 193 ± 1.6, fraisage ⌀6.5) **déborde du bord** de l'étagère (y 194). Les
disques dépassent de 1 mm côté connecteurs (y 195).

### M4. Flanc droit : fraisages côté intérieur
`side()` utilise `m4_csk` (fraise au local z=0). Pour `sideR` posé à x=278,
le local z=0 est la face **intérieure**, donc les têtes M4 saillent de 1.2 mm
à l'extérieur. C'est le même bug que le #7 de la v2.5 (front/top). Il faut
`m4_csk_ext` pour sideR.

## Mineurs

- **Pieds** : le fraisage est côté dessous (l.233), donc sous le pied, où il ne
  sert à rien. Il n'y a toujours **pas d'anti-vibration** (ouvert depuis
  l'audit v1 #6).
- **Grille avant** : là où les barreaux sont exclus (colonnes de vis), il reste
  des ouvertures de 16 à 22 mm. Un doigt passe jusqu'aux pales.
- **fan_guard** : `a=[0:22.5:247.5]` donne 12 barres pleine longueur, dont 4
  doublons (180..247.5 ≡ 0..67.5). Il n'y a que 8 barres uniques et le
  z-fighting persiste. Les docs annoncent 16, puis 12 rayons.
- **Arêtes** : tous les panneaux sont coupés aux cotes intérieures, ce qui
  laisse des rainures de 4×4 mm sur les 12 arêtes du boîtier.
- **Poteaux** : les poches M4 −Y et +X sont à 0.1 mm l'une de l'autre
  (x 14.8 / 14.9).
- **Visserie** : la M3 × 12 strut → étagère (`inserts-ruthex.md`) est trop
  longue : 3.2 + 6.7 de poche donne **M3 × 8 max**. Les fan guards sont percés
  ⌀4.5 (M4) alors que la doc parle d'inserts M3.
- **Code** : le paramètre `side(with_holes)` n'est jamais utilisé.
- **Docs en retard** :
  - `conformite.md` est toujours en v2.3, et son renvoi anti-vibration
    « TODO #R1 » est faux ;
  - `add2psu.md` indique une zone x 20..60 / y 240..300 et cite
    `atx_bridge_mount`, qui n'existe pas ;
  - le README parle encore de « panneaux segmentés » ;
  - l'audit v24 affirme une intersection lid ∩ poteaux vide alors qu'un seul
    poteau a été testé.

## Pistes v2.6

1. **Lid au ras des disques** (z ≈ 209.6) et **limité à la cage** (y 48..195).
   Ça règle B1, le by-pass de M1, la collision lid/poteaux de B4, et ça
   débouche les fentes du top.
2. **Poteaux avant** : les sortir de l'emprise des fans. Options : section
   24×12, fans recentrés et rapprochés, ou W élargi.
3. **Poteaux en miroir** : poches M4 sur les 2 faces panneau du coin, en pied
   et en tête (M4). Soit supprimer les trous milieu de bord, soit ajouter des
   bossages en face.
4. **Struts** : les placer à `[xx+4-12, yy+4-12, 4]`. Raccourcir l'étagère ou
   déplacer la rangée arrière pour que le trou y 197 reste dans la matière.
5. **PSU** : berceau / rails sous le CX430 et 4 trous ATX (6-32) dans le
   panneau arrière autour de la découpe.
6. **Add2PSU** : le déplacer hors de l'emprise du PSU (x < 62, tourné de 90°)
   sur 4 bossages ≥ 9 mm, et corriger le retrait de 3 mm.
7. **Étagère** : nervures sous l'étagère, ou rangée de struts centrale, ou
   ts ≥ 6 mm.
8. **sideR** : `m4_csk_ext`. Pieds : fraisage côté intérieur + patins
   élastomère.
9. **Sorties d'air** : déplacer les colonnes de fentes arrière vers l'intérieur
   (entre les poteaux et les grommets) et dégager les fentes sous le PSU.

## Statut v2.6 (`scad/boitier_8_sas_v26.scad`)

Les pistes ci-dessus sont implémentées dans un **nouveau fichier** (la v2.5 reste
intacte). Tests CGAL refaits sur la v2.6 (pièces placées comme dans `assembly()`) :

| Test | v2.5 | v2.6 |
|---|---|---|
| panneaux ∩ structure interne (poteaux, étagère, plaque, struts) | — | **vide** |
| panneaux ∩ composants (disques, fans, PSU, Add2PSU) | — | **vide** |
| structure interne ∩ composants | fans∩poteaux 45 322, Add2PSU∩PSU 2 520 | **vide** |
| poteaux ∩ étagère/plaque/struts | lid∩poteaux 2 911 | **vide** |
| sondes d'axe de vis (⌀1, 8 mm) ∩ matière pleine | — | **vide** : toutes les vis tombent dans une poche d'insert ou un pilote |
| sondes d'axe de vis ∩ pièce cible | — | 100 % (hors jeu volontaire de 0.3 mm plaque/disques) |

Les 14 pièces sont manifold (`Simple: yes`), STL dans `stl/v26/`, rendus
`renders/*_v26.png`. Points restant à vérifier sur pièce : cf. `TODO.md`
(trous ATX, fenêtre PSU, visserie).
