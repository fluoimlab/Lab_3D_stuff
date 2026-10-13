module cap(){
    union(){
    difference(){
        cylinder(d=25, h=5, center=true, $fn=200);
        translate([0,0,2]) cylinder(d=22, h=3, center=true, $fn=200);
    }
    cube([2,24,5], center=true);
    }
}

cap();