$fs = 0.05;

//====== From Req
output_d = 3;//SOL75
output_travel = 2.5;//SOL75 // Maximum expected translation
gain = 5;//SOL75

//====== Design DOF
// Input Lever geometry
l0 = 7;//SOL75 // From pivot point (mid-hinge) to rod attachement
lever_w = 5;//SOL75
t_center = 3.5;//SOL75 // Thickness of the output shuttle

// Main support elements
l2 = 14;//SOL75
w2 = 3;//SOL75

// Pushing rod (connection)
rod_l = 20;//SOL75
rod_w = 4;//SOL75
rod_clearance = 1.5;//SOL75 // room around the rod (sum of both sides)

hinge_l = 5;//SOL75 //Standard hinges
hinge_t = 0.65;//SOL75 // All hinges
hinge_r = 1;//SOL75
lever_hinge_l = 5;//SOL75  // Lever only

h0 = 7;// height of the moving elements
separation_h = 1;//SOL75 // at least 0.6 for the bridge & rod to separate easily, higer = better
support_h = 0.8;//SOL75  // From end of frame to ground

screw_d = 3;//SOL75//Both attachment holes and gate

screw_head_l = 3;//SOL75 //All the rest derives from the screw d
screw_head_d = 5.5;//SOL75
nut_h = 2.15;//SOL75
nut_d_ac = 6.01;//SOL75 // nut external diameter, across corner

//====   Derived + Static parameters
l_gate = gain*l0; // Distance from pivot point to actuation point
center_body_d = output_d + 2*t_center;


input_travel= output_travel*gain;

l1 = (l_gate - l0) + lever_w; // from the x axis to the end of the lever
tip_travel = output_travel*(l0 + l1)/l0; // Input movement of the tip

frame_h = h0 + separation_h; // height of the full frame ( supports are still not considered )

// Static Parameters
screw_gate_l = 18.2;//SOL75//Y size of the screw holder

elastic_d=1.8;

frame_t = 5; //Lateral (xy plane) thickness of the frame

groove_d = 1.5;

min_tol = 0.4;//SOL75
p0 = 0.01;


// connector slot size
slot_w = 30;
slot_h = 5;



all_togeher(); // the pushing rod

module all_togeher(){
   color("LightSteelBlue"){
        output_shuttle();
        translate([(center_body_d + w2)/2, t_center + (l2 + hinge_l)/2 ,0]) slender_0();
        translate([-(center_body_d + w2)/2, t_center + (l2 + hinge_l)/2 ,0]) slender_0();

        mirror([0,1,0]){
            translate([(center_body_d/2 + w2/2), t_center + (l2 + hinge_l)/2 ,0]) slender_0();
            translate([-(center_body_d/2 + w2/2), t_center + (l2 + hinge_l)/2 ,0]) slender_0();
        }

        translate([center_body_d/2 + w2 + rod_l/2 + hinge_l/2, 0, 0]) rod();
        translate([center_body_d/2 + w2 + rod_l + hinge_l/2 , 0, 0]) lever();

        translate([0,0,h0/2-frame_h/2])frame_body();
    }

}


//!output_shuttle();
module output_shuttle(){
    difference(){
        union(){
            //cube([main_d,main_d,h0],center = true);
            cylinder(d = center_body_d, h= h0,center = true, $fn = 6);
            cube([center_body_d + 2*w2, 2*t_center, h0],center = true);
        }
        // cylinder(d = output_d , h = 1.2*h0, center = true );
        cube([output_d, output_d*2, 20],center = true);   
    }
}

//!slender_0();
module slender_0(){
    core_l = l2 - hinge_l;
    cube([w2,core_l,h0],center = true);
    translate([0,(core_l + hinge_l)/2 ,0]) hinge();
    translate([0,-(core_l + hinge_l)/2,0]) hinge();

    //%translate([10,0,0]) cube([w2,l2,h0],center = true);
}

//!rod();
module rod(){
    l_core = rod_l - hinge_l;
    cube([l_core,rod_w,h0],center = true);
    translate([l_core/2 + hinge_l/2,0 ,0]) rotate([0,0,90]) hinge();
    translate([-(l_core/2 + hinge_l/2),0 ,0]) rotate([0,0,90]) hinge();

   // translate([0,5,0]) cube([rod_l + hinge_l,rod_w,h0],center = true);
}


//!leverBulk();
module leverBulk(h = h0){
  //Screw Actuated
  linear_extrude(height= h,center = true, convexity = 2){
                polygon([ [lever_w/2 + hinge_l/2,l0 - lever_hinge_l/2],
                          [-hinge_r - hinge_t/2,l0 - lever_hinge_l/2],
                          [-hinge_r - hinge_t/2,0],
                          [-lever_w/2,-rod_w/2],
                          [-lever_w/2,-l1+1],// bottom left-corner
                          [0,-l1],// bottom tip
                          [lever_w/2,-l1+1],
                          [lever_w/2,-rod_w/2-hinge_l/2],
                          [lever_w/2+hinge_l/2,-rod_w/2]]);
    }
}

//!lever();
module lever(){
    // Alligned with l0 in the middle
     theta = atan( input_travel/l_gate );
     groove_upp_end_pos = l0 - sqrt(pow(l_gate,2) - pow(input_travel,2) );
     groove_lwr_end_pos = l0 - l_gate;
     groove_r = 0.5;
     difference(){
        leverBulk(h = h0);
        //Rod hinge hole
        hull(){
            translate([-lever_w/2,0,0])cylinder(d=rod_w + rod_clearance,h =1.2*h0,center = true);
            translate([hinge_l/2-rod_w/2,0,0])cylinder(d=rod_w,h =1.2*h0,center = true);
        }

        //screw guide hole
       hull(){
            translate([+groove_r,groove_lwr_end_pos -screw_d/2,0]) cylinder(r =groove_r, h = 1.2*h0, center = true);
            translate([groove_r,groove_upp_end_pos + screw_d/2,0]) cylinder(r =groove_r, h = 1.2*h0, center = true);

            translate([0,groove_lwr_end_pos -screw_d/2,0])rotate([0,0,-theta])translate([+lever_w,0,0]) cylinder(r =groove_r, h = 1.2*h0, center = true);
            translate([0,+groove_upp_end_pos + screw_d/2,0])rotate([0,0,+theta])translate([+lever_w,0,0]) cylinder(r =groove_r, h = 1.2*h0, center = true);
        }
        // Add grooves for the elastic
        translate([-lever_w/2, l0 - l_gate + (screw_head_d +  elastic_d),0 ]) cylinder(d = elastic_d,h = 1.2*h0, center =true, $fn = 4);
        translate([-lever_w/2, l0 - (l_gate +screw_d/2),0 ]) cylinder(d = elastic_d,h = 1.2*h0, center =true, $fn = 4);

    }
    translate([ 0,l0,0]) hinge(l = lever_hinge_l);
}




//%lever_negative();
module lever_negative(){
    // Space for the lever, same position
    tot_h = frame_h + support_h;
    max_theta = atan( (lever_w/2 + tip_travel)/(l0+l1) );
   translate([0,l0,0]){
       hull(){
           cylinder(d=lever_hinge_l,h=2*h0,center = true);
           rotate([0,0,-max_theta]) translate([0,-l0,0]) leverBulk(h= 2*tot_h);
           rotate([0,0,+max_theta]) translate([0,-l0,0]) leverBulk(h= 2*tot_h);
        }
        rotate([0,0,180])arc_cylinder(r = l0+l1 +0.5,h =2*h0+p0,deg = max_theta*2);
   }

   module arc_cylinder(r,h,deg){
       intersection(){
           cylinder(r =r, h=h, center = true);
           linear_extrude(height= 1.2*h,center = true, convexity = 2){
                polygon([ [0,0],
                          [1.5*r*sin(deg/2),1.5*r*cos(deg/2)],
                          [1.5*r*sin(-deg/2),1.5*r*cos(-deg/2)]]);
           }
       }
   }
}

//!screw_gate();
module screw_gate(){
   //Where you put the screw + anchor for elastic bands
   //The screw will always have the axys on the xy plane; the top surface will be at top_h from x-y plane
    added_h = min(support_h,1);
    tot_h = frame_h + added_h - p0;
    top_h = frame_h/2;
    w_max= nut_h + frame_t;
    length = screw_gate_l;

    module bulk(){
    //Extruded from the front, with the bulge for the screw in the middle
        step = 2*(tot_h - 2*top_h)/2;
        front_profile=[[-tot_h/2,-length/2],
                       [ tot_h/2 - step,-length/2],
                       [ tot_h/2 - step, -screw_head_d/2],
                       [ tot_h/2 , -screw_head_d/2 + step ],
                       [ tot_h/2 , +screw_head_d/2 - step ],
                       [ tot_h/2 - step, screw_head_d/2],
                       [ tot_h/2 - step, length/2],
                       [ -tot_h/2,length/2],
            ];
        depth = w_max;
        rotate([0,90,0])linear_extrude(depth, center = true, convexity = 3)polygon(front_profile);
    }

    module bolt_insertion_hole(){
      // The bolt should be inserted from below
      rotate([0,-90,0]) linear_extrude(nut_h + min_tol,center = true, convexity =3)
      offset(min_tol/2) // make it a bit larger to ease insertion
      hull(){
         circle(d = nut_d_ac,$fn=6);
         translate([-3*h0,0,0])circle(d = nut_d_ac,$fn=6);
      }
    }

    module screw_body_hole(){
      rotate([0,-90,0])cylinder(d = screw_d + min_tol, h = 2*w_max,center = true );
      translate([0,0,-(screw_d + min_tol)*cos(45)/2-p0])rotate([0,-90,0])cylinder(d = (screw_d + min_tol)*cos(45), h = 2*w_max,center = true,$fn = 4);
    }

    module hook_rubber_band(){
        difference(){
            translate([screw_head_l/2,0,0]) cube([screw_head_l,screw_head_d,top_h*2], center = true);
           translate([elastic_d/2,-p0-screw_head_d/2,0])cylinder(d = elastic_d, h = 2.2*top_h, center = true, $fn=4);
           translate([+elastic_d/2-p0,+screw_head_d/2,0])cylinder(d = elastic_d, h = 2.2*top_h, center = true, $fn=4);
        }
    }

   difference(){
      translate([0,0,-tot_h/2 + top_h ]) bulk();
      screw_body_hole();
      bolt_insertion_hole();
    }
    translate([w_max/2,+length/2 -screw_head_d/2,0])hook_rubber_band();
    translate([w_max/2,-length/2 + screw_head_d/2 ,0])hook_rubber_band();
}

//%screw_gate_negative();
module screw_gate_negative(){
   tot_h = frame_h + support_h - p0;
   w_max= nut_h + frame_t;

   //Space for the screw
   rotate([0,-90,0])cylinder(d = frame_h*1.1 + min_tol-p0, h = 2*(input_travel + w_max),center = true );

    //Space for the nut
   nut_d_a_flat = nut_d_ac/2*tan(60);
   translate([0,0,0])cube([ 2*nut_h, 2*nut_d_a_flat,3*h0 ],center = true);

   //Space for the elastic band
   translate([screw_head_l +w_max/2 - p0 , 0,0] ) cube([ 2*screw_head_l,screw_gate_l + 2*elastic_d,2*tot_h ],center = true);
}

//!frame_body();
module frame_body(){
    //Moving to point based design:
    slender_0_x = -(center_body_d +  w2)/2;
    slender_1_x = +(center_body_d +  w2)/2;
    slender_y = t_center + l2 + hinge_l;// top of the slender element

    rod_body_x = center_body_d/2 + w2 + hinge_l;  // where the rod starts

    lever_axis_x = center_body_d/2 + w2 + rod_l + hinge_l/2;

    left_corner_x = slender_0_x - w2/2 - 1.5*output_travel - frame_t - (slot_h + 2.5);
    right_corner_x = lever_axis_x + lever_w/2 + tip_travel + frame_t + nut_h + lever_w/2;


    span_y = (slender_y< l1)? 2*l1: 2*slender_y;
    tot_y = span_y + 2*frame_t + 10;

    module outer_perimeter_2D(){
       //From top corner left corner, counter clock wise
      polygon([ [left_corner_x, 49/2],
                [left_corner_x, -49/2],
                [left_corner_x+50, -tot_y/2],
                [right_corner_x ,-tot_y/2],
                [right_corner_x ,-tot_y/2+30],
                [right_corner_x-25 ,49/2]]);
    }

     module center_space_2D(){
          //From top left corner counter clock wise
          corner_l = hinge_l/2;
          polygon([ [slender_0_x - w2/2 - 1.5*output_travel + corner_l,  slender_y ],
                    [slender_0_x - w2/2 - 1.5*output_travel,  slender_y - corner_l],
                    [slender_0_x - w2/2 - 1.5*output_travel, -slender_y + corner_l],
                    [slender_0_x - w2/2 - 1.5*output_travel + corner_l, -slender_y ],
                    [rod_body_x - corner_l, -slender_y],
                    [rod_body_x , -slender_y + corner_l],
                    [rod_body_x,slender_y  - corner_l],
                    [rod_body_x - corner_l,slender_y]]);
     }

    //Assemble the 2D frame options
    module frame_2D(){
        //Plain frame, all filled
         difference(){
                union(){
                    outer_perimeter_2D();
                    }
                  projection(cut=false) translate([center_body_d/2 + w2 + rod_l/2 + hinge_l/2,0,0])cube([rod_l,rod_w + rod_clearance,frame_h + p0],center = true);
                  translate([right_corner_x - (nut_h + frame_t)/2, l0 - l_gate,0 ]) projection(cut=false)  screw_gate_negative();
            }
    }

    // Assemble it in 3D
    module support_bridge(){
        //Connects the two sides across the bridge to make the frame stiffer
     // from top left corner, counter clock wise
       added_h = min(support_h,1);

       translate([0,0,-added_h])linear_extrude(height= added_h,center = false, convexity = 2){
            polygon([ [0,rod_w/2 + rod_clearance/2 + 2],
                      [0,-(rod_w/2 + rod_clearance/2 + 2)],
                      [rod_l - hinge_l,-(rod_w/2 + rod_clearance/2 + 2)],
                      [rod_l - hinge_l,+(rod_w/2 + rod_clearance/2 + 2)]
                      ]);
        }
       //45 deg chamfer
      translate([0,rod_w/2 + rod_clearance/2 + 2,0]) rotate([0,90,0]) cylinder(r=added_h,h = rod_l - hinge_l,  center =false, $fn = 4);
      translate([0,-(rod_w/2 + rod_clearance/2 + 2),0]) rotate([0,90,0]) cylinder(r=added_h,h = rod_l - hinge_l,  center =false, $fn = 4);
    }


    difference(){
        union(){
            linear_extrude(frame_h,center = true,convexity = 4) frame_2D();

            //Add bridge connection
            translate([rod_body_x ,0,-frame_h/2+p0]) support_bridge();
        }
        translate([left_corner_x + slot_h + 1.25, 0, 0]) cube([slot_h+p0, slot_w+p0, 20],center = true);
        linear_extrude(height= frame_h + p0,center = true, convexity = 2) center_space_2D();
        translate([lever_axis_x, 0, 0]) lever_negative();
    }
    translate([right_corner_x - (nut_h + frame_t)/2 +p0, l0 - l_gate,-p0 ]) screw_gate();
}

module hinge(t = hinge_t, r = hinge_r, l = hinge_l, h = h0){
    // A slender body with rounded connections;
    d1 = 2*r;
    offset_y = (l - d1)/2;
    offset_x = (t + d1)/2;

    difference(){
        cube(size=[t+2*r,l + 2*p0,h],center = true);

        hull(){
            translate([-offset_x,+offset_y,0]) cylinder(d=d1, h= 1.2*h,center = true);
            translate([-offset_x,-offset_y,0]) cylinder(d=d1, h= 1.2*h,center = true);
         }

         hull(){
            translate([+offset_x,+offset_y,0]) cylinder(d=d1, h= 1.2*h,center = true);
            translate([+offset_x,-offset_y,0]) cylinder(d=d1, h= 1.2*h,center = true);
         }
    }
}