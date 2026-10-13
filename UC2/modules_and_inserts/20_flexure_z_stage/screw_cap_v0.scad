module cap(){
    difference(){
        cylinder(d=9, h=6, center=true, $fn=9);
        cylinder(d=3, h=40, center=true, $fn=100);
        translate([0,0,-2]) cylinder(d=5.75, h=6, center=true, $fn=100);
    }
}

cap();