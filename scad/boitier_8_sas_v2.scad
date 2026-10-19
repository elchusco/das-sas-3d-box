/*
Boitier DAS 8x 3.5" SAS (Seagate Constellation ES.3) + ATX (Corsair CX430)
v2.2 — disques SUR TRANCHE, 2 fans 120 push sur face avant, PSU arriere-bas.
Unites : mm. Repere monde : X (largeur 0..282), Y (prof. 0..360), Z (haut 0..260).

REFERENCES officielles :
 - SFF-8301 Rev 1.9 Table 3-1 : disque 101.6 W x 147.0 L x 26.1 H max.
   Trous LATERAUX 6-32 UNC-2B : A8=28.50 et A8+A9=130.10 du bout connecteurs,
   A10=6.35 de la face PCB. Penetration vis 2.39..3.56 mm -> plaques 3.2 mm.
 - ES.3 ST4000NM0023 : conforme SFF-8301 (Fig.12 manuel Seagate).
 - CX430 : 150 x 86 x 140. Fan 120 : ⌀114, carre de fixation 105, M4.

LAYOUT (monde) :
 - Cage : 8 disques pitch 33.1 ; x 12.1..269.9 ; y 48..195 (connecteurs a 195) ;
   z 107.2..209.05. PCB cote -X (vers panneau gauche).
 - Vis disques : VERTICALES par le lid (3.2 mm) dans les trous superieurs.
 - Fans 120 : y 4..29 (collés a la face avant, cote interieur),
   centres (83,163) et (205,163) en (X,Z).
 - PSU : x 66..216, y 216..356, z 16..102 (pieds 12 mm), IEC a l'arriere.
 - Grommets SAS ⌀36 : arriere, x 78 / 205, z 158.
 - Flux : grille avant -> fans -> 7 canaux 7 mm -> plenum arriere -> grilles.
 - Demarrage ATX : PS_ON ponte (piece atx_bridge), interrupteur secteur ON/OFF.

IMPRESSION : segments <= bed_max (defaut 220). Joints : ergots+slots, colles.
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
bed_max = 220;
clr = 0.3;
m4_pilot = 3.3;   // pilote autotaraudeuse M4
m4_clear = 4.3;   // passage M4
m632     = 3.9;   // passage vis 6-32 (⌀3.81 filet ext. -> jeu)

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

/* grommets SAS */
grom_d=36; grom_x=[78,205]; grom_z=158;

/* segmentation : joints (monde) */
seam_x=150; seam_y=180; seam_z=126+4;   // 130 : ly=126
lap=12;       // recouvrement ergots (hors bed_max, joint colle)

/* ================= HELPERS ================= */
module pilot(d=m4_pilot,h=12) cylinder(h=h,d=d);
module clrh(d=m4_clear,h=12) cylinder(h=h,d=d);
module slab(w,h,th=t) linear_extrude(height=th) offset(r=3) offset(delta=-3)
    square([w,h]);
module tab2d() square([12,6]);                 // ergot (12x6)
module slot2d() square([12+clr,6+clr]);        // slot

/* ================= FACE AVANT =================
   local : lx=Xm-4 (0..274), ly=Zm-4 (0..252). decoupes lx@144, ly@86.
   fans : centres (79,159)/(201,159) locales. */
module front_A1() {          // x 4..148, z 4..90
    slab(144,86);
}
module front_A2() {          // x 4..148, z 90..256
    difference() {
        union() {
            slab(144,166);
            translate([144,30,0]) linear_extrude(t) tab2d();
            translate([144,120,0]) linear_extrude(t) tab2d();
        }
        translate([79,159,-1]) linear_extrude(t+2) circle(d=fan_cut);
        for (dx=[-52.5,52.5], dz=[-52.5,52.5])
            translate([79+dx,159+dz,-1]) linear_extrude(t+2) circle(d=fan_screw);
        // pilotes poteaux (monde 16/16 et 16/244 -> local 12/12, 12/240)
        for (p=[[12,12],[12,240]]) translate(p) pilot();
    }
}
module front_B1() {          // x 148..278, z 4..90
    difference() {
        slab(130,86);
        for (p=[30,120]) translate([-2,p-2]) linear_extrude(t) slot2d();
        translate([118,12]) pilot();
    }
}
module front_B2() {          // x 148..278, z 90..256
    difference() {
        slab(130,166);
        translate([57,159,-1]) linear_extrude(t+2) circle(d=fan_cut);
        for (dx=[-52.5,52.5], dz=[-52.5,52.5])
            translate([57+dx,159+dz,-1]) linear_extrude(t+2) circle(d=fan_screw);
        for (p=[30,120]) translate([-2,p-2]) linear_extrude(t) slot2d();
        for (p=[[118,12],[118,240]]) translate(p) pilot();
    }
}
module front_bars() {        // barreaux grille (z-fight evite : dans l'ouverture)
    // verticals
    for (x=[16:14:126]) translate([x,92]) cube([6,72,3]);
    // horizontaux
    for (z=[96:14:222]) translate([10,z]) cube([258,6,3]);
}

/* ================= FACE ARRIERE =================
   local : lx=Xm-4, ly=Zm-4. decoupes lx@144, ly@126.
   PSU cutout : monde (65.5..216.5, 15.5..102.5) -> local (61.5..212.5, 11.5..98.5)
   grommets : monde (78/205,158) -> local (74/201,154) */
module rear_A1() {
    difference() {
        slab(144,126);
        translate([61.5,11.5,0]) linear_extrude(t+2) square([151,87]);      // PSU cutout
        for (x=[75:16:135]) translate([x-4,2,0]) linear_extrude(t+2) square([8,8]);  // air sous PSU (partie A)
    }
}
module rear_A2() {
    difference() {
        union() {
            slab(144,126);
            translate([144,40,0]) linear_extrude(t) tab2d();
            translate([144,100,0]) linear_extrude(t) tab2d();
        }
        translate([74,154,-1]) linear_extrude(t+2) circle(d=grom_d);
        for (z=[150:16:214]) translate([8,z,0]) linear_extrude(t+2) square([8,10]);  // grille gauche
        for (p=[[12,12],[12,240]]) translate(p) pilot();
    }
}
module rear_B1() {
    difference() {
        slab(130,126);
        translate([61.5-144,11.5,0]) linear_extrude(t+2) square([151,87]);  // PSU cutout
        for (x=[151:16:211]) translate([x-4,2,0]) linear_extrude(t+2) square([8,8]); // air sous PSU (partie B)
        for (p=[30,120]) translate([-2,p-2]) linear_extrude(t) slot2d();
        translate([118,12]) pilot();
    }
}
module rear_B2() {
    difference() {
        slab(130,126);
        translate([201-144,154,-1]) linear_extrude(t+2) circle(d=grom_d);
        for (z=[150:16:214]) translate([232-4-144,z,0]) linear_extrude(t+2) square([8,10]);  // grille droite
        for (x=[160:16:216]) if (x-144>=0) translate([x-4-144,240,0]) linear_extrude(t+2) square([8,8]); // bande haute
        for (p=[30,120]) translate([-2,p-2]) linear_extrude(t) slot2d();
        for (p=[[118,12],[118,240]]) translate(p) pilot();
    }
}
module grommet_ring() {
    difference() {
        cylinder(h=t,d=grom_d+14);
        translate([0,0,-1]) cylinder(h=t+2,d=grom_d);
    }
}

/* ================= PANNEAUX LATERAUX =================
   local : lx=Ym-4 (0..352), ly=Zm-4 (0..252). joints lx@176, ly@126.
   Trous disques : uniquement PANNEAU GAUCHE (cote PCB).                    */
module side_piece(wx,hz,with_holes=false) {
    difference() {
        slab(wx,hz);
        if (with_holes) {
            // vis disques : ly = screw_y-4-? disques sur tranche : les vis
            // sont verticales, la face PCB fait face a ce panneau :
            // local x = screw_x[i]-4 ; local y = screw_y[k]-4
            for (sx=screw_x, sy=screw_y)
                if (sx-4 > 0 && sx-4 < wx && sy-4 > 0 && sy-4 < hz)
                    translate([sx-4, sy-4]) clrh(d=m632,h=t+4);
            // pilotes poteaux avant/arriere
            for (p=[[12,12],[12,240],[340,12],[340,240],[176,12],[176,240]])
                translate(p) pilot();
        } else {
            for (p=[[12,12],[12,240],[340,12],[340,240],[176,12],[176,240]])
                if (p[0]<wx && p[1]<hz) translate(p) pilot();
        }
    }
}
// gauche : decoupe en 4 (172/180 x 126/126)
module sideL_A1() side_piece(172,126,true);
module sideL_A2() { difference() {
    union() { side_piece(172,126,true);
        translate([172,40,0]) linear_extrude(t) tab2d();
        translate([172,100,0]) linear_extrude(t) tab2d(); }
} }
module sideL_B1() { difference() {
    union() { side_piece(180,126,true); }
    for (p=[30,100]) translate([-2,p-2]) linear_extrude(t) slot2d();
} }
module sideL_B2() { difference() {
    union() { side_piece(180,126,true); }
    for (p=[30,100]) translate([-2,p-2]) linear_extrude(t) slot2d();
} }
// droite : sans trous disques
module sideR_A1() side_piece(172,126,false);
module sideR_A2() side_piece(172,126,false);
module sideR_B1() side_piece(180,126,false);
module sideR_B2() side_piece(180,126,false);

/* ================= FOND / PLAFOND =================
   local : lx=Xm-4 (0..274), ly=Ym-4 (0..352). joints lx@144, ly@176.        */
module bottom_A1() {
    difference() {
        slab(144,172);
        for (p=[[12,12],[132,12]]) translate(p) pilot();       // poteaux
        // fixations cage (struts x 12/266, y 45/115/185 -> local 8/262, 41/111/181)
        translate([8,41]) pilot(); translate([8,111]) pilot(); translate([8,181]) pilot();
    }
}
module bottom_A2() {
    difference() {
        union() { slab(130,172);
            translate([130,40,0]) linear_extrude(t) tab2d();
            translate([130,140,0]) linear_extrude(t) tab2d(); }
        translate([262-4,41]) pilot(); translate([262-4,111]) pilot(); translate([262-4,181]) pilot();
    }
}
module bottom_B1() {
    difference() {
        slab(144,180);
        translate([8,262-4]) pilot();
        for (p=[30,100]) translate([-2,p-2]) linear_extrude(t) slot2d();
    }
}
module bottom_B2() {
    difference() {
        slab(130,180);
        translate([118,258]) pilot();
        for (p=[30,140]) translate([-2,p-2]) linear_extrude(t) slot2d();
    }
}
module top_A1() {
    difference() {
        slab(144,172);
        for (p=[[12,12],[132,12]]) translate(p) pilot();
        // event haut : monde x 40..240, y 200..330 -> local 36..236, 196..326
        for (x=[40:16:220]) if (x < 144) translate([x-4,196,0]) linear_extrude(t+2) square([8,130]);
    }
}
module top_A2() {
    difference() {
        union() { slab(130,172);
            translate([130,40,0]) linear_extrude(t) tab2d();
            translate([130,140,0]) linear_extrude(t) tab2d(); }
        for (x=[152:16:232]) translate([x-4,196,0]) linear_extrude(t+2) square([8,130]);
    }
}
module top_B1() {
    difference() {
        slab(144,180);
        for (p=[30,140]) translate([-2,p-2]) linear_extrude(t) slot2d();
    }
}
module top_B2() {
    difference() {
        slab(130,180);
        for (p=[30,140]) translate([-2,p-2]) linear_extrude(t) slot2d();
    }
}

/* ================= STRUCTURE INTERNE ================= */
// etagere : monde z 104..107.2, x 4..278, y 30..194 -> pieces (bed_max : 274x164 -> 2 pcs)
module shelf_L() {   // x 4..150, y 30..194
    difference() {
        slab(146,164,ts);
        translate([8,41-30+8]) clrh(); translate([8,111-30+8]) clrh(); translate([8,181-30+8]) clrh();
    }
}
module shelf_R() {   // x 150..278
    difference() {
        slab(128,164,ts);
        translate([128-12,11]) clrh(); translate([128-12,81]) clrh(); translate([128-12,151]) clrh();
        // vis laterales panneau droit (monde z 107.2, x disques -> local)
        for (sx=screw_x) if (sx-150 > 4 && sx-150 < 124)
            translate([sx-150, sy_local(sx)]) clrh(d=m632,h=ts+2);
    }
}
function sy_local(x) = 106.28 - 48;   // provisoire : voir notes

// lid : monde z 209.2..212.4, pieces 2x2. Trous 6-32 aux axes screw_x/screw_y.
module lid_A1() {   // x 4..150, y 30..202
    difference() {
        slab(146,172,ts);
        for (sx=screw_x, sy=screw_y)
            if (sx>=8 && sx<=146 && sy>=34 && sy<=198)
                translate([sx-4, sy-30]) clrh(d=m632,h=ts+2);
    }
}
module lid_A2() {   // x 150..278, y 30..202
    difference() {
        slab(128,172,ts);
        for (sx=screw_x, sy=screw_y)
            if (sx>=154 && sx<=274 && sy>=34 && sy<=198)
                translate([sx-150, sy-30]) clrh(d=m632,h=ts+2);
    }
}
module lid_B1() {   // x 4..150, y 202..356
    difference() {
        slab(146,150,ts);
    }
}
module lid_B2() {
    slab(130,150,ts);
}

// poteaux cage : monde (12/266, 45/115/181), 24x24, z 4..104
module strut() {
    difference() {
        cube([24,24,100]);
        translate([12,12,-1]) pilot(h=14);
    }
}

// jetees d'angle 24x24 x 252 (z 4..256)
module corner_post() {
    difference() {
        cube([24,24,252]);
        for (z=[12,126,240]) {
            translate([12,3,z])  rotate([-90,0,0]) pilot();
            translate([3,12,z])  rotate([90,0,0])  pilot();
        }
        // pilote vertical vers fond/plafond
        translate([12,12,-1]) pilot(h=16);
        translate([12,12,244]) pilot(h=14);
    }
}

module fan_guard() {   // grille 120 mm (imprimee a plat, 3 mm)
    difference() {
        union() {
            difference() {
                linear_extrude(height=3) offset(r=3) offset(delta=-3) square([124,124]);
                translate([0,0,-1]) cylinder(h=5, d=fan_cut-8);
            }
            for (a=[0:30:150]) rotate([0,0,a])
                translate([-60,-1.5,0]) cube([120,3,3]);
            rotate([0,0,90]) translate([-60,-1.5,0]) cube([120,3,3]);
        }
        for (dx=[-52.5,52.5], dz=[-52.5,52.5])
            translate([dx,dz,-1]) cylinder(h=5,d=fan_screw);
        translate([0,0,-1]) cylinder(h=5,d=10);
    }
}

/* ================= ACCESSOIRES ================= */
module atx_bridge() {   // pont PS_ON : 3 pin headers 2.54 -> impression libre
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

/* ================= FANTOMES ================= */
module drives() {
    %for (i=[0:n-1])
        translate([drive_x[i], stack_y0, stack_z0])
            cube([hdd_thick, hdd_len, hdd_height]);
}
module psu() {
    %translate([psu_x0, psu_y0, psu_z0]) cube([psu_w, psu_d, psu_h]);
}
module fans() {
    %for (cx=fan_cx)
        translate([cx-fan_side/2, 4, fan_cz-fan_side/2]) cube([fan_side,25,fan_side]);
}

/* ================= ASSEMBLAGE ================= */
module assembly() {
    color("DimGray") {   // lateraux : x 0..4 (gauche) / 278..282 (droite)
        // rotate([90,0,90]) : local x->Y monde, local y->Z monde, epaisseur->X
        translate([0,4,4])     rotate([90,0,90]) sideL_A1();   // y 4..176, z 4..130
        translate([0,176,4])   rotate([90,0,90]) sideL_B1();   // y 176..356
        translate([0,4,126])   rotate([90,0,90]) sideL_A2();   // z 130..256
        translate([0,176,126]) rotate([90,0,90]) sideL_B2();
        // droite
        translate([278,4,4])    rotate([90,0,90]) sideR_A1();
        translate([278,176,4])  rotate([90,0,90]) sideR_B1();
        translate([278,4,126])  rotate([90,0,90]) sideR_A2();
        translate([278,176,126]) rotate([90,0,90]) sideR_B2();
    }
    color("DimGray") {   // fond / plafond
        translate([4,4,0])       bottom_A1();
        translate([148,4,0])     bottom_A2();   // x 148..278
        translate([4,176,0])     bottom_B1();
        translate([148,176,0])   bottom_B2();
        translate([4,4,H-t])     top_A1();
        translate([148,4,H-t])   top_A2();
        translate([4,176,H-t])   top_B1();
        translate([148,176,H-t]) top_B2();
    }
    color("SlateGray") { // avant y 0..4 / arriere y 356..360
        // rotate([90,0,0]) : extrusion Z->Y negative ; le panneau local (0,0)
        // correspond a (x=lx+4, z=ly+4) une fois translate en (4,4,4) : OK.
        translate([4,t,4])   rotate([90,0,0]) front_A1();
        translate([4,t,86])  rotate([90,0,0]) front_A2();
        translate([148,t,4]) rotate([90,0,0]) front_B1();
        translate([148,t,86]) rotate([90,0,0]) front_B2();
        translate([4,t,4])   rotate([90,0,0]) front_bars();   // bars
        // arriere : rotation +90 autour X (local y -> -Z monde) ; decalage
        translate([4,D,4])   rotate([90,0,0]) rear_A1();
        translate([4,356,126]) rotate([90,0,0]) rear_A2();
        translate([148,356,4]) rotate([90,0,0]) rear_B1();
        translate([148,356,126]) rotate([90,0,0]) rear_B2();
        // grommet rings (faisant partie du panneau arriere)
        translate([4,356,4]) rotate([90,0,0])
            for (gx=grom_x, gz=[grom_z-4]) translate([gx-4,gz-4,0]) grommet_ring();
    }
    color("Orange") {    // etagere z 104 (ts 3.2) et lid z 209.2
        translate([4,30,104])   shelf_L();
        translate([150,30,104]) shelf_R();
        translate([4,30,H-t-ts])  lid_A1();
        translate([150,30,H-t-ts]) lid_A2();
        translate([4,202,H-t-ts]) lid_B1();
        translate([150,202,H-t-ts]) lid_B2();
    }
    color("Gray") for (xx=[12,266], yy=[45,115,181])
        translate([xx-12, yy-12, 4]) strut();
    color("Goldenrod") for (px=[4,W-28], py=[4,D-28])
        translate([px,py,4]) corner_post();
    drives(); psu(); fans();
}

/* ================= RENDU ================= */
if (part=="assembly") assembly();
else if (part=="front") { front_A1(); translate([144,0,0]) front_B1();
    translate([0,86,0]) front_A2(); translate([144,86,0]) front_B2(); }
else if (part=="rear") { rear_A1(); translate([144,0,0]) rear_B1();
    translate([0,126,0]) rear_A2(); translate([144,126,0]) rear_B2(); }
else if (part=="left") { sideL_A1(); translate([172,0,0]) sideL_B1();
    translate([0,126,0]) sideL_A2(); translate([172,126,0]) sideL_B2(); }
else if (part=="right") { sideR_A1(); translate([172,0,0]) sideR_B1();
    translate([0,126,0]) sideR_A2(); translate([172,126,0]) sideR_B2(); }
else if (part=="bottom") { bottom_A1(); translate([144,0,0]) bottom_A2();
    translate([0,172,0]) bottom_B1(); translate([144,172,0]) bottom_B2(); }
else if (part=="top") { top_A1(); translate([144,0,0]) top_A2();
    translate([0,172,0]) top_B1(); translate([144,172,0]) top_B2(); }
else if (part=="shelf") { shelf_L(); translate([146,0,0]) shelf_R(); }
else if (part=="lid") { lid_A1(); translate([150,0,0]) lid_A2();
    translate([0,172,0]) lid_B1(); translate([150,172,0]) lid_B2(); }
else if (part=="strut") strut();
else if (part=="corner_post") corner_post();
else if (part=="fan_guard") fan_guard();
else if (part=="grommet_ring") grommet_ring();
else if (part=="atx_bridge") atx_bridge();
else if (part=="box_foot") box_foot();
