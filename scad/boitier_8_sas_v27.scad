/*
Boitier DAS 8x 3.5" SAS (Seagate Constellation ES.3) + ATX (Corsair CX430)
v2.7 — fiabilisation (canaux de bord, calage, cablage, rigidite) + outillage.
Fichier neuf : la v2.6 (boitier_8_sas_v26.scad) est conservee telle quelle.

v2.7 :
 - A1 joues d'etagere : paroi 2.5 mm + 2 piliers 9 x 10 sous les inserts M3
   (au lieu d'une joue pleine de 9.05) -> canal d'air ~7 mm cote exterieur des
   disques 1 et 8 (le PCB du disque 1 n'est plus a 0.5 mm d'une paroi)
 - A2 peignes de calage sur l'etagere (2 rangees, entre les disques)
 - A3 barrette serre-cables `cable_bar` (connecteurs SFF-8482 -> grommets),
   vissee par les flancs (inserts M3 axiaux)
 - A4 passants pour colliers dans le fond (cables inutilises du CX430)
 - A5 option `sas_ext` : 2 fenetres pour equerres SFF-8644 -> 8643 (slot PCIe)
   a la place des grommets
 - B1 cornieres `edge_rail` sur 7 aretes horizontales (pas l'arete
   arriere-basse : panneau tenu par le PSU et fentes d'admission)
 - B2 option `fan_iso` : trous 5.5 + joint TPU `fan_gasket` entre fan et panneau
 - C  placement factorise (panels / internals / components) pour
   tools/check.scad ; fentes, events, pieds et grommets derives des parametres
 - struts x 26/256 (au lieu de 24/258) : place pour les cornieres laterales

Unites : mm. Repere monde : X (largeur 0..282), Y (prof. 0..360), Z (haut 0..260).

REFERENCES : cf. v2 (SFF-8301 Table 3-1, ES.3, CX430, Add2PSU, Ruthex).
 - CX430 MESURE (2026-11-01), ventilateur VERS LE HAUT (aspire le plenum),
   face arriere vue de l'exterieur, origine coin bas-gauche :
   trous 6-32 (6.5,81.5) (144.5,81.5) (6.5,16.5) (120.5,6.5) ;
   IEC x 97..146 z 13..35 ; interrupteur x 111..132 z 41..57 ;
   grille x 11..140 z 7..81 (x <= 92 a hauteur IEC/interrupteur).

Parts : assembly, exploded, cutaway, front, rear, left, right, bottom, top,
        shelf, cage_plate, strut, corner_post, corner_post_m, edge_rail_x,
        edge_rail_y, cable_bar, fan_guard, fan_gasket, atx_bridge, box_foot
*/

$fn = 48;

/* ================= PARAMETRES ================= */
part = "assembly";
sas_ext = false;   // true : equerres SFF-8644 au lieu des grommets
fan_iso = false;   // true : joint TPU + trous 5.5 (vis + rondelles caoutchouc)

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

/* fans */
fan_side=120; fan_cut=114; fan_pitch=105; fan_depth=25;
fan_screw = fan_iso ? 5.5 : 4.5;
gasket_t  = fan_iso ? 1.5 : 0;
fan_cx = [80, 202];    // monde X : x 20..140 / 142..262
fan_cz = 160;          // monde Z : z 100..220

/* etagere + plaque de cage (local = monde - [sh_x0, sh_y0]) */
sh_x0 = t + clr;            // 4.3
sh_w  = iw - 2*clr;         // 273.4
sh_y0 = t + clr + gasket_t + fan_depth + 0.7;   // 30 (31.5 avec fan_iso) : derriere les fans
sh_d  = 166;                // y 30..196 (fan_iso : 31.5..197.5)
sh_z0 = 104;                // dessous etagere = tete des struts
stack_z0 = sh_z0 + ts;                       // 107.2
plate_z0 = stack_z0 + hdd_height + clr;      // 209.35
cheek_t  = 2.5;                              // paroi de joue (cote flanc)
cheek_p  = [9, 10];                          // piliers sous inserts (X, Y)
cheek_h  = plate_z0 - stack_z0;              // 102.15
cheek_iy = [8, sh_d-8];                      // inserts M3 en tete de pilier
cheek_ix = [cheek_p[0]/2, sh_w-cheek_p[0]/2];
lip_h    = H - t - clr - (plate_z0 + ts);    // levre avant -> sous le top

drive_x = [for(i=[0:n-1]) cage_x0 + i*pitch];
screw_x = [for(x=drive_x) x + side_off];
screw_y = [conn_y - side_y1, conn_y - side_y2];   // 166.5 / 64.9

/* peignes de calage (monde Y) : hors des tetes de vis des struts */
comb_h = 5;  comb_l = 10;
comb_y = [stack_y0 + 8, conn_y - 30];             // y 56..66 / 165..175
// nervures : entre disques (jeu clr de chaque cote) + entre paroi et disques 1/8
comb_x = concat(
    [[sh_x0 + cheek_t, drive_x[0] - clr]],
    [for (i=[0:n-2]) [drive_x[i]+hdd_thick+clr, drive_x[i+1]-clr]],
    [[drive_x[n-1]+hdd_thick+clr, sh_x0 + sh_w - cheek_t]]);

/* struts (monde) : 3 colonnes x 3 rangees, sous l'etagere */
strut_x = [26, 141, 256];
strut_y = [50, 118, 186];
strut_s = 24;

/* poteaux d'angle 14 (X) x 24 (Y), z 4..256 */
post_w = 14; post_d = 24; post_h = ih;
post_cx = [t + post_w/2, W - t - post_w/2];   // 11 / 271
post_cy = [t + post_d/2, D - t - post_d/2];   // 16 / 344
post_zy = [14, ih-14];    // poches faces Y (avant/arriere), z local poteau
post_zx = [28, ih-28];    // poches faces X (flancs)

/* cornieres d'aretes (L rail_l x rail_l, ep. rail_t), entre les poteaux */
rail_l = 9; rail_t = 2.5; rail_boss = 24;
rail_x0 = t + post_w + clr;   rail_lx = W - 2*(t + post_w + clr);   // 18.3, 245.4
rail_y0 = t + post_d + clr;   rail_ly = D - 2*(t + post_d + clr);   // 28.3, 303.4
// [panneau A (face w), panneau B (face v), origine, v, w, longueur]
// axe u = v x w ; vis A a L/2-6 dans la face w=0, vis B a L/2+6 dans v=0
rails = [
  ["bottom","front",[rail_x0,         t,   t], [0, 1,0],[0,0, 1], rail_lx],
  ["top",   "front",[rail_x0+rail_lx, t,   H-t],[0, 1,0],[0,0,-1], rail_lx],
  ["top",   "rear", [rail_x0,         D-t, H-t],[0,-1,0],[0,0,-1], rail_lx],
  ["bottom","left", [t,   rail_y0+rail_ly, t], [ 1,0,0],[0,0, 1], rail_ly],
  ["bottom","right",[W-t, rail_y0,         t], [-1,0,0],[0,0, 1], rail_ly],
  ["top",   "left", [t,   rail_y0,         H-t],[ 1,0,0],[0,0,-1], rail_ly],
  ["top",   "right",[W-t, rail_y0+rail_ly, H-t],[-1,0,0],[0,0,-1], rail_ly]];

/* PSU CX430 */
psu_w=150; psu_h=86; psu_d=140;
psu_x0=66; psu_y0=216; psu_z0=16;
psu_pad = 20;                      // plots 20x20x12 aux 4 coins
psu_holes = [[6.5,81.5],[144.5,81.5],[6.5,16.5],[120.5,6.5]];  // mesures, vue arriere
psu_slot  = 0.75;                  // jeu vertical +/- des trous (oblongs)
// fenetre arriere (vue arriere, coords PSU) : grille + interrupteur + IEC
// (+2 mm de marge), >= 2.5 mm de matiere autour de chaque trou
psu_win = [[11,7, 92,79],     // grille, partie gauche
           [11,37, 140,79],   // grille haute + interrupteur
           [92,12, 148,37]];  // prise IEC (bas a 12 : matiere sous le trou bas-droit)
psu_hole_top = psu_z0 + max([for (h=psu_holes) h[1]]) + psu_slot + m632/2;  // 100.2

/* Add2PSU (70 x 30, entraxe 64 x 24) : sous l'etagere */
a2p_l=70; a2p_w=30; a2p_x=52; a2p_y=137;
a2p_dx=64; a2p_dy=24; a2p_boss=9.1;

/* grommets SAS (ou equerres SFF-8644) + passe-cable Molex (arriere) */
grom_d=36; grom_x=[78,205];
grom_z = round((stack_z0 + plate_z0)/2);   // mi-hauteur des disques : 158
sas_win = [15, 90];                        // fenetre equerre PCIe (X x Z), a confirmer
molex_d=12; molex_x=141; molex_z=200;

/* barrette serre-cables (monde) : derriere les connecteurs, au-dessus du PSU */
cbar_s = [12, 10];                    // section Y x Z
cbar_y = 235; cbar_z = 140;           // centre
cbar_tie = [2.5, 5];                  // fentes colliers (X x Y)

/* fentes / events (derives) */
slot_w = 5;
function centered(n, p, c=W/2) = [for (i=[0:n-1]) c - ((n-1)*p + slot_w)/2 + i*p];
rear_slot_x  = centered(23, 10);                         // x 28.5..253.5
rear_slot_lo = [ceil(psu_hole_top + 5), ceil(psu_hole_top + 5) + 20];   // z 106..126
rear_slot_hi = [plate_z0 + 3, H - t - rail_l - 4];       // z 212.35..243
psu_slot_x   = [for (x=[psu_x0+psu_pad+4 : 16 : psu_x0+psu_w-psu_pad-4-slot_w]) x];
psu_slot_z   = [t + 2, psu_z0 - 2];                      // z 6..14
top_vent_x   = centered(13, 16);                         // x 42.5..239.5
top_vent_y   = [sh_y0 + sh_d + 4, post_cy[1] - post_d/2 - 2];   // y 200..330

/* pieds (monde) et passants colliers du fond */
foot_in = [44, 24];
foot_xy = [for (x=[foot_in[0], W-foot_in[0]], y=[foot_in[1], D-foot_in[1]]) [x,y]];
tie_xy  = [[60,84],[110,84],[175,84],[220,84],[175,150],[220,150],[100,206],[180,206]];

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
// passage M3 + fraisage tete (panneau t), cote z=0 ou z=t
module m3_csk(ext=false) {
    translate([0,0,-1]) cyl(m3_clear, t+2);
    translate([0,0, ext ? t-1.9 : -1]) cylinder(h=2.9, d=m3_head, $fn=24);
}
module slab(w,h,th=t) linear_extrude(height=th) offset(r=3) offset(delta=-3)
    square([w,h]);

function cross3(a,b) = [a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]];
function rail_u(r) = cross3(r[3], r[4]);
function rail_pA(r) = r[2] + (r[5]/2-6)*rail_u(r) + (rail_l/2)*r[3];   // face panneau A
function rail_pB(r) = r[2] + (r[5]/2+6)*rail_u(r) + (rail_l/2)*r[4];   // face panneau B
// points monde des vis M3 (cornieres + barrette) traversant un panneau
function m3_pts(p) = concat(
    [for (r=rails) if (r[0]==p) rail_pA(r)],
    [for (r=rails) if (r[1]==p) rail_pB(r)],
    p=="left"  ? [[t,   cbar_y, cbar_z]] :
    p=="right" ? [[W-t, cbar_y, cbar_z]] : []);

// passage monde -> local des panneaux
function xz_l(p) = [p[0]-t, p[2]-t];   // avant / arriere
function yz_l(p) = [p[1]-t, p[2]-t];   // flancs
function xy_l(p) = [p[0]-t, p[1]-t];   // fond / top

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
        for (p=m3_pts("front")) translate(xz_l(p)) m3_csk(true);
    }
}

/* ================= FACE ARRIERE (274 x 252) =================
   local : lx=Xm-4, ly=Zm-4 ; z=0 face exterieure (y=360).
   Vue de l'arriere, la gauche de l'observateur est +X monde.               */
module rear() {
    difference() {
        slab(iw, ih);
        // fenetre PSU (vue arriere : x PSU croissant = X monde decroissant)
        for (r=psu_win)
            translate([psu_x0+psu_w-r[2]-t, psu_z0+r[1]-t, -1])
                cube([r[2]-r[0], r[3]-r[1], t+2]);
        // trous 6-32 oblongs verticaux (+/- psu_slot)
        for (h=psu_holes)
            translate([psu_x0+psu_w-h[0]-t, psu_z0+h[1]-t, -1])
                hull() for (dz=[-psu_slot, psu_slot]) translate([0,dz,0]) cyl(m632, t+2);
        // SAS : grommets, ou fenetres d'equerres SFF-8644 + vis de patte M3
        for (gx=grom_x)
            if (sas_ext) {
                translate([gx-sas_win[0]/2-t, grom_z-sas_win[1]/2-t, -1])
                    cube([sas_win[0], sas_win[1], t+2]);
                translate([gx-t, grom_z+sas_win[1]/2+5-t, -1]) cyl(m3_clear, t+2);
            } else
                translate([gx-t, grom_z-t, -1]) cyl(grom_d, t+2);
        translate([molex_x-t, molex_z-t, -1]) cyl(molex_d, t+2);
        // extraction : 2 rangees de fentes entre les poteaux
        // (sas_ext : pas de fente au droit des equerres)
        for (x=rear_slot_x)
            if (!sas_ext || min([for (gx=grom_x) abs(x+slot_w/2-gx)]) > 12)
                for (r=[rear_slot_lo, rear_slot_hi])
                    translate([x-t, r[0]-t, -1]) cube([slot_w, r[1]-r[0], t+2]);
        // fentes sous le CX430, entre les plots
        for (x=psu_slot_x) translate([x-t, psu_slot_z[0]-t, -1])
            cube([slot_w, psu_slot_z[1]-psu_slot_z[0], t+2]);
        for (p=xz_holes()) translate(p) m4_csk();
        for (p=m3_pts("rear")) translate(xz_l(p)) m3_csk(false);
    }
    // collerettes grommets saillantes 1 mm cote interieur
    if (!sas_ext) for (gx=grom_x) translate([gx-t, grom_z-t, t]) difference() {
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
        for (p=m3_pts(ext_at_z0 ? "left" : "right")) translate(yz_l(p))
            m3_csk(!ext_at_z0);
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
            // passants colliers 8 x 10 x 5 (lumiere 4 x 2.5 suivant X)
            for (p=tie_xy) translate([p[0]-t-4, p[1]-t-5, t-0.1]) difference() {
                cube([8, 10, 5.1]);
                translate([-1, 3, 0.1]) cube([10, 4, 2.6]);
            }
        }
        // poteaux d'angle : M4 fraise dessous -> insert en pied de poteau
        for (p=xy_holes()) translate(p) m4_csk();
        // struts : M4 fraise dessous -> pilote borgne du strut
        for (x=strut_x, y=strut_y) translate([x-t, y-t, 0]) m4_csk();
        // pieds : vis par l'INTERIEUR -> fraisage cote z=t
        for (p=foot_xy) translate(xy_l(p)) m4_csk_ext();
        // poches inserts M3 en tete de bossage
        for (p=a2p_holes())
            translate([p[0]-t, p[1]-t, t+a2p_boss-ruthex_m3_depth]) rtx3(ruthex_m3_depth+1);
        for (p=m3_pts("bottom")) translate(xy_l(p)) m3_csk(false);
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
        // event au-dessus du plenum (derriere la plaque de cage)
        for (x=top_vent_x) translate([x-t, top_vent_y[0]-t, -1])
            cube([slot_w, top_vent_y[1]-top_vent_y[0], t+2]);
        for (p=m3_pts("top")) translate(xy_l(p)) m3_csk(true);
    }
}

/* ================= ETAGERE + JOUES (273.4 x 166) =================
   local : lx=Xm-4.3, ly=Ym-30, z=0 a z monde 104. Joues : paroi 2.5 cote flanc
   + 2 piliers 9 x 10 (inserts M3) qui portent la plaque de cage ; canal
   d'air ~7 mm entre paroi et disques 1 / 8. Peignes de calage dessus.       */
module shelf() {
    difference() {
        union() {
            slab(sh_w, sh_d, ts);
            for (x=[0, sh_w-cheek_t]) translate([x, 0, ts-0.1])
                cube([cheek_t, sh_d, cheek_h+0.1]);
            for (x=cheek_ix, y=cheek_iy)
                translate([x-cheek_p[0]/2, y-cheek_p[1]/2, ts-0.1])
                    cube([cheek_p[0], cheek_p[1], cheek_h+0.1]);
            // peignes : nervures entre disques, h comb_h, sur comb_l en Y
            for (cx=comb_x, y=comb_y)
                translate([cx[0]-sh_x0, y-sh_y0, ts-0.1])
                    cube([cx[1]-cx[0], comb_l, comb_h+0.1]);
        }
        // vis M3 vers les struts : fraisage cote DESSUS (disques posent dessus)
        for (x=strut_x, y=strut_y) translate([x-sh_x0, y-sh_y0, 0]) {
            translate([0,0,-1]) cyl(m3_clear, ts+2);
            translate([0,0,ts-1.9]) cylinder(h=2, d=m3_head, $fn=24);
        }
        // inserts M3 en tete de pilier (plaque de cage)
        for (x=cheek_ix, y=cheek_iy)
            translate([x, y, ts+cheek_h-ruthex_m3_depth]) rtx3(ruthex_m3_depth+1);
    }
}

/* ================= PLAQUE DE CAGE (273.4 x 166, ts 3.2) =================
   local : lx=Xm-4.3, ly=Ym-30, z=0 a z monde 209.35 (0.3 au-dessus des
   disques). 16 vis 6-32 x 1/4" : penetration 6.35-3.2-0.3 = 2.85 mm
   (SFF-8301 : 2.39..3.56). Levre avant = deflecteur jusqu'au top, entaillee
   aux coins pour les cornieres hautes.                                     */
module cage_plate() {
    notch_x = t + rail_l + clr - sh_x0;          // 9 (local)
    notch_z = H - t - rail_l - clr - plate_z0;   // z local du bas de l'entaille
    difference() {
        union() {
            slab(sh_w, sh_d, ts);
            translate([0, 0, ts-0.1]) cube([sh_w, ts, lip_h+0.1]);
        }
        for (sx=screw_x, sy=screw_y)
            translate([sx-sh_x0, sy-sh_y0, -1]) cyl(m632, ts+2);
        for (x=cheek_ix, y=cheek_iy)
            translate([x, y, 0]) {
                translate([0,0,-1]) cyl(m3_clear, ts+2);
                translate([0,0,ts-1.9]) cylinder(h=2, d=m3_head, $fn=24);
            }
        for (x=[-1, sh_w-notch_x]) translate([x, -1, notch_z])
            cube([notch_x+1, ts+2, lip_h]);
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

// corniere L rail_l x rail_l, ep. rail_t, longueur L (local : x = axe,
// face z=0 contre le panneau A, face y=0 contre le panneau B). Bossage plein
// a mi-longueur : insert M3 face z=0 a L/2-6, face y=0 a L/2+6.
// S'imprime sur le dos (face z=0), sans support.
module edge_rail(L) {
    difference() {
        union() {
            cube([L, rail_l, rail_t]);
            cube([L, rail_t, rail_l]);
            translate([L/2-rail_boss/2, 0, 0]) cube([rail_boss, rail_l, rail_l]);
        }
        translate([L/2-6, rail_l/2, -1]) rtx3(ruthex_m3_depth+1);
        translate([L/2+6, -1, rail_l/2]) rotate([-90,0,0]) rtx3(ruthex_m3_depth+1);
    }
}
module edge_rail_x() edge_rail(rail_lx);
module edge_rail_y() edge_rail(rail_ly);

// barrette serre-cables : section 12 x 10, entre flancs (jeu clr), inserts
// M3 axiaux aux deux bouts, 1 fente collier au droit de chaque disque.
module cable_bar() {
    L = iw - 2*clr;
    difference() {
        cube([L, cbar_s[0], cbar_s[1]]);
        for (x=[-1, L-ruthex_m3_depth]) translate([x, cbar_s[0]/2, cbar_s[1]/2])
            rotate([0,90,0]) rtx3(ruthex_m3_depth+1);
        for (dx=drive_x) translate([dx+hdd_thick/2-sh_x0-cbar_tie[0]/2,
                                    (cbar_s[0]-cbar_tie[1])/2, -1])
            cube([cbar_tie[0], cbar_tie[1], cbar_s[1]+2]);
    }
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
module fan_gasket() {   // joint TPU 120 x 120 x 1.5 (fan_iso), cadre de 3 mm
    difference() {
        translate([-fan_side/2, -fan_side/2, 0]) linear_extrude(height=1.5)
            offset(r=3) offset(delta=-3) square([fan_side, fan_side]);
        translate([0,0,-1]) cylinder(h=4, d=fan_cut);
        for (dx=[-1,1], dz=[-1,1])
            translate([dx*fan_pitch/2, dz*fan_pitch/2, -1]) cylinder(h=4, d=fan_screw);
    }
}

/* ================= COMPOSANTS (solides, pour les tests) ================= */
module drives_s() for (x=drive_x)
    translate([x, stack_y0, stack_z0+0.05]) cube([hdd_thick, hdd_len, hdd_height]);
module psu_s() translate([psu_x0, psu_y0, psu_z0+0.05]) cube([psu_w, psu_d-0.3, psu_h]);
module fans_s() for (cx=fan_cx)
    translate([cx-fan_side/2, t+0.3+gasket_t, fan_cz-fan_side/2]) cube([fan_side, fan_depth, fan_side]);
module add2psu_s() translate([a2p_x, a2p_y, t+a2p_boss+0.05]) cube([a2p_l, a2p_w, 15]);
module components() { drives_s(); psu_s(); fans_s(); add2psu_s(); }

show_ghosts = true;
module ghosts() if (show_ghosts) %components();

/* ================= PLACEMENT ================= */
// e : amplitude d'eclatement (0 = assemble)
module panel_left(e=0)   translate([-e, t, t])     rotate([90,0,90]) sideL();
module panel_right(e=0)  translate([W-t+e, t, t])  rotate([90,0,90]) sideR();
module panel_bottom(e=0) translate([t, t, -e])     bottom();
module panel_top(e=0)    translate([t, t, H-t+e])  top();
module panel_front(e=0)  translate([t, t-e, t])    rotate([90,0,0]) front();
module panel_rear(e=0)   translate([t, D+e, t])    rotate([90,0,0]) rear();
module panels(e=0) {
    color("DimGray") { panel_left(e); panel_right(e); panel_bottom(e); panel_top(e); }
    color("SlateGray") { panel_front(e); panel_rear(e); }
}

module shelf_p(e=0) translate([sh_x0, sh_y0, sh_z0+e*0.4]) shelf();
module plate_p(e=0) translate([sh_x0, sh_y0, plate_z0+e*1.6]) cage_plate();
module struts_p() for (x=strut_x, y=strut_y)
    translate([x-strut_s/2, y-strut_s/2, t]) strut();
module posts_p() {
    translate([t, t, t])         corner_post();                       // AV-G
    translate([W-t, t, t])       mirror([1,0,0]) corner_post();       // AV-D
    translate([t, D-t, t])       mirror([0,1,0]) corner_post();       // AR-G
    translate([W-t, D-t, t])     rotate([0,0,180]) corner_post();     // AR-D
}
module rails_p() for (r=rails) let(u=rail_u(r), v=r[3], w=r[4], o=r[2])
    multmatrix([[u[0],v[0],w[0],o[0]], [u[1],v[1],w[1],o[1]],
                [u[2],v[2],w[2],o[2]], [0,0,0,1]]) edge_rail(r[5]);
module cbar_p(e=0) translate([t+clr, cbar_y-cbar_s[0]/2, cbar_z-cbar_s[1]/2+e]) cable_bar();
module feet_p(e=0) for (p=foot_xy) translate([p[0]-15, p[1]-15, -12-e*1.5]) box_foot();
module gaskets_p() if (fan_iso) for (cx=fan_cx)
    translate([cx, t, fan_cz]) rotate([-90,0,0]) fan_gasket();

module internals(e=0) {
    color("Orange") { shelf_p(e); plate_p(e); }
    color("Gray") struts_p();
    color("Goldenrod") { posts_p(); rails_p(); }
    color("Peru") cbar_p(e);
    color("Black") { feet_p(e); gaskets_p(); }
}

module place(e=0) { panels(e); internals(e); ghosts(); }
module assembly() place(0);
module exploded() place(60);
// coupe transversale a y = 110 (vue de l'avant) : canaux d'air entre les
// disques et le long des joues, cornieres, struts, PSU en arriere-plan
module cutaway(y=110) intersection() {
    union() { panels(); internals(); color("LightSteelBlue") components(); }
    translate([-20, y, -20]) cube([W+40, D, H+40]);
}

/* ================= RENDU ================= */
if (part=="assembly") assembly();
else if (part=="exploded") exploded();
else if (part=="cutaway") cutaway();
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
else if (part=="edge_rail_x") edge_rail_x();
else if (part=="edge_rail_y") edge_rail_y();
else if (part=="cable_bar") cable_bar();
else if (part=="fan_guard") fan_guard();
else if (part=="fan_gasket") fan_gasket();
else if (part=="atx_bridge") atx_bridge();
else if (part=="box_foot") box_foot();
