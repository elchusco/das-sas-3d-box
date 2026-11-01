/*
Boitier DAS 8x 3.5" SAS (Seagate Constellation ES.3) + ATX (Corsair CX430)
v2.6 — corrections de l'audit v2.5 (docs/audit-v25.md). Fichier neuf : la
v2.5 (boitier_8_sas_v2.scad) est conservee telle quelle pour comparaison.

v2.6 :
 - B1/M1 lid remplace par une PLAQUE DE CAGE au ras des disques (z 209.35),
   limitee a la cage (y 30..196), avec levre avant (deflecteur) jusqu'au top :
   vis 6-32 a portee, plus de by-pass au-dessus des disques, fentes du top
   debouchees
 - B2 fans recentres (x 80/202) + poteaux d'angle 14 x 24 : hors emprise fans
 - B3 poteaux en miroir (corner_post / corner_post_m) : poches M4 sur les
   2 faces panneau du coin + pied + tete ; trous "milieu de bord" supprimes
 - B4 plus de lid sous le top : aucune collision lid/poteaux
 - B5 struts places en coordonnees MONDE (strut_x/strut_y), trous derives
 - B6 PSU : 4 plots 12 mm sous le CX430 + 4 trous ATX 6-32 au panneau arriere
   (decoupe reduite pour laisser de la matiere autour des trous)
 - M2 Add2PSU deplace sous l'etagere, sur 4 bossages 9.1 mm (inserts M3)
 - M3 etagere : 3 colonnes de struts (portee 117 mm) + joues laterales
   (porte la plaque de cage, ferme le by-pass lateral) ; gap disques 6.5
 - M4 flanc droit : fraisage cote exterieur
 - mineurs : grille avant pas 12 / barreau 4 (jours 8 mm), fan_guard 8 barres
   uniques (16 rayons), pieds fraises cote interieur + logement patin,
   jeu 0.3 etagere/plaque vs flancs

Unites : mm. Repere monde : X (largeur 0..282), Y (prof. 0..360), Z (haut 0..260).

REFERENCES : cf. v2 (SFF-8301 Table 3-1, ES.3, CX430, Add2PSU, Ruthex).
 - ATX : 4 trous 6-32 face arriere, coords (vue de l'arriere, origine coin
   bas-gauche) (6,80) (144,80) (120,6) (6,16) — A VERIFIER sur le CX430
   (orientation fan en bas/haut => motif retourne).

Parts : assembly, exploded, front, rear, left, right, bottom, top, shelf,
        cage_plate, strut, corner_post, corner_post_m, fan_guard,
        atx_bridge, box_foot
*/

$fn = 48;

/* ================= PARAMETRES ================= */
part = "assembly";

W = 282; D = 360; H = 260;
t  = 4;      // panneaux
ts = 3.2;    // etagere / plaque de cage
iw = W-2*t;  // 274
id = D-2*t;  // 352
ih = H-2*t;  // 252
clr = 0.3;

/* visserie */
m4_pilot = 3.3;
m4_clear = 4.3;
m4_head  = 8.6;
ruthex_m4 = 5.6;   ruthex_m4_depth = 9.1;   // M4x8.1 : L + 1
ruthex_m3 = 4.0;   ruthex_m3_depth = 6.7;   // M3x5.7 : L + 1
m3_clear = 3.2;    m3_head = 6.5;
m632     = 3.9;    // passage 6-32 (disques, PSU)

/* disques (SFF-8301) */
n = 8;
hdd_thick  = 26.1;   // X
hdd_len    = 147.0;  // Y
hdd_height = 101.85; // Z
hdd_gap    = 6.5;
pitch      = hdd_thick + hdd_gap;   // 32.6
side_off   = 6.35;   // A10
side_y1    = 28.50;  // A8
side_y2    = 130.10; // A8+A9

cage_w   = n*pitch - hdd_gap;         // 254.3
cage_x0  = (iw - cage_w)/2 + t;       // 13.85
stack_y0 = 48;
conn_y   = stack_y0 + hdd_len;        // 195

/* etagere + plaque de cage (local = monde - [sh_x0, sh_y0]) */
sh_x0 = t + clr;            // 4.3
sh_w  = iw - 2*clr;         // 273.4
sh_y0 = 30;
sh_d  = 166;                // y 30..196
sh_z0 = 104;                // dessous etagere = tete des struts
stack_z0 = sh_z0 + ts;                       // 107.2
plate_z0 = stack_z0 + hdd_height + clr;      // 209.35
cheek_w  = cage_x0 - 0.5 - sh_x0;            // 9.05 (joue laterale)
cheek_h  = plate_z0 - stack_z0;              // 102.15
cheek_iy = [8, sh_d-8];                      // inserts M3 en tete de joue
lip_h    = H - t - clr - (plate_z0 + ts);    // levre avant -> sous le top

drive_x = [for(i=[0:n-1]) cage_x0 + i*pitch];
screw_x = [for(x=drive_x) x + side_off];
screw_y = [conn_y - side_y1, conn_y - side_y2];   // 166.5 / 64.9

/* struts (monde) : 3 colonnes x 3 rangees, sous l'etagere */
strut_x = [24, 141, 258];
strut_y = [50, 118, 186];
strut_s = 24;

/* poteaux d'angle 14 (X) x 24 (Y), z 4..256 */
post_w = 14; post_d = 24; post_h = ih;
post_cx = [t + post_w/2, W - t - post_w/2];   // 11 / 271
post_cy = [t + post_d/2, D - t - post_d/2];   // 16 / 344
post_zy = [14, ih-14];    // poches faces Y (avant/arriere), z local poteau
post_zx = [28, ih-28];    // poches faces X (flancs)

/* fans */
fan_side=120; fan_cut=114; fan_pitch=105; fan_screw=4.5;
fan_cx = [80, 202];    // monde X : x 20..140 / 142..262
fan_cz = 160;          // monde Z : z 100..220

/* PSU CX430 */
psu_w=150; psu_h=86; psu_d=140;
psu_x0=66; psu_y0=216; psu_z0=16;
psu_pad = 20;                      // plots 20x20x12 aux 4 coins
psu_win = 11;                      // retrait de la decoupe arriere
psu_holes = [[6,80],[144,80],[120,6],[6,16]];   // ATX, vue arriere

/* Add2PSU (70 x 30, entraxe 64 x 24) : sous l'etagere */
a2p_l=70; a2p_w=30; a2p_x=52; a2p_y=137;
a2p_dx=64; a2p_dy=24; a2p_boss=9.1;

/* grommets SAS + passe-cable Molex (arriere) */
grom_d=36; grom_x=[78,205]; grom_z=158;
molex_d=12; molex_x=141; molex_z=200;

/* pieds */
foot_xy = [[44,24],[238,24],[44,332],[238,332]];   // monde

/* ================= HELPERS ================= */
module cyl(d,h) cylinder(h=h, d=d);
module rtx4(h=ruthex_m4_depth) cylinder(h=h, d=ruthex_m4);
module rtx3(h=ruthex_m3_depth) cylinder(h=h, d=ruthex_m3);
// passage M4 + fraisage tete cote local z=0
module m4_csk() {
    translate([0,0,-1]) cyl(m4_clear, t+2);
    translate([0,0,-1]) cylinder(h=2.2, d=m4_head, $fn=24);
}
// idem, fraisage cote local z=t
module m4_csk_ext() {
    translate([0,0,-1]) cyl(m4_clear, t+2);
    translate([0,0,t-1.2]) cylinder(h=2.2, d=m4_head, $fn=24);
}
module slab(w,h,th=t) linear_extrude(height=th) offset(r=3) offset(delta=-3)
    square([w,h]);

// trous panneaux -> poteaux (coords locales des panneaux, derivees des poteaux)
function xz_holes() = [for (x=post_cx, z=post_zy) [x-t, z]];       // avant/arriere
function yz_holes() = [for (y=post_cy, z=post_zx) [y-t, z]];       // flancs
function xy_holes() = [for (x=post_cx, y=post_cy) [x-t, y-t]];     // fond/top

/* ================= FACE AVANT (274 x 252) =================
   local : lx=Xm-4, ly=Zm-4 ; z=0 face interieure (y=4).                    */
module front() {
    difference() {
        union() {
            difference() {
                slab(iw, ih);
                for (cx=fan_cx) translate([cx-t, fan_cz-t, -1])
                    cyl(fan_cut, t+2);
            }
            // barreaux verticaux pas 12 / 4 mm (jours 8 mm), limites aux
            // decoupes (+0.5 noyes dans la matiere), enfonces 0.2 par face
            intersection() {
                for (x=[fan_cx[0]-t-fan_cut/2 : 12 : fan_cx[1]-t+fan_cut/2])
                    translate([x-2, fan_cz-t-fan_cut/2-1, 0.2])
                        cube([4, fan_cut+2, t-0.4]);
                for (cx=fan_cx) translate([cx-t, fan_cz-t, 0])
                    cyl(fan_cut+1, t);
            }
        }
        // fixations fans (perce aussi d'eventuels barreaux)
        for (cx=fan_cx, dx=[-1,1], dz=[-1,1])
            translate([cx-t+dx*fan_pitch/2, fan_cz-t+dz*fan_pitch/2, -1])
                cyl(fan_screw, t+2);
        for (p=xz_holes()) translate(p) m4_csk_ext();
    }
}

/* ================= FACE ARRIERE (274 x 252) =================
   local : lx=Xm-4, ly=Zm-4 ; z=0 face exterieure (y=360).
   Vue de l'arriere, la gauche de l'observateur est +X monde.               */
module rear() {
    difference() {
        slab(iw, ih);
        // fenetre PSU (retrait psu_win : matiere autour des trous ATX)
        translate([psu_x0+psu_win-t, psu_z0+psu_win-t, -1])
            cube([psu_w-2*psu_win, psu_h-2*psu_win, t+2]);
        // trous ATX 6-32 (origine coin bas-gauche vue arriere = X max)
        for (h=psu_holes)
            translate([psu_x0+psu_w-h[0]-t, psu_z0+h[1]-t, -1]) cyl(m632, t+2);
        // grommets SAS + Molex
        for (gx=grom_x) translate([gx-t, grom_z-t, -1]) cyl(grom_d, t+2);
        translate([molex_x-t, molex_z-t, -1]) cyl(molex_d, t+2);
        // extraction : 2 rangees de fentes 5 mm, x 30..250 (entre poteaux)
        for (x=[30:10:250]) {
            translate([x-t, 106-t, -1]) cube([5, 20, t+2]);   // z 106..126
            translate([x-t, 212-t, -1]) cube([5, 36, t+2]);   // z 212..248
        }
        // admission PSU : fentes sous le CX430, entre les plots
        for (x=[90:16:186]) translate([x-t, 6-t, -1]) cube([5, 8, t+2]);
        for (p=xz_holes()) translate(p) m4_csk();
    }
    // collerettes grommets saillantes 1 mm cote interieur
    for (gx=grom_x) translate([gx-t, grom_z-t, t]) difference() {
        cylinder(h=1, d=grom_d+16);
        translate([0,0,-1]) cylinder(h=3, d=grom_d);
    }
}

/* ================= FLANCS (352 x 252) =================
   local : lx=Ym-4, ly=Zm-4. Gauche : z=0 exterieur ; droit : z=0 interieur. */
module side(ext_at_z0=true) {
    difference() {
        slab(id, ih);
        for (p=yz_holes()) translate(p)
            if (ext_at_z0) m4_csk(); else m4_csk_ext();
    }
}
module sideL() side(true);
module sideR() side(false);

/* ================= FOND (274 x 352) =================
   local : lx=Xm-4, ly=Ym-4 ; z=0 dessous (exterieur).                      */
module bottom() {
    difference() {
        union() {
            slab(iw, id);
            // plots PSU 20x20x12 (z 4..16) aux 4 coins du CX430
            for (px=[psu_x0, psu_x0+psu_w-psu_pad],
                 py=[psu_y0+4, psu_y0+psu_d-psu_pad-4])
                translate([px-t, py-t, t-0.1]) cube([psu_pad, psu_pad, psu_z0-t+0.1]);
            // bossages Add2PSU (h 9.1, inserts M3)
            for (p=a2p_holes()) translate([p[0]-t, p[1]-t, t-0.1])
                cyl(9, a2p_boss+0.1);
        }
        // poteaux d'angle : M4 fraise dessous -> insert en pied de poteau
        for (p=xy_holes()) translate(p) m4_csk();
        // struts : M4 fraise dessous -> pilote borgne du strut
        for (x=strut_x, y=strut_y) translate([x-t, y-t, 0]) m4_csk();
        // pieds : vis par l'INTERIEUR -> fraisage cote z=t
        for (p=foot_xy) translate([p[0]-t, p[1]-t, 0]) m4_csk_ext();
        // poches inserts M3 en tete de bossage
        for (p=a2p_holes())
            translate([p[0]-t, p[1]-t, t+a2p_boss-ruthex_m3_depth]) rtx3(ruthex_m3_depth+1);
    }
}
function a2p_holes() = [for (dx=[0,a2p_dx], dy=[0,a2p_dy])
    [a2p_x+(a2p_l-a2p_dx)/2+dx, a2p_y+(a2p_w-a2p_dy)/2+dy]];

/* ================= PLAFOND (274 x 352) =================
   local : lx=Xm-4, ly=Ym-4 ; z=0 face interieure.                          */
module top() {
    difference() {
        slab(iw, id);
        for (p=xy_holes()) translate(p) m4_csk_ext();
        // event au-dessus du plenum (derriere la plaque de cage, y > 196)
        for (x=[40:16:236]) translate([x-t, 200-t, -1]) cube([5, 130, t+2]);
    }
}

/* ================= ETAGERE + JOUES (273.4 x 166) =================
   local : lx=Xm-4.3, ly=Ym-30, z=0 a z monde 104. Les joues (x 4.3..13.35
   et symetrique) portent la plaque de cage et ferment les cotes de la cage. */
module shelf() {
    difference() {
        union() {
            slab(sh_w, sh_d, ts);
            for (x=[0, sh_w-cheek_w]) translate([x, 0, ts-0.1])
                cube([cheek_w, sh_d, cheek_h+0.1]);
        }
        // vis M3 vers les struts : fraisage cote DESSUS (disques posent dessus)
        for (x=strut_x, y=strut_y) translate([x-sh_x0, y-sh_y0, 0]) {
            translate([0,0,-1]) cyl(m3_clear, ts+2);
            translate([0,0,ts-1.9]) cylinder(h=2, d=m3_head, $fn=24);
        }
        // inserts M3 en tete de joue (plaque de cage)
        for (x=[cheek_w/2, sh_w-cheek_w/2], y=cheek_iy)
            translate([x, y, ts+cheek_h-ruthex_m3_depth]) rtx3(ruthex_m3_depth+1);
    }
}

/* ================= PLAQUE DE CAGE (273.4 x 166, ts 3.2) =================
   local : lx=Xm-4.3, ly=Ym-30, z=0 a z monde 209.35 (0.3 au-dessus des
   disques). 16 vis 6-32 x 1/4" : penetration 6.35-3.2-0.3 = 2.85 mm
   (SFF-8301 : 2.39..3.56). Levre avant = deflecteur jusqu'au top.          */
module cage_plate() {
    difference() {
        union() {
            slab(sh_w, sh_d, ts);
            translate([0, 0, ts-0.1]) cube([sh_w, ts, lip_h+0.1]);
        }
        for (sx=screw_x, sy=screw_y)
            translate([sx-sh_x0, sy-sh_y0, -1]) cyl(m632, ts+2);
        for (x=[cheek_w/2, sh_w-cheek_w/2], y=cheek_iy)
            translate([x, y, 0]) {
                translate([0,0,-1]) cyl(m3_clear, ts+2);
                translate([0,0,ts-1.9]) cylinder(h=2, d=m3_head, $fn=24);
            }
    }
}

/* ================= STRUCTURE ================= */
// strut 24x24 x 100 (z 4..104) : pilote M4 borgne en pied, insert M3 en tete
module strut() {
    difference() {
        cube([strut_s, strut_s, sh_z0-t]);
        translate([strut_s/2, strut_s/2, sh_z0-t-ruthex_m3_depth]) rtx3(ruthex_m3_depth+1);
        translate([strut_s/2, strut_s/2, -1]) cyl(m4_pilot, 13);
    }
}

// poteau d'angle AVANT-GAUCHE (14 x 24 x 252) : poches M4 face -X (flanc),
// face -Y (avant), pied et tete. corner_post_m = miroir X (avant-droit,
// arriere-gauche) ; corner_post tourne de 180 deg = arriere-droit.
module corner_post() {
    difference() {
        cube([post_w, post_d, post_h]);
        for (z=post_zy) translate([post_w/2, -1, z]) rotate([-90,0,0]) rtx4(ruthex_m4_depth+1);
        for (z=post_zx) translate([-1, post_d/2, z]) rotate([0,90,0]) rtx4(ruthex_m4_depth+1);
        translate([post_w/2, post_d/2, -1]) rtx4(ruthex_m4_depth+1);
        translate([post_w/2, post_d/2, post_h-ruthex_m4_depth]) rtx4(ruthex_m4_depth+1);
    }
}
module corner_post_m() mirror([1,0,0]) corner_post();

module place_posts() {
    translate([t, t, t])         corner_post();                       // AV-G
    translate([W-t, t, t])       mirror([1,0,0]) corner_post();       // AV-D
    translate([t, D-t, t])       mirror([0,1,0]) corner_post();       // AR-G
    translate([W-t, D-t, t])     rotate([0,0,180]) corner_post();     // AR-D
}

/* ================= ACCESSOIRES ================= */
module atx_bridge() {   // pont PS_ON de secours (sans Add2PSU)
    difference() {
        cube([14,10,8]);
        for (x=[3.5,7,10.5]) translate([x,5,-1]) cylinder(h=10,d=2.7,$fn=16);
    }
}
module box_foot() {     // pied 30x30x12 : vis M4 par l'interieur, patin ⌀20 dessous
    difference() {
        cube([30,30,12]);
        translate([15,15,1.5]) cyl(m4_pilot, 12);
        translate([15,15,-1]) cyl(20.5, 2.5);     // logement patin elastomere 1.5
    }
}
module fan_guard() {    // grille 120, ep 3 : 8 barres uniques = 16 rayons
    difference() {
        union() {
            difference() {
                translate([-62,-62,0]) linear_extrude(height=3)
                    offset(r=3) offset(delta=-3) square([124,124]);
                translate([0,0,-1]) cylinder(h=5, d=fan_cut-8);
            }
            for (a=[0:22.5:157.5]) rotate([0,0,a])
                translate([-(fan_cut-7)/2,-1.5,0.2]) cube([fan_cut-7,3,2.6]);
        }
        for (dx=[-1,1], dz=[-1,1])
            translate([dx*fan_pitch/2, dz*fan_pitch/2, -1]) cylinder(h=5, d=fan_screw);
        translate([0,0,-1]) cylinder(h=5, d=12);
    }
}

/* ================= FANTOMES ================= */
show_ghosts = true;
module drives() {
    if (show_ghosts) %for (x=drive_x)
        translate([x, stack_y0, stack_z0+0.05]) cube([hdd_thick, hdd_len, hdd_height]);
}
module psu() {
    if (show_ghosts) %translate([psu_x0, psu_y0, psu_z0+0.05]) cube([psu_w, psu_d-0.3, psu_h]);
}
module fans() {
    if (show_ghosts) %for (cx=fan_cx)
        translate([cx-fan_side/2, t+0.3, fan_cz-fan_side/2]) cube([fan_side, 25, fan_side]);
}
module add2psu() {
    if (show_ghosts) %translate([a2p_x, a2p_y, t+a2p_boss+0.05]) cube([a2p_l, a2p_w, 15]);
}

/* ================= PLACEMENT ================= */
module place(e=0) {   // e : amplitude d'eclatement (0 = assemble)
    color("DimGray") {
        translate([-e, t, t])        rotate([90,0,90]) sideL();
        translate([W-t+e, t, t])     rotate([90,0,90]) sideR();
        translate([t, t, -e])        bottom();
        translate([t, t, H-t+e])     top();
    }
    color("SlateGray") {
        translate([t, t-e, t])       rotate([90,0,0]) front();
        translate([t, D+e, t])       rotate([90,0,0]) rear();
    }
    color("Orange") {
        translate([sh_x0, sh_y0, sh_z0+e*0.4])    shelf();
        translate([sh_x0, sh_y0, plate_z0+e*1.6]) cage_plate();
    }
    color("Gray") for (x=strut_x, y=strut_y)
        translate([x-strut_s/2, y-strut_s/2, t]) strut();
    color("Goldenrod") place_posts();
    drives(); psu(); fans(); add2psu();
}
module assembly() place(0);
module exploded() place(60);

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
else if (part=="cage_plate") cage_plate();
else if (part=="strut") strut();
else if (part=="corner_post") corner_post();
else if (part=="corner_post_m") corner_post_m();
else if (part=="fan_guard") fan_guard();
else if (part=="atx_bridge") atx_bridge();
else if (part=="box_foot") box_foot();
