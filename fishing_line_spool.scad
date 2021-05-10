// Main parameters
// Total length of spool from end to end
totalLength = 140;
// Inner width of spool (should be bigger than the width of your bobber)
innerWidth = 25;
// Thickness of walls
wallThickness = 3;
// The height of the walls (+ thickness of walls)
wallHeight = 17 + wallThickness;

// End circles
// How "deep" into the main part should the circles be moved
circleDepth = 17;
// Normally 0, but if the above circleDepth value is high you can add here to get smoother circle
circleRadiusExtra = 8;

// Inner rectangular hole
// Length of the inner hole
holeLength = totalLength - 50;
// Width of the inner hole
holeWidth = innerWidth/2;

// Smoothness (of circles). 
// Can be put lower when testing for better performance, 
// and higher for final export
$fn = 40;

// Uncomment for splitting in half if your build plate is too small
// You need Johannes' OpenSCAD library in your path (https://github.com/jernst/josl)
/*
use <josl/cuts/puzzle.scad>

Puzzle( y=[3.5,16.5]) {
    translate( [ -totalLength/2, 0, 0 ] ) {
        wholeSpool();
   } 
}

*/

wholeSpool();



module fullSpool () {
    color("blue")
    cube([totalLength,innerWidth,wallThickness]);
}

module endCircle (){
    color("red")
    linear_extrude(height = wallThickness+5, center = true, convexity = 10, twist = 0)
    circle(r = (innerWidth/2)+circleRadiusExtra);
}

module sidePanel (){
    color("green")
    cube([totalLength,wallThickness,wallHeight]);

}

module middlePin (){
    color("orange")
    cube([3,innerWidth,wallThickness/2]);
}

module innerHole (){
    color("green")
    cube([holeLength,holeWidth,50]);
}

module wholeSpool() {
    difference() {
    {
        {
            difference() 
            {
            fullSpool();
            translate([totalLength + circleDepth , innerWidth/2, 0]) endCircle();
            translate([-circleDepth, innerWidth/2, 0]) endCircle();
            }

        }
    }
translate([(totalLength-holeLength)/2,holeWidth/2 , -20]) innerHole();
}

translate([totalLength/2, 0  , 0]) middlePin();

translate([0, innerWidth, 0]) sidePanel();
translate([0, -wallThickness, 0]) sidePanel();
}


