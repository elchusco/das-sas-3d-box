# Notice d'assemblage — v2.7

Vue éclatée : `renders/exploded_v27.png`. Coupe : `renders/cutaway_v27.png`.
Quantités : [bom.md](bom.md). Repère : X largeur, Y profondeur (0 = avant),
Z hauteur.

## 0. Préparation

1. Poser **tous les inserts** à chaud avant tout assemblage
   ([impression.md](impression.md) § Inserts) : poteaux (M4 ×6 chacun),
   struts (M3 en tête), piliers de l'étagère (M3 ×4), bossages Add2PSU du
   fond (M3 ×4), cornières (M3 ×2 chacune), barrette (M3 ×2 en bout).
2. Coller les 4 patins dans les logements des pieds.

## 1. Fond

3. Visser les **4 pieds** par l'intérieur du fond (M4 × 14).
4. Visser les **9 struts** par-dessous (M4 × 12 dans le pilote).
5. Visser l'**Add2PSU** sur ses bossages (M3 × 6).
6. Visser les **cornières basses** au fond : avant (`edge_rail_x`) et
   flancs (`edge_rail_y` ×2). Une seule vis par cornière à ce stade
   (celle dans le fond).

## 2. Ossature

7. Visser les **4 poteaux** au fond (M4 × 12 par-dessous). Orientation :
   AV-G `corner_post`, AV-D `corner_post_m`, AR-G `corner_post_m`,
   AR-D `corner_post` tourné de 180°. Les poches latérales font face aux
   panneaux.
8. Poser le **PSU** sur ses plots, ventilateur vers le haut.
9. Monter le **panneau arrière** : M4 × 12 dans les poteaux, puis les
   4 vis 6-32 × 3/8" du PSU. Passer le fil Molex de l'Add2PSU dans le
   passe-câble ⌀12. Clipper les grommets.
10. Monter la **face avant** avec les 2 fans (joint TPU si `fan_iso`),
    puis visser la cornière avant-basse dans la face.
11. Monter les **flancs** et visser les cornières basses dans les flancs.

## 3. Cage

12. Poser l'**étagère** sur les struts (M3 × 8 fraisées, ×9).
13. Ranger les câbles inutilisés du CX430 sous l'étagère, avec des
    colliers dans les **passants du fond**. Brancher l'Add2PSU sur le
    24 broches.
14. Glisser les **8 disques** sur l'étagère, connecteurs vers l'arrière,
    **PCB côté gauche (−X)**. Les peignes les tiennent droits.
15. Poser la **plaque de cage** : M3 × 8 dans les 4 piliers, puis les
    **16 vis 6-32 × 1/4"** dans les disques. Ne pas prendre plus long
    (pénétration max SFF-8301 : 3.56 mm).

## 4. Câblage

16. Visser la **barrette serre-câbles** entre les flancs (M3 × 8, ×2).
17. Brancher les 2 breakouts SAS : grommet gauche → disques 1-4, droit →
    5-8. Noter l'affectation port HBA ↔ disque (numéro de série) dans
    `docs/cablage.md` à la mise en service.
18. Alimentation des disques : répartir sur **au moins 2 câbles** du
    CX430 (cf. [components/cx430.md](components/cx430.md) § Alimentation
    des disques).
19. Attacher chaque queue SFF-8482 à la barrette (1 collier par disque).

## 5. Fermeture et test

20. Visser les **4 cornières hautes** sous le top (M3 × 8 dans le top),
    poser le top (M4 × 12 dans les poteaux), puis visser les cornières
    dans la face avant, l'arrière et les flancs.
21. Test : interrupteur CX430 sur ON, allumer la tour → le DAS démarre.
    Vérifier les 8 disques (`lsscsi`, `smartctl -i`) et les températures
    (`tools/hdd-temp.sh`) après 30 min de charge.
