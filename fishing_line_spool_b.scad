/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/* [Main dimension] */
// Total length of spool from end to end
totalLength = 140;
// Width of spool
totalWidth = 25;
// Thickness of walls
wallThickness = 2;
// 1: Create centered pins, 0: create pins on side
createCenteredPins = 0; // [0:false, 1:true]

/* [Hidden] */
wallRounding = 2;
// Space between spool and lineholder
lineHolderSpace = 40;

/* [Pin dimensions] */
// Width of big part of pins
bigPinWidth = 8;
// Height of big part of pins
bigPinHeight = 10;
// Width of small part of pins
smallPinWidth = 3;
// Height of small part of pins
smallPinHeight = 8;

// Length of "hook holder" wall
hookHolderLength = 9;
// Width of "hook holder" wall
hookHolderWidth = 1;

/* [Pin placement] */
// Distance from end for placement of first pair of pins
pin1Distance = 10;
// Length from end for placement of second pair of pins
pin2Distance = 40;

/* [Printer compensation] */
// Make hole slightly bigger to compensate for 3d printer inaccuracy
// Make hole inside pin this much wider than the small pin
holeCompensationWidth = 0.5;
// Make hole inside pin this much longer than the small pin
holeCompensationLength = 1;


/* [Lineholder] */
// Make lineholder hole this much wider than the big pin
lineHolderHoleWidthCompensation = 1.5;
lineHolderHoleThickness = bigPinWidth + lineHolderHoleWidthCompensation;
// Make lineholder outwards circle this much wider than the big pin
lineHolderCircleThicknessIncrement = 6;
lineHolderCircleThickness = bigPinWidth + lineHolderCircleThicknessIncrement;
// Thickness of "handle"
lineHolderHandleThickness = 3;
// Wiggle room for width. How much space is left on the sides
lineHolderHandleWidthWiggleRoom = 5;
lineHolderHandleWidth = bigPinHeight+smallPinHeight-lineHolderHandleWidthWiggleRoom;
// Length of the handle
lineHolderHandleLength = 20;
// Placement of hole. Smaller value for tighter hold
LineHolderPlacementAdjustment = 2;
lineHolderPlacement = lineHolderSpace - lineHolderHoleWidthCompensation - LineHolderPlacementAdjustment;



// Smoothness (of circles).
// Can be put lower(20) when testing for better performance, and higher(40) for final export
$fn = 20 + 0;

if (createCenteredPins) {
    wholeSpoolCentered();
} else {
    wholeSpoolNotCentered();
}

lineHolder();


module bottomPlate () {
    color("blue")
    translate(v = [0, 0, wallThickness/2])
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


module wholeSpoolCentered() {
    bottomPlate ();
    // 1: Create pin
    translate(v = [(totalLength/2)-pin1Distance, 0, 0]) pin(false);

    // 2: Create hole
    translate(v = [(totalLength/2)-pin2Distance, 0, 0]) hole(true);

    // 3: Create pin
    translate(v = [-(totalLength/2)+pin2Distance, 0, 0]) pin(true);

    // 4: Create hole
    translate(v = [-(totalLength/2)+pin1Distance, 0, 0]) hole(false);
}

module wholeSpoolNotCentered() {
    bottomPlate ();
    sidewaysMovement = (totalWidth/2)-bigPinWidth/2;
    // 1: Create pin
    translate(
    v = [
            (totalLength/2)-pin1Distance,
            sidewaysMovement,
            0
        ]
    )
    pin(false);

    // 2: Create hole
    translate(
    v = [
            (totalLength/2)-pin2Distance,
            sidewaysMovement,
            0
        ]
    )
    hole(true);

    // 3: Create pin
    translate(
    v = [
            -(totalLength/2)+pin2Distance,
            sidewaysMovement,
            0
            ]
    )
    pin(true);

    // 4: Create hole
    translate(
    v = [
            -(totalLength/2)+pin1Distance,
            sidewaysMovement,
            0
        ]
    )
    hole(false);
}


module lineHolder () {
    color("grey")
    difference () {
        lineHolderParts();
        translate(v = [(totalLength/2)+lineHolderPlacement, 0, 0])
       cylinder(h=bigPinHeight+smallPinHeight+20, d=bigPinWidth, center=true);
    }

}

module lineHolderParts () {

    color("grey")
       translate(
        v = [
                (totalLength/2)+ lineHolderSpace,
                0,
                lineHolderHandleWidth/2
            ])
         cylinder(
                h=lineHolderHandleWidth,
                d=lineHolderCircleThickness,
                center=true
                );
       translate(
        v = [
                (totalLength/2)+ lineHolderSpace+lineHolderHandleLength/2,
                0,
                lineHolderHandleWidth/2
            ])
         cube(
            [
                lineHolderHandleLength,
                lineHolderHandleThickness,
                lineHolderHandleWidth
            ],
            true
            );
}


