//Cube insert template

/* [Hiden] */
a = 49.8;
b = 33.6;
c = 6.28;
d = 53.8;
h = 8.5; //holder height

h_slot = 5;
w_slot = 30;

hole_d = 30;

IM_offset = 0.05;

module CubeInsert () {
    translate([0, 0, h/2])
    difference(){
        union() {   //basic insert design
            cube([a,b+2*IM_offset,h], center=true);
            cube([b+2*IM_offset,a,h], center=true);
            rotate(a=[0,0,45]){
                cube([c,d+2*IM_offset,h], center=true);
            }
            rotate(a=[0,0,-45]){
                cube([c,d+2*IM_offset,h], center=true);
            }
        }
    }
}

module stage_insert(){
    difference(){
        union(){
            CubeInsert();
            translate([0,8,h_slot/2]) cube([w_slot-IM_offset,a,h_slot-IM_offset], center=true);
        }
        cylinder(d = hole_d, h = 20, center=true, $fn=100);
    }
}

stage_insert();