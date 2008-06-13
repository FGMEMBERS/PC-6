### The Aircraft interiour map consists of a set of rectangular shaped "zones". 
### These are defined here with their left and right measures and a forward coordinate. The rear end is 
### the front end of the next zone. The End is marked by an end zone with zero left and right values. 
### The fourth value is the view heigth, the sixth value is planned for "actions" like door open/closed. 
### This is not used yet. 
### The seventh and eight values indicate which zone is located on the left and right of this zone. 
### A value of -1 means there is no zone to enter on this side (the movement is blocked).
### Coordinates can be taken from the /sim/current-view/x-, y-, z-offset-m properties.

### Zone corners, 						 left, 			 front,		  	action,    left z
### Zone corners, 									 right,			 heigth, 	action-prop  right z
var zoneData = [
    ["between seats"					,0.0,		0.05, 3.5,	0.6,		0,	0,	-1,		 5],		#0
		["way back"								,0.0,		0.05,	3.6,	0.6,		0,	0,	-1,		-1],		#1
    ["cargo room 1"						,-0.4,	0.4,	4.2,	0.5,		0,	0,	-1,		 7],		#2
		["cargo room 2"						,-0.4,	0.4,	5.5,	0.5,		0,	0,	-1,		-1],		#3		
    ["End" 										,0.0,		0.0,	6.0,	0.0,		0,	0,	-1,		-1],
		["Co Pilot Seat"					,0.05,	0.3,	3.4,	0.7,		0,	0,	 0,		-1],
		["End"										,0,			0,		3.9,	0,			0,	0,	-1,		-1],
		["right door"							,0.4,	0.42,		4.1,	0.5,		2,	0,	 2,		-1],
		["End"										,0,			0,		5.5,	0,			0,	0,	-1,		-1]
];
var doorCount = 0;
var doorData = [
	[4.7, 0.3,	0.5,	2]
];
