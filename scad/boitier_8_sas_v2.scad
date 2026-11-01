/*
Boitier DAS 8x 3.5" SAS (Seagate Constellation ES.3) + ATX (Corsair CX430)
v2.4 — disques SUR TRANCHE, 2 fans 120 push sur face avant, PSU arriere-bas.
PANNEAUX MONOBLOCS (plateau 1 m^2, bed_max=1000) + inserts Ruthex + Add2PSU.

Unites : mm. Repere monde : X (largeur 0..282), Y (prof. 0..360), Z (haut 0..260).

REFERENCES officielles :
 - SFF-8301 Rev 1.9 Table 3-1 : disque 101.6 W x 147.0 L x 26.1 H max.
   Trous LATERAUX 6-32 UNC-2B : A8=28.50 et A8+A9=130.10 du bout connecteurs,
   A10=6.35 de la face PCB. Penetration vis 2.39..3.56 mm -> plaques 3.2 mm.
 - ES.3 ST4000NM0023 : conforme SFF-8301 (Fig.12 manuel Seagate).
 - CX430 : 150 x 86 x 140. Fan 120 : ⌀114, carre de fixation 105, M4.
 - Add2PSU : 70 x 30 mm, 4 trous ⌀3 entraxe ~64 x ~24 (docs/components/add2psu.md)
 - Inserts Ruthex : M4x8.1 -> trou ⌀5.6 prof 9 ; M3x5.7 -> trou ⌀4.0 prof 7
   (docs/components/inserts-ruthex.md)

LAYOUT (monde) :
 - Cage : 8 disques pitch 33.1 ; x 12.1..269.9 ; y 48..195 (connecteurs a 195) ;
   z 107.2..209.05. PCB cote -X (vers panneau gauche).
 - Vis disques : VERTICALES par le lid (3.2 mm) dans les trous superieurs.
 - Fans 120 : y 4..29 (collés a la face avant, cote interieur),
   centres (83,163) et (205,163) en (X,Z).
 - PSU : x 66..216, y 216..356, z 16..102 (pieds 12 mm), IEC a l'arriere.
 - Add2PSU : fond, x 24..94, y 240..270 (support 4 trous M3 insert).
 - Grommets SAS ⌀36 : arriere, x 78 / 205, z 158 + passe-cable Molex ⌀12 x 250.
 - Flux : grille avant -> fans -> 7 canaux 7 mm -> plenum arriere -> grilles.
 - Demarrage ATX : Add2PSU (auto) ou atx_bridge (pont fixe), cf. docs.

Parts : assembly, front, rear, left, right, bottom, top, shelf, lid, strut,
        corner_post, fan_guard, grommet_ring, atx_bridge, box_foot
*/

$fn = 48;

/* ================= PARAMETRES ================= */
part = "assembly";

W = 282; D = 360; H = 260;
t  = 4;      // panneaux verticaux
ts = 3.2;    // etagere / lid
iw = W-2*t;  // 274
id = D-2*t;  // 352
ih = H-2*t;  // 252
bed_max = 1000;    // plateau 1 m^2 : panneaux monoblocs
clr = 0.3;

/* visserie */
m4_pilot = 3.3;    // pilote autotaraudeuse M4 (reliqueat)
m4_clear = 4.3;    // passage M4 (panneau perce, insert dans le poteau)
ruthex_m4 = 5.6;   // trou plastique insert Ruthex M4x8.1
ruthex_m4_depth = 9.1;   // L 8.1 + 1
ruthex_m3 = 4.0;   // trou plastique insert Ruthex M3x5.7
ruthex_m3_depth = 6.7;   // L 5.7 + 1
m632     = 3.9;    // passage vis 6-32 (disques)
m4_head  = 8.6;    // fraisage tete vis M4

/* disques (SFF-8301) */
n = 8;
hdd_thick  = 26.1;   // X
hdd_len    = 147.0;  // Y
hdd_height = 101.85; // Z
hdd_gap    = 7.0;
pitch      = hdd_thick + hdd_gap;   // 33.1
side_off   = 6.35;   // A10 : distance a la face PCB
side_y1    = 28.50;  // A8
side_y2    = 130.10; // A8+A9

cage_w   = n*pitch - hdd_gap;         // 257.8
cage_x0  = (iw - cage_w)/2 + t;       // 12.1
stack_y0 = 48;
conn_y   = stack_y0 + hdd_len;        // 195
stack_z0 = 104 + ts;                  // 107.2

drive_x = [for(i=[0:n-1]) cage_x0 + i*pitch];     // faces gauches
screw_x = [for(x=drive_x) x + side_off];          // axes vis (X)
screw_y = [conn_y - side_y1, conn_y - side_y2];   // 166.5 / 64.9 (Y)

/* fans */
fan_side=120; fan_cut=114; fan_pitch=105; fan_screw=4.5;
fan_cx = [83, 205];    // monde X
fan_cz = 163;          // monde Z

/* PSU CX430 */
psu_w=150; psu_h=86; psu_d=140;
psu_x0=66; psu_y0=216; psu_z0=16;

/* Add2PSU (70 x 30, trous ⌀3 entraxe 64 x 24) */
a2p_l=70; a2p_w=30; a2p_x=24; a2p_y=240;   // coin (monde), sur le fond
a2p_hole_dx=64; a2p_hole_dy=24; a2p_hole_d=3.2;

/* grommets SAS + passe-cable Molex (panneau arriere) */
grom_d=36; grom_x=[78,205]; grom_z=158;
molex_d=12; molex_x=141; molex_z=200;      // entre les 2 grommets, plus haut

/* ================= HELPERS ================= */
module pilot(d=m4_pilot,h=12) cylinder(h=h,d=d);
module clrh(d=m4_clear,h=12) cylinder(h=h,d=d);
module rtx4(h=ruthex_m4_depth) cylinder(h=h,d=ruthex_m4);  // pour insert M4
module rtx3(h=ruthex_m3_depth) cylinder(h=h,d=ruthex_m3);  // pour insert M3
// trou M4 passage + fraisage tete cote z=0 (exterieur du panneau)
module m4_csk() {
    clrh(d=m4_clear, h=t+2);
    translate([0,0,-1]) cylinder(h=2.2, d=m4_head, $fn=24);
}
module slab(w,h,th=t) linear_extrude(height=th) offset(r=3) offset(delta=-3)
    square([w,h]);

/* ================= FACE AVANT (monobloc 274 x 252) =================
   local : lx=Xm-4 (0..274), ly=Zm-4 (0..252).
   fans : centres (79,159)/(201,159) locales ; ouverture grille (bord a bord) */
module front() {
    difference() {
        slab(iw, ih);
        // decoupes fans + fixations
        for (cx=[79, 201]) {
            translate([cx,159,-1]) linear_extrude(t+2) circle(d=fan_cut);
            for (dx=[-52.5,52.5], dz=[-52.5,52.5])
                translate([cx+dx,159+dz,-1]) linear_extrude(t+2)
                    circle(d=fan_screw);
        }
        // trous M4 passage + fraisage (jetées)
        for (p=[[12,12],[12,240],[262,12],[262,240]])
            translate(p) m4_csk();
        // trous M4 milieu de bord
        for (p=[[137,12],[137,240]]) translate(p) m4_csk();
    }
    // barreaux de grille : verticaux entre les 2 fans + traverses horizontales
    for (x=[fop_x0() : 14 : fop_x1()]) translate([x-3, fop_y0()+4, 0])
        cube([6, fop_y1()-fop_y0()-8, t]);
    // traverses horizontales
    translate([fop_x0()+2, fop_y0()+2, 0]) cube([fop_x1()-fop_x0()-4, 6, t]);
    translate([fop_x0()+2, fop_y1()-8, 0]) cube([fop_x1()-fop_x0()-4, 6, t]);
}
function fop_x0() = fan_cx[0]-fan_side/2-6;   // 17
function fop_x1() = fan_cx[1]+fan_side/2+6;   // 271
function fop_y0() = fan_cz-fan_side/2-6;      // 97
function fop_y1() = fan_cz+fan_side/2+6;      // 229

/* ================= FACE ARRIERE (monobloc) =================
   local : lx=Xm-4, ly=Zm-4.
   PSU cutout : monde (65.5..216.5, 15.5..102.5) -> local (61.5..212.5, 11.5..98.5)
   grommets : monde (78/205, 158) -> local (74/201, 154)
   passe-cable Molex : monde (141, 200) -> local (137, 196)                  */
module rear() {
    difference() {
        slab(iw, ih);
        // decoupe PSU + jeu 1 mm
        translate([61.5, 11.5, 0]) linear_extrude(t+2) square([151, 87]);
        // 2 grommets SAS ⌀36
        for (gx=grom_x) translate([gx-4, grom_z-4, -1])
            linear_extrude(t+2) circle(d=grom_d);
        // passe-cable Molex ⌀12 (Add2PSU)
        translate([molex_x-4, molex_z-4, -1]) linear_extrude(t+2)
            circle(d=molex_d);
        // grilles d'extraction : fentes fines 5x8, colonnes hautes g/d
        for (z=[144:14:242]) {
            translate([10, z, 0]) linear_extrude(t+2) square([5, 8]);    // gauche
            translate([iw-15, z, 0]) linear_extrude(t+2) square([5, 8]); // droite
        }
        // fentes d'air sous PSU (alimentation du ventilateur PSU)
        for (x=[14:16:60]) translate([x, 2, 0]) linear_extrude(t+2)
            square([5, 8]);
        for (x=[222:16:260]) translate([x, 2, 0]) linear_extrude(t+2)
            square([5, 8]);
        // trous M4 passage + fraisage (jetées)
        for (p=[[12,12],[12,240],[262,12],[262,240],[137,12],[137,240]])
            translate(p) m4_csk();
    }
    // renforts des grommets (imprimes avec le panneau)
    for (gx=grom_x) translate([gx-4, grom_z-4, 0]) difference() {
        cylinder(h=t, d=grom_d+16);
        translate([0,0,-1]) cylinder(h=t+2, d=grom_d);
    }
}

/* ================= PANNEAUX LATERAUX (monoblocs 352 x 252) =================
   local : lx=Ym-4, ly=Zm-4.
   Trous 6-32 disques : uniquement PANNEAU GAUCHE (cote PCB).               */
module side(with_holes=false) {
    difference() {
        slab(id, ih);
        // trous M4 passage + fraisage (jetées avant/arrière + milieux)
        for (p=[[12,12],[12,240],[340,12],[340,240],[176,12],[176,240]])
            translate(p) m4_csk();
    }
}
module sideL() side(true);
module sideR() side(false);

/* ================= FOND / PLAFOND (monoblocs 274 x 352) =================
   local : lx=Xm-4, ly=Ym-4.                                                */
module bottom() {
    difference() {
        slab(iw, id);
        // trous inserts M4 : jetees (monde 16/16, 16/344, 266/16, 266/344)
        // fraisage cote DESSOUS (exterieur, z=0)
        for (p=[[12,12],[12,340],[262,12],[262,340],[137,12],[137,340]])
            translate([p[0],p[1],0]) {
                clrh(d=m4_clear, h=t+2);
                translate([0,0,-1]) cylinder(h=2.2, d=m4_head, $fn=24);
            }
        // struts : monde (24/258, 57/127/193) -> local (20/254, 53/123/193)
        // pilotage + insert M4 dans le fond ? non : strut percé, vis traverse
        for (xx=[20,254], yy=[53,123,193]) translate([xx,yy,0]) {
            clrh(d=m4_clear, h=t+2);
            translate([0,0,-1]) cylinder(h=2.2, d=m4_head, $fn=24);
        }
        // fixation pieds : 4 trous M4 + fraisage (monde 16/344 coins décalés)
        for (p=[[40,20],[234,20],[40,328],[234,328]])
            translate([p[0],p[1],0]) {
                clrh(d=m4_clear, h=t+2);
                translate([0,0,-1]) cylinder(h=2.2, d=m4_head, $fn=24);
            }
        // fixation Add2PSU : 4 trous M3 insert (entraxe 64x24, monde x24+5..x89)
        for (dx=[0,a2p_hole_dx], dy=[a2p_y-4+ (a2p_w-a2p_hole_dy)/2,
                                     a2p_y-4+(a2p_w+a2p_hole_dy)/2])
            translate([a2p_x-4+dx, dy]) clrh(d=ruthex_m3, h=6);
    }
}
module top() {
    difference() {
        slab(iw, id);
        // trous M4 passage + fraisage (jetées)
        for (p=[[12,12],[12,340],[262,12],[262,340],[137,12],[137,340]])
            translate(p) m4_csk();
        // event haut au-dessus du plenum : monde x 40..240, y 200..330
        for (x=[40:16:236]) translate([x-4, 196, 0]) linear_extrude(t+2)
            square([5, 130]);
    }
}

/* ================= ETAGERE (274 x 164, ts=3.2) =================
   monde z 104..107.2, y 30..194 ; trous struts : vis M3 (insert dans la tete
   du strut), fraisee cote dessous (tete affleurante).                       */
module shelf() {
    difference() {
        slab(iw, 164, ts);
        // trous struts : monde (24/258, 57/127/193) -> local (20/254, 27/97/163)
        // lumiere M3 (⌀3.2) + fraisage tete cote DESSOUS (z=0)
        for (xx=[20,254], yy=[27,97,163]) translate([xx,yy,0]) {
            cylinder(h=ts+2, d=3.2);
            translate([0,0,-1]) cylinder(h=1.8, d=6.5, $fn=24);   // fraise tete
        }
    }
}

/* ================= LID (274 x 326, ts=3.2) =================
   monde z H-t-ts..H-t ; couvre y 26..352. Trous 6-32 disques.              */
module lid() {
    difference() {
        slab(iw, 326, ts);
        // 16 trous de vis disques (⌀3.9) : monde x=screw_x, y=screw_y
        for (sx=screw_x, sy=screw_y)
            translate([sx-4, sy-30]) clrh(d=m632, h=ts+2);
        // trous M3 fixation aux poteaux (insert dans la tête du poteau)
        // + fraisage côté extérieur (z=ts, face supérieure)
        for (p=[[12,12],[12,314],[262,12],[262,314],[137,12],[137,314]])
            translate([p[0],p[1],0]) {
                clrh(d=m4_clear, h=ts+2);
                translate([0,0,ts-1.2]) cylinder(h=2, d=6.5, $fn=24);
            }
    }
}

/* ================= STRUCTURE INTERNE ================= */
// strut : poteau cage 24x24 x 100 (z 4..104).
// Fixation : vis M4 depuis le DESSOUS du fond -> traverse le strut.
// L'etagere se visse sur la tete : insert M3 dans la tete du strut.
module strut() {
    difference() {
        cube([24,24,100]);
        // poche insert M3 dans la tete (etagere -> strut)
        translate([12,12,100-ruthex_m3_depth]) rtx3();
        // passage vis M4 depuis le dessous du fond (fraisage cote z=0 du fond)
        translate([12,12,-1]) clrh(d=m4_clear, h=102);
    }
}

// jetee d'angle 24x24 x 252 (z 4..256), poches inserts M4 sur 2 faces + tete M3
module corner_post() {
    difference() {
        cube([24,24,252]);
        // faces : poches M4 (prof 9.1) vers panneaux Y (avant/arriere)
        for (z=[12, 126, 240]) {
            translate([12, -0.1, z]) rotate([-90,0,0]) rtx4();   // face -Y
            translate([24.1, 12, z])  rotate([-90,0,90]) rtx4(); // face X
        }
        // tete : insert M3 (fixation lid / top)
        translate([12,12,252-ruthex_m3_depth]) rtx3();
    }
}

/* ================= ACCESSOIRES ================= */
module atx_bridge() {   // pont PS_ON de secours (sans Add2PSU)
    difference() {
        cube([14,10,8]);
        for (x=[3.5,7,10.5]) translate([x,5,-1]) cylinder(h=8,d=2.7,$fn=16);
    }
}
module box_foot() {     // pied : visse sous le fond
    difference() {
        cube([30,30,12]);
        translate([15,15,-1]) pilot(h=16);
    }
}
module fan_guard() {   // grille 120 mm, ep 3 mm, vissee par l'exterieur (M4)
    difference() {
        union() {
            difference() {
                // carré 124x124 CENTRE (translate -62) + rayons
                translate([-62,-62,0]) linear_extrude(height=3)
                    offset(r=3) offset(delta=-3) square([124,124]);
                translate([0,0,-1]) cylinder(h=5, d=fan_cut-8);
            }
            // rayons de grille (centre 0,0)
            for (a=[0:22.5:157.5]) rotate([0,0,a])
                translate([-60,-1.5,0]) cube([120,3,3]);
            for (a=[90:22.5:247.5]) rotate([0,0,a])
                translate([-60,-1.5,0]) cube([120,3,3]);
        }
        // 4 trous M4 au carre 105 (alignes sur les decoupes de la face avant)
        for (dx=[-52.5,52.5], dz=[-52.5,52.5])
            translate([dx,dz,-1]) cylinder(h=5,d=fan_screw);
        // trou central passage moyeu
        translate([0,0,-1]) cylinder(h=5,d=12);
    }
}

/* ================= FANTOMES (parametrables) ================= */
show_ghosts = true;    // false pour rendre les pieces sans superposition
module drives() {
    if (show_ghosts)
        %for (i=[0:n-1])
            translate([drive_x[i], stack_y0, stack_z0])
                cube([hdd_thick, hdd_len, hdd_height]);
}
module psu() {
    if (show_ghosts) %translate([psu_x0, psu_y0, psu_z0]) cube([psu_w, psu_d, psu_h]);
}
module fans() {
    if (show_ghosts)
        %for (cx=fan_cx)
            translate([cx-fan_side/2, 4, fan_cz-fan_side/2])
                cube([fan_side,25,fan_side]);
}
module add2psu() {
    if (show_ghosts) {
        %translate([a2p_x, a2p_y, t]) cube([a2p_l, a2p_w, 15]);
    }
}

/* ================= VUE ECLATEE ================= */
explode = 60;   // amplitude d'écartement
module exploded() {
    color("DimGray") {
        translate([-explode,4,4])     rotate([90,0,90]) sideL();
        translate([278+explode,4,4])  rotate([90,0,90]) sideR();
        translate([4,4,-explode])     bottom();
        translate([4,4,H-t+explode])  top();
    }
    color("SlateGray") {
        translate([4,t-explode,4])  rotate([90,0,0]) front();
        translate([4,D+explode,4])  rotate([90,0,0]) rear();
    }
    color("Orange") {
        translate([4,30,104+explode*0.6])        shelf();
        translate([4,26,H-t-ts+explode*1.6])     lid();
    }
    color("Gray")
        for (xx=[20,254], yy=[53,123,193])
            translate([xx, yy-12, 4]) strut();   // voir note struts
    color("Goldenrod")
        for (px=[4,W-28], py=[4,D-28])
            translate([px,py,4]) corner_post();
    // struts restent en place ; composants en fantomes
    drives(); psu(); fans(); add2psu();
}

/* ================= ASSEMBLAGE ================= */
module assembly() {
    color("DimGray") {   // lateraux
        translate([0,4,4])     rotate([90,0,90]) sideL();
        translate([278,4,4])   rotate([90,0,90]) sideR();
    }
    color("DimGray") {   // fond / plafond
        translate([4,4,0])   bottom();
        translate([4,4,H-t]) top();
    }
    color("SlateGray") { // avant / arriere
        translate([4,t,4])  rotate([90,0,0]) front();
        translate([4,D,4])  rotate([90,0,0]) rear();
    }
    color("Orange") {    // etagere + lid
        translate([4,30,104])   shelf();
        translate([4,26,H-t-ts]) lid();
    }
    color("Gray")        // struts : monde (24/258, 57/127/193) - 12
        for (xx=[20,254], yy=[53,123,193])
            translate([xx-12+12-12+12, yy, 4]) strut();   // voir note struts
    color("Goldenrod")
        for (px=[4,W-28], py=[4,D-28])
            translate([px,py,4]) corner_post();
    drives(); psu(); fans(); add2psu();
}

/* ================= RENDU ================= */
if (part=="assembly") assembly();
else if (part=="exploded") exploded();
else if (part=="front") front();
else if (part=="rear") rear();
else if (part=="left") sideL();
else if (part=="right") sideR();
else if (part=="bottom") bottom();
else if (part=="top") top();
else if (part=="shelf") shelf();
else if (part=="lid") lid();
else if (part=="strut") strut();
else if (part=="corner_post") corner_post();
else if (part=="fan_guard") fan_guard();
else if (part=="atx_bridge") atx_bridge();
else if (part=="box_foot") box_foot();
