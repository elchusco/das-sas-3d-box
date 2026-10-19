/*
Boitier 8 disques 3.5 pouces SATA/SAS + alimentation ATX
Conception parametrique OpenSCAD, prototype imprimable en panneaux.
Unites : mm

Utilisation : changer `part`, F6, puis Fichier > Exporter > STL.
Valeurs : assembly, left, right, bottom, top, front, rear, drive_cage, drive_rail, fan_guard
*/

$fn = 48;
part = "assembly";

// Encombrement general
W = 300;
D = 440;
H = 390;
t = 4;
edge = 14;
clearance = 0.6;

// Disques 3.5 pouces : enveloppe volontairement majorée
hdd_w = 101.6;
hdd_d = 147;
hdd_h = 26.1;
hdd_gap = 7.0;
hdd_pitch = hdd_h + hdd_gap;
hdd_x = 26;
hdd_y = 22;
hdd_z = 35;

// Ventilation : deux ventilateurs 120 mm derrière les disques
fan_size = 120;
fan_hole = 4.5;
fan_pitch = 105;
fan_x = 178;
fan_y = 190;
fan_z1 = 88;
fan_z2 = 238;

// Alimentation ATX : face 150 x 86, profondeur réservée 180
psu_w = 150;
psu_h = 86;
psu_d = 180;
psu_x = W - t - psu_w - 18;
psu_z = 24;

module rounded_panel(size=[100,100,4], r=3) {
    linear_extrude(height=size[2])
        offset(r=r) offset(delta=-r) square([size[0],size[1]]);
}

module vent_slots_2d(w,h,slot=5,pitch=10) {
    for (x=[0:pitch:w-slot])
        translate([x,0]) square([slot,h]);
}

module screw_hole(h=t+2,d=4.4) { cylinder(h=h,d=d); }

module side_panel(mirror_side=false) {
    difference() {
        cube([D,H,t]);
        // Ouies longitudinales face aux disques et à l'alimentation
        translate([25,45,-1]) linear_extrude(t+2) vent_slots_2d(125,285,5,11);
        translate([250,35,-1]) linear_extrude(t+2) vent_slots_2d(130,110,5,11);
        // Fixations M4 sur le pourtour
        for (p=[[16,16],[D-16,16],[16,H-16],[D-16,H-16],
                [D/2,16],[D/2,H-16]])
            translate([p[0],p[1],-1]) screw_hole();
    }
}

module base_panel() {
    difference() {
        cube([W,D,t]);
        // Entrées d'air sous la zone des disques
        translate([22,22,-1]) linear_extrude(t+2) vent_slots_2d(118,145,5,11);
        for (p=[[16,16],[W-16,16],[16,D-16],[W-16,D-16],
                [W/2,16],[W/2,D-16]])
            translate([p[0],p[1],-1]) screw_hole();
    }
    // Rails de rigidification et plots de fixation
    translate([8,8,t]) cube([edge,D-16,edge]);
    translate([W-8-edge,8,t]) cube([edge,D-16,edge]);
}

module top_panel() {
    difference() {
        cube([W,D,t]);
        translate([22,22,-1]) linear_extrude(t+2) vent_slots_2d(118,145,5,11);
        for (p=[[16,16],[W-16,16],[16,D-16],[W-16,D-16],
                [W/2,16],[W/2,D-16]])
            translate([p[0],p[1],-1]) screw_hole();
    }
}

module front_panel() {
    difference() {
        cube([W,H,t]);
        // Grande admission devant les 8 disques
        translate([hdd_x-8,hdd_z-10,-1]) cube([hdd_w+16,8*hdd_pitch+8,t+2]);
        // Grille de protection imprimée séparément possible
        translate([166,45,-1]) linear_extrude(t+2) vent_slots_2d(105,280,5,11);
        for (p=[[16,16],[W-16,16],[16,H-16],[W-16,H-16]])
            translate([p[0],p[1],-1]) screw_hole();
    }
}

module fan_cutout(cx,cz) {
    translate([cx,cz,-1]) cylinder(h=t+2,d=114);
    for(dx=[-fan_pitch/2,fan_pitch/2], dz=[-fan_pitch/2,fan_pitch/2])
        translate([cx+dx,cz+dz,-1]) cylinder(h=t+2,d=fan_hole);
}

module rear_panel() {
    difference() {
        cube([W,H,t]);
        // Découpe alimentation ATX, avec jeu de 1 mm
        translate([psu_x-0.5,psu_z-0.5,-1]) cube([psu_w+1,psu_h+1,t+2]);
        // Deux sorties 120 mm
        fan_cutout(fan_x,fan_z1);
        fan_cutout(fan_x,fan_z2);
        // Passage contrôleur/câbles SAS
        translate([22,220,-1]) cube([92,36,t+2]);
        for (p=[[16,16],[W-16,16],[16,H-16],[W-16,H-16]])
            translate([p[0],p[1],-1]) screw_hole();
    }
}

module drive_rail(single=true) {
    // Rail latéral supportant un disque; vis HDD non imposées pour compatibilité SAS/SATA.
    difference() {
        cube([hdd_d+12, 14, 5]);
        for(x=[12, hdd_d/2, hdd_d])
            translate([x,7,-1]) cylinder(h=7,d=4.2);
    }
    translate([0,0,5]) cube([hdd_d+12,3,9]);
}

module drive_cage() {
    // Deux montants reliés; les disques sont posés sur des paires de rails.
    cube([6,hdd_d+18,8*hdd_pitch+12]);
    translate([hdd_w+10,0,0]) cube([6,hdd_d+18,8*hdd_pitch+12]);
    for(i=[0:7]) {
        z=6+i*hdd_pitch;
        translate([3,3,z]) rotate([0,0,90]) drive_rail();
        translate([hdd_w+13,3,z]) rotate([0,0,90]) mirror([0,1,0]) drive_rail();
    }
    // Traverses arrière
    translate([0,hdd_d+12,0]) cube([hdd_w+16,6,10]);
    translate([0,hdd_d+12,8*hdd_pitch+2]) cube([hdd_w+16,6,10]);
}

module fan_guard() {
    difference() {
        cylinder(h=3,d=124);
        cylinder(h=4,d=116);
    }
    for(a=[0:30:150]) rotate([0,0,a]) translate([-60,-1.5,0]) cube([120,3,3]);
    for(dx=[-fan_pitch/2,fan_pitch/2],dy=[-fan_pitch/2,fan_pitch/2])
        translate([dx,dy,0]) difference(){ cylinder(h=3,d=10); cylinder(h=4,d=fan_hole); }
}

module assembly() {
    color("DimGray") translate([0,0,0]) base_panel();
    color("DimGray") translate([0,0,H]) top_panel();
    color("Gray") translate([0,0,0]) rotate([90,0,90]) side_panel();
    color("Gray") translate([W-t,0,0]) rotate([90,0,90]) side_panel();
    color("SlateGray") translate([0,0,0]) rotate([90,0,0]) front_panel();
    color("SlateGray") translate([0,D-t,0]) rotate([90,0,0]) rear_panel();
    color("Orange") translate([hdd_x,hdd_y,hdd_z]) drive_cage();
    // Volumes témoin non exportables séparément : PSU et HDD
    %translate([psu_x,D-psu_d-t,psu_z]) cube([psu_w,psu_d,psu_h]);
    for(i=[0:7])
        %translate([hdd_x+8,hdd_y+8,hdd_z+8+i*hdd_pitch]) cube([hdd_w,hdd_d,hdd_h]);
}

if(part=="assembly") assembly();
else if(part=="left") side_panel();
else if(part=="right") side_panel(true);
else if(part=="bottom") base_panel();
else if(part=="top") top_panel();
else if(part=="front") front_panel();
else if(part=="rear") rear_panel();
else if(part=="drive_cage") drive_cage();
else if(part=="drive_rail") drive_rail();
else if(part=="fan_guard") fan_guard();
