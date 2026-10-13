//Cube insert template

IM_offset = 0.05;

w_port = 6;
h_port = 3;

w_plate = 32; 
h_plate = 3;

d_hole = 20;


module sampleHolder(){
    difference(){
    union(){
        rotate([0, 0, 45/2]) cylinder(d = w_plate, h = h_plate, center=true, $fn=8);
        translate([18, 0, 0]) cube([10, 8.5, h_port], center=true);
        translate([26, 0, 0]) cube([10, w_port, h_port], center=true);
    }
    cylinder(d = d_hole, h = 20, center=true, $fn=100);
    }
}

sampleHolder();