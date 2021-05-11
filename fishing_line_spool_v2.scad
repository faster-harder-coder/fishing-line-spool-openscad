// Main parameters
// Total length of spool from end to end
totalLength = 140;
// Width of spool
totalWidth = 25;
// Thickness of walls
wallThickness = 2;
// The height of the walls
wallHeight = 17 ;

// How round the borders are
wallRounding = 2;

bigPinWidth = 8;
bigPinHeight = 10;
smallPinWidth = 3;
smallPinHeight = 8;

// Pin placement
pin1Distance = 10;
pin2Distance = 40;

// Make hole slightly bigger to compensate for 3d printer 
holeCompensationWidth = 0.5;
holeCompensationLength = 1;

lineHolderHoleThickness = bigPinWidth + 1;
lineHolderCircleThickness = bigPinWidth + 6;
lineHolderHandleThickness = 3;
lineHolderHandleWidth = bigPinHeight+smallPinHeight-5;
lineHolderHandleLength = 20;

hookHolderLength = 9;
hookHolderWidth = 1;


// Smoothness (of circles). 
// Can be put lower(20) when testing for better performance, 
// and higher(40) for final export
$fn = 40;


wholeSpool();
lineHolder();



module bottomPlate () {
    color("blue")
    translate(v = [0, 0, wallThickness/2])
    // The roundedcube() screws up the wallthickness and
    // everything else becomes wrong...
    /*
    roundedcube(
        [
        totalLength,
        totalWidth,
        wallThickness
        ]
        ,
        true,
        wallRounding,
        "z"
    );
    */
    cube([totalLength, totalWidth, wallThickness], true);
}


module pin (hookHolder) {
    bigLift = (wallThickness/2)+(bigPinHeight/2);
    echo(bigLift=bigLift);
    color("red")

    translate(v = [0, 0, bigLift])
        cylinder(h=bigPinHeight, d=bigPinWidth, center=true);

    color("green")
    translate(v = [0, 0, bigLift+bigPinHeight-1])
        cylinder(h=smallPinHeight, d=smallPinWidth, center=true);

    if (hookHolder) {
        color("purple")
        translate(
            v = [
                    0,
                    0,
                    (wallThickness/2)+((bigPinHeight)/2)
                ]
            )
            cube(
                [
                    bigPinWidth+hookHolderLength,
                    hookHolderWidth,
                    bigPinHeight
                ],
                true
            );
    }
}

module hole (hookHolder) {
    color("orange")
    difference() {
    PinForHole(hookHolder);


    color("green")
    translate(
        v = [
            0,
            0,
            bigPinHeight+bigPinHeight-(smallPinHeight/2)+holeCompensationLength
            ]
        )
        cylinder(
        h=smallPinHeight+holeCompensationLength,
        d=smallPinWidth+holeCompensationWidth,
        center=true
        );
    }
}

module PinForHole(hookHolder) {
        translate(
            v = [
                    0,
                    0,
                    (((bigPinHeight+bigPinHeight)/2)+(wallThickness/2))
            ]
        )
        cylinder(h=bigPinHeight+bigPinHeight, d=bigPinWidth, center=true);
    if (hookHolder) {
        color("purple")
        translate(
        v = [
                0,
                0,
                ((wallThickness/2)+(bigPinHeight+bigPinHeight)/2)
            ]
        )
        cube(
            [
                bigPinWidth+hookHolderLength,
                hookHolderWidth,
                bigPinHeight+bigPinHeight
            ],
            true
        );
    }
}


module wholeSpool() {
    bottomPlate ();
    // 1: Create pin
    translate(v = [(totalLength/2)-pin1Distance, 0, 0]) pin(false);

    // 2: Create hole
    translate(v = [(totalLength/2)-pin2Distance, 0, 0]) hole(true);

    // 3: Create pin
    translate(v = [-(totalLength/2)+pin2Distance, 0, 0]) pin(true);
    //translate(v = [-(totalLength/2)+26, 0, 0]) hole();

    // 4: Create hole
    translate(v = [-(totalLength/2)+pin1Distance, 0, 0]) hole(false);
}


module lineHolder () {
    color("grey")
    difference () {
        lineHolderParts();
        translate(v = [(totalLength/2)+36.5, 0, 0])
       cylinder(h=bigPinHeight+smallPinHeight+20, d=bigPinWidth, center=true);
    }

}

module lineHolderParts () {
    color("grey")
       translate(v = [(totalLength/2)+ 40, 0, lineHolderHandleWidth/2])
         cylinder(h=lineHolderHandleWidth, d=lineHolderCircleThickness, center=true);
       translate(v = [(totalLength/2)+ 53, 0, lineHolderHandleWidth/2])
         roundedcube([lineHolderHandleLength, lineHolderHandleThickness, lineHolderHandleWidth], true, wallRounding, "z");
    }





// More information: https://danielupshaw.com/openscad-rounded-corners/

// Set to 0.01 for higher definition curves (renders slower)
$fs = 0.15;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}