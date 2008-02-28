var cview = nil;
var aphmode = nil;
var avhmode = nil;
var htempmode = nil;
var vtemphome = nil;
var head = nil;
var posx = nil;
var posy = nil;
var posz = nil;
var currentZone = 1;
var leftZone = 7;
var rightZone = 9;
var sin = func(a) { math.sin(a * math.pi / 180.0) }
var cos = func(a) { math.cos(a * math.pi / 180.0) }

var init = func {
  setprop ("/autopilot/locks/heading" , "none" );
  setprop ("/autopilot/locks/altitude" , "none" );

 main_loop();
}

var main_loop = func {
  cview = getprop("/sim/current-view/view-number");
    if (cview >= 7) {
      aphmode = getprop ("/autopilot/locks/heading");
      apvmode = getprop ("/autopilot/locks/altitude");
#      print (aphmode);
#      print (apvmode);
      if (aphmode == "none" ) {
        setprop ("/autopilot/locks/heading", "wing-leveler");
        setprop ("/autopilot/htempmode", 1 );
      }
      if (apvmode == "none" ) {
        setprop ("/autopilot/locks/altitude", "vertical-speed-hold");
        setprop ("autopilot/vtempmode" , 1 );
      }



    } else {
      htempmode = getprop ("/autopilot/htempmode");
      vtempmode = getprop ("/autopilot/vtempmode");
      if (htempmode == 1) {
        setprop ("/autopilot/locks/heading" , "none" );
        setprop ("/autopilot/htempmode" , 0);
      }
      if (vtempmode == 1) {
        setprop ("/autopilot/locks/altitude" , "none" );
        setprop ("/autopilot/vtempmode" , 0);
      }
    }
    settimer(main_loop, 0.01);
} 

### doors 

var toggle_pilotdoor = func {
  door0 = aircraft.door.new ("/controls/doors/door0",3);
  if(getprop("/controls/doors/door0/position-norm") > 0) {
      door0.close();
  } else {

      door0.open();
  }
}
var toggle_copilotdoor = func {
  door1 = aircraft.door.new ("/controls/doors/door1",3);
  if(getprop("/controls/doors/door1/position-norm") > 0) {
      door1.close();
  } else {

      door1.open();
  }
}
var toggle_fswingdoor = func {
  door2 = aircraft.door.new ("/controls/doors/door2",3);
  if(getprop("/controls/doors/door2/position-norm") > 0) {
      door2.close();
  } else {

      door2.open();
  }
}
var toggle_rswingdoor = func {
  door6 = aircraft.door.new ("/controls/doors/door6",3);
  if(getprop("/controls/doors/door6/position-norm") > 0) {
      door6.close();
  } else {

      door6.open();
  }
}
var toggle_slidedoor = func {
  door4 = aircraft.door.new ("/controls/doors/door4",3);
  if(getprop("/controls/doors/door4/position-norm") > 0 ) {
      door4.close();
  } else {

      door4.open();
  }
}
var toggle_rearhatch = func {
 	 door5 = aircraft.door.new ("/controls/doors/door5",3);
 	 if(getprop("/controls/doors/door5/position-norm") > 0) {
  	    door5.close();
 	 } else {

  	    door5.open();
	}
}
#### interiour Movement

var int_mov = func {


				if (getprop ("sim/current-view/view-number") == 7) {
				if (getprop ("devices/status/mice/mouse/mode") == 2){

						head = getprop ("sim/current-view/heading-offset-deg");
						posx = getprop ("sim/current-view/x-offset-m");
						posy = getprop ("sim/current-view/y-offset-m");
						posz = getprop ("sim/current-view/z-offset-m");
### left - right
						if (posx > zoneData[currentZone][1]){
							if (posx < zoneData[currentZone][2]) {
							interpolate ("sim/current-view/x-offset-m", posx - 0.1*sin(head),0.25);
						} else {
								if (rightZone > -1) {
									currentZone=rightZone;
									leftZone = zoneData[currentZone][6];
									rightZone = zoneData[currentZone][7];
#									print ("right");
#									print (currentZone);
#									print (leftZone);
#									print (rightZone);
								} else {
								setprop ("sim/current-view/x-offset-m", posx -0.02);
								}
							} 
					} else {
								if (leftZone > -1) {
									currentZone=leftZone;
									leftZone = zoneData[currentZone][6];
									rightZone = zoneData[currentZone][7];
#									print ("left");
#									print (currentZone);
#									print (leftZone);
#									print (rightZone);
								} else {
								setprop ("sim/current-view/x-offset-m", posx +0.02);
								}
							}
### fore - aft
						if (posz > zoneData[currentZone][3]){
							if (posz < zoneData[currentZone+1][3]) {
							interpolate ("sim/current-view/z-offset-m", posz - 0.2*cos(head),0.25);
						} else {
							if (posx > zoneData[currentZone+1][1] and posx < zoneData[currentZone+1][2]) {
								currentZone = currentZone +1;

								leftZone = zoneData[currentZone][6];
								rightZone = zoneData[currentZone][7];
#								print (currentZone);
#								print (leftZone);
#								print (rightZone);
							} else {
								setprop ("sim/current-view/z-offset-m", posz -0.02);
								}
							} 
					} else {
							if (posx > zoneData[currentZone-1][1] and posx < zoneData[currentZone-1][2]) {
								currentZone = currentZone -1;
								leftZone = zoneData[currentZone][6];
								rightZone = zoneData[currentZone][7];
#								print ("zone -");
							} else {
							setprop ("sim/current-view/z-offset-m", posz +0.02);
								}
							}
### up - down
						if (posy != zoneData[currentZone][4]){
							interpolate ("sim/current-view/y-offset-m", zoneData[currentZone][4],0.25);
						}
					
				}
			}
}
### The Aircraft interiour map consists of a set of rectangular shaped "zones". 
### These are defined here with their left and right measures and a forward coordinate. The rear end is 
### the front end of the next zone. The End is marked by an end zone with zero left and right values. 
### The fourth value is the view heigth, the sixth value is planned for "actions" like door open/closed. 
### This is not used yet. 
### The seventh and eight values indicate which zone is located on the left and right of this zone. 
### A value of -1 means there is no zone to enter on this side (the movement is blocked).
### Coordinates can be taken from the /sim/current-view/x-, y-, z-offset-m properties.

### Zone corners, 						 left, 			 front,		  	action,    right z
### Zone corners, 									 right,			 heigth, 		left z
    zoneData = [
    ["nose"      							,-0.4,	0.4,  1.0,	-0.2,		0,	-1,		-1],
		["Nose Door"							,-0.1,	0.1,	2.3,	-0.3,		0,	-1,		-1],
    ["Pilot Compartment"			,-0.2,	0.2,	3.2,	0.4,		0,	8,		10],
		["Cockpit Door"						,-0.1,	0.1,	4.5,	0.35,		0,	-1,		-1],				
    ["Navigator Compartment"  ,-0.8,	0.8,	5.1,	0.5,		0,	-1,		-1],
		["Passage"								,-0.4,	0.4,	6.7,	0.5,		0,	-1,		-1],
		["Rear Room"							,-0.8,	0.8,	8.7,	0.5,		0,	12,		-1],
		["End"										,0,			0,		12.3,	0,			0,	-1,		-1],
		["Pilot Side"							,-0.7,	-0.2,	3.0,	0.5,		0,	-1,		2],
		["End"										,0,			0,		4.6,	0,			0,	-1,		-1],
		["coPilot Side"						,0.2,		0.7,	3.0,	0.5,		0,	2,		-1],
		["End"										,0,			0,		4.6,	0,			0,	-1,		-1],
		["Rear Door"							,-1.0,	-0.8,	11.6,	0.4,		0,	-1,		6],
		["End"										,0,			0,		12.3,	0,			0,	-1,		-1]
    ];
