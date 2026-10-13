wall_mm=3;
l=160;
w=102;
h=65;

cube_side=60;

module cover_body(){
    cube([l+wall_mm*2,w+wall_mm,h+wall_mm], center=true);
}

module cover_internal(){
    union(){
        // internal space
        translate([0,-wall_mm/2,-wall_mm/2]) cube([l,w,h], center=true);
        
        // objective port
        translate([(l/2)-(cube_side/2)-5,-((w/2)-(cube_side/2)+wall_mm/2),20])
            cube([cube_side,cube_side,cube_side], center=true);
        
        // side port
        translate([-((l/2)-(cube_side/2)+wall_mm),-(wall_mm/2+11),-(wall_mm/2+11)])
            cube([cube_side,w,h], center=true);
    }
}

module cover(){
    difference(){
        cover_body();
        cover_internal();
    }
}

cover();