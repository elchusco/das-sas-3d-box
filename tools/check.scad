/*
Tests CGAL du boitier (inclus APRES le modele par tools/check.sh) :
  include <scad/boitier_8_sas_vXY.scad>   (part="none")
  include <tools/check.scad>              (test="...")
Chaque test produit une geometrie qui doit etre VIDE, sauf les tests
"nonempty_*" (garde-fous : un module mal nomme donnerait un test vide).

Vis : [point d'interface, direction vers la cible, epaisseur traversee,
       diametre de la poche/pilote cible, profondeur de la poche, cible]
  - sonde ⌀1 : de l'exterieur de la piece traversee jusqu'au fond utile de
    la poche -> ne doit toucher AUCUNE matiere (trou + poche debouchent) ;
  - tube (⌀ poche+0.4 .. poche+3) sur la profondeur de la poche -> doit etre
    ENTIEREMENT dans la cible (la vis tombe dans de la matiere) ;
  - cible composant (disque, PSU, fan) : pointe 3..5 mm dans le composant.
*/
test = "";

X=[1,0,0]; Y=[0,1,0]; Z=[0,0,1];

function screws() = concat(
  // panneaux -> poteaux (inserts M4)
  [for (x=post_cx, z=post_zy) [[x, t, z+t],   Y, t, ruthex_m4, ruthex_m4_depth, "posts"]],
  [for (x=post_cx, z=post_zy) [[x, D-t, z+t], -Y, t, ruthex_m4, ruthex_m4_depth, "posts"]],
  [for (y=post_cy, z=post_zx) [[t, y, z+t],   X, t, ruthex_m4, ruthex_m4_depth, "posts"]],
  [for (y=post_cy, z=post_zx) [[W-t, y, z+t], -X, t, ruthex_m4, ruthex_m4_depth, "posts"]],
  [for (x=post_cx, y=post_cy) [[x, y, t],     Z, t, ruthex_m4, ruthex_m4_depth, "posts"]],
  [for (x=post_cx, y=post_cy) [[x, y, H-t],  -Z, t, ruthex_m4, ruthex_m4_depth, "posts"]],
  // fond -> struts (pilote M4), etagere -> struts (insert M3)
  [for (x=strut_x, y=strut_y) [[x, y, t],     Z, t,  m4_pilot,  12, "struts"]],
  [for (x=strut_x, y=strut_y) [[x, y, sh_z0], -Z, ts+comb_h, ruthex_m3, ruthex_m3_depth, "struts"]],
  // plaque de cage -> piliers des joues
  [for (x=cheek_ix, y=cheek_iy) [[sh_x0+x, sh_y0+y, plate_z0], -Z, ts, ruthex_m3, ruthex_m3_depth, "shelf"]],
  // Add2PSU -> bossages du fond
  [for (p=a2p_holes()) [[p[0], p[1], t+a2p_boss], -Z, 1.6, ruthex_m3, ruthex_m3_depth, "bottom"]],
  // fond -> pieds (pilote M4, vis par l'interieur)
  [for (p=foot_xy) [[p[0], p[1], 0], -Z, t, m4_pilot, 10, "feet"]],
  // panneaux -> cornieres (inserts M3)
  [for (r=rails) [rail_pA(r), r[4], t, ruthex_m3, ruthex_m3_depth, "rails"]],
  [for (r=rails) [rail_pB(r), r[3], t, ruthex_m3, ruthex_m3_depth, "rails"]],
  // flancs -> barrette (inserts M3 axiaux)
  [[[t, cbar_y, cbar_z],    X, t, ruthex_m3, ruthex_m3_depth, "cbar"],
   [[W-t, cbar_y, cbar_z], -X, t, ruthex_m3, ruthex_m3_depth, "cbar"]],
  // composants : disques (plaque), PSU (panneau arriere), fans (face avant)
  [for (sx=screw_x, sy=screw_y) [[sx, sy, plate_z0], -Z, ts, 0, 0, "drives"]],
  [for (h=psu_holes) [[psu_x0+psu_w-h[0], D-t, psu_z0+h[1]], -Y, t, 0, 0, "psu"]],
  [for (cx=fan_cx, dx=[-1,1], dz=[-1,1])
      [[cx+dx*fan_pitch/2, t, fan_cz+dz*fan_pitch/2], Y, t, 0, 0, "fans"]]
);
function screws_of(g) = [for (s=screws()) if (s[5]==g) s];
function is_comp(g) = g=="drives" || g=="psu" || g=="fans";

// oriente l'axe +Z local sur n (vecteur unitaire d'axe)
module along(n) {
    if (n==Z) children();
    else if (n==-Z) rotate([180,0,0]) children();
    else if (n==X)  rotate([0,90,0]) children();
    else if (n==-X) rotate([0,-90,0]) children();
    else if (n==Y)  rotate([-90,0,0]) children();
    else if (n==-Y) rotate([90,0,0]) children();
}
module probe(s) translate(s[0]) along(s[1]) {
    len = is_comp(s[5]) ? 0.2 : min(s[4]-1, 8);
    translate([0,0,-(s[2]+1)]) cylinder(d=1, h=s[2]+1+len, $fn=8);
}
module tube(s) translate(s[0]) along(s[1]) translate([0,0,1]) difference() {
    cylinder(d=s[3]+3, h=s[4]-2, $fn=24);
    translate([0,0,-1]) cylinder(d=s[3]+0.4, h=s[4], $fn=24);
}
module tip(s) translate(s[0]) along(s[1]) translate([0,0,3]) cylinder(d=1, h=2, $fn=8);

module target(g) {
    if (g=="posts") posts_p();
    else if (g=="struts") struts_p();
    else if (g=="shelf") shelf_p();
    else if (g=="bottom") panel_bottom();
    else if (g=="feet") feet_p();
    else if (g=="rails") rails_p();
    else if (g=="cbar") cbar_p();
    else if (g=="drives") drives_s();
    else if (g=="psu") psu_s();
    else if (g=="fans") fans_s();
}

// groupes de la structure interne (tests 2 a 2)
igroups = ["posts","struts","shelf","plate","rails","cbar","feet","gaskets"];
module igroup(g) {
    if (g=="plate") plate_p();
    else if (g=="gaskets") gaskets_p();
    else target(g);
}
module solids() { panels(); internals(); }
module panel(p) {
    if (p=="front") panel_front();
    else if (p=="rear") panel_rear();
    else if (p=="left") panel_left();
    else if (p=="right") panel_right();
    else if (p=="bottom") panel_bottom();
    else if (p=="top") panel_top();
}

/* ---- dispatch ----
   panel_<p>        : panneau p ∩ (structure interne + composants)
   ipair_<a>_<b>    : groupe interne a ∩ groupe b
   icomp_<g>        : groupe interne g ∩ composants
   comp_pairs       : composants 2 a 2 (Add2PSU/PSU, fans/disques, disques/PSU)
   probe_<g>        : sondes des vis du groupe g ∩ toute la matiere
   seat_<g>         : tubes (ou pointes) des vis de g, hors de la cible
   nonempty_<g>     : garde-fou, doit etre NON vide                         */
function after(s, p) = len(s) > len(p) && [for (i=[0:len(p)-1]) s[i]]==[for (c=p) c]
    ? [for (i=[len(p):len(s)-1]) s[i]] : undef;
function str_of(v) = len(v)==0 ? "" : str(v[0], str_of([for (i=[1:1:len(v)-1]) v[i]]));
function split2(s) = let(i=[for (k=[0:len(s)-1]) if (s[k]=="_") k][0])
    [str_of([for (k=[0:i-1]) s[k]]), str_of([for (k=[i+1:len(s)-1]) s[k]])];

module run(tn) {
    if (after(tn, "panel_") != undef)
        intersection() { panel(str_of(after(tn,"panel_"))); union() { internals(); components(); } }
    else if (after(tn, "ipair_") != undef) {
        ab = split2(str_of(after(tn,"ipair_")));
        intersection() { igroup(ab[0]); igroup(ab[1]); }
    }
    else if (after(tn, "icomp_") != undef)
        intersection() { igroup(str_of(after(tn,"icomp_"))); components(); }
    else if (tn=="comp_pairs") {
        intersection() { add2psu_s(); psu_s(); }
        intersection() { fans_s(); drives_s(); }
        intersection() { drives_s(); psu_s(); }
    }
    else if (after(tn, "probe_") != undef) {
        g = str_of(after(tn,"probe_"));
        echo(str("VIS ", g, " : ", len(screws_of(g))));
        intersection() { solids(); for (s=screws_of(g)) probe(s); }
    }
    else if (after(tn, "seat_") != undef) {
        g = str_of(after(tn,"seat_"));
        difference() {
            for (s=screws_of(g)) if (is_comp(g)) tip(s); else tube(s);
            target(g);
        }
    }
    else if (after(tn, "nonempty_") != undef) {
        g = str_of(after(tn,"nonempty_"));
        if (g=="panels") panels(); else if (g=="components") components(); else igroup(g);
    }
    else echo(str("TEST INCONNU : ", tn));
}

if (test != "") run(test);
