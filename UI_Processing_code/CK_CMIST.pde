import processing.sound.*;  //sound library
import processing.video.*;  //video library 
import controlP5.*;

Capture cam; //live video camera 
//sound files
SoundFile warning_sound; //https://www.infrared.eca.ed.ac.uk/viewResourceDetails.cfm?id=19133
SoundFile underground_sound; //https://www.infrared.eca.ed.ac.uk/viewResourceDetails.cfm?id=24616
SoundFile click_sound; //https://www.infrared.eca.ed.ac.uk/viewResourceDetails.cfm?id=18024

//train videos
Movie videoFeed;
String[] movieFiles = {"CK_hexcode.mp4","CK_scrollingtext.mp4","CK_trainStation.m4v","train2.m4v","underwater.m4v","underwater2.m4v","satellite.mp4"}; 
//videos from:  https://upload.wikimedia.org/wikipedia/commons/9/96/Oceanic-Sharks-Clean-at-Coastal-Seamount-pone.0014755.s008.ogv
//              https://commons.wikimedia.org/wiki/File:The-Sound-Generated-by-Mid-Ocean-Ridge-Black-Smoker-Hydrothermal-Vents-pone.0000133.s002.ogv
//              https://commons.wikimedia.org/wiki/File:Metro_de_Marseille_-_Ligne_2_-_Castellane_01.ogg
//              https://commons.wikimedia.org/wiki/File:Gibraltar_iss_20130105HD.ogv
//              https://commons.wikimedia.org/wiki/File:FS_ETR_460_in_Lamezia_Terme_Centrale_train_station.webm
int currentMovie = 0;

// instantiate object to hold brackets
PImage imgBRKT1;
PImage imgBRKT2;

// instatiate object to hold maglev picture
PImage imgMaglev, imgMaglev2;

//instatiate object to hold button background
PImage imgON_OFF;

//instatiate object to hold background image
PImage imgBackgroundTop;
PImage imgBackgroundTectonic;

//instatiate object to hold hyperloop
PImage imgHYPERLOOP; //https://commons.wikimedia.org/wiki/File:Hyperloop_Cheetah.jpg

//terminal,tunnel, and track status
PImage imgStatus;

//frame map 
PImage imgFrame;

//color palette
color[] tech= {#1b1b1b,#ba9917,#e7e8e7,#94090D, #474143,#147534};
color[] palette= tech;
  
PFont myFont; //http://www.dafont.com/ds-digital.font
PFont titleFont;

//clock elements
int h; 
int m;
int s;
int ml;
String AM_PM;
int intvl2 = 8000;
int savedSeconds = 0;

//date variables
int year;
int month;
int day;

//terrain variables: surface topography: GENERATIVE VISUAL
int nCols = 18;
int nRows = 18;
float increment = 0.45;
float increment2 = 0;
float x_start=200;
float y_start=285;
CK_terrain[][] terrain;

//MAP variables
Table table;
String[] map_data;
String[] map_data2;

//scrolling waveform display of audio amplitude 
//instantiate the audio objects we need
AudioIn in;
Amplitude amp;
// a float to 'amplify' the audio input
// as the numbers we'll get will be too small to be useful
Float ampscalar = 70.0;
 // an array of floats to store the last n many frames of amp data
Float[] amps = new Float[189];
// 2 ints to hold wx & wy offsets
// wx = leftmost point
// wy = middle point of waveform
int wx = 835;
int wy = 32;

//TECTONIC MOVEMENT (GENERATIVE VISUAL) variables
ArrayList<CK_xypoint> alps = new ArrayList<CK_xypoint>();
int nalps;
int curx;
int cury;
int sval;// stroke val

//boolean variables
boolean bClick = false; //if mousePressed() => true, if mouseReleased() => false.
boolean access = false; //if submit button is pressed, you get from login page to mainpage 
boolean clicked = false;  //mouseClicked() condition
boolean imageClicker = false; //toggle between train videos

//TEXT INPUT: for pilots to log in: use a controlP5 controller
//EXAMPLE used from https://forum.processing.org/two/discussion/1576/controlp5-basic-example-text-input-field
ControlP5 cp5;
String url1, url2;  //saved text inputs: url1: NAME, url2: LOCATION 

//CLASSES
//  - circular sliders for controlling HEAT AND PRESSURE of the train 
CK_slider_circle objCircularSlider;
CK_slider_circle objCircularSlider2;
//  - autopilot on/off button: if clicked, pilot has control of train 
CK_button_onOff objButton;
//  - toggle for displaying generative visuals 
CK_desktop objDesktop;
//  - light switch 
CK_circle_toggle objCircle; 
//  - toggling between videos 
CK_toggle_square_simple objVideoToggle;
CK_toggle_square_simple objVideoToggle2;
//  - controlling speed 
CK_speed objSpeed;
//  - train doors opening/closing
CK_toggle_doors objToggleDoors;
CK_toggle_doors objToggleDoors2;
CK_toggle_doors objToggleDoors3;
CK_toggle_doors objToggleDoors4;
CK_toggle_doors objToggleDoors5;
CK_toggle_doors objToggleDoors6;
CK_toggle_doors objToggleDoors7;
CK_toggle_doors objToggleDoors8;
CK_toggle_doors objToggleDoors9;
CK_toggle_doors objToggleDoors10;
CK_toggle_doors objToggleDoors11;
CK_toggle_doors objToggleDoors12;
CK_toggle_doors objToggleDoors13;
CK_toggle_doors objToggleDoors14;
CK_toggle_doors objToggleDoors15;
CK_toggle_doors objToggleDoors16;
CK_toggle_doors objToggleDoors17;
//  - navigation from point A to point B: able to control the speed as well. 
CK_navigation objNavigation;
//  - draggable map with dynamic data in its display.
CK_map objMap;



void setup()
{
  size(1280,720);
  // force sketch to use all available pixels
  pixelDensity(displayDensity());
  background(palette[0]);
  noFill();
  stroke(palette[2]);
  
  populateArrayFromTable(); //load table for data display 
  
  //live camera display
  String[] cameras = Capture.list();
  //check if camera is available
  if (cameras.length == 0) 
  {
    println("There are no cameras available for capture.");
    exit();
  } 
  else 
  {
    cam = new Capture(this, cameras[0]);
    cam.start(); 
  }
 
    
  // maglev display: its functionality is controlling the doors and light
  imgMaglev = loadImage("maglev.png");  //light off
  imgMaglev2 = loadImage("maglev2.png");  //light on
  
  // load bracket; give object a property
  imgBRKT1 = loadImage("bracket_1.png");
  imgBRKT2 = loadImage("bracket_2.png");
  
  //load on/off autopilot button
  imgON_OFF = loadImage("button onoff.png");
  
  //load hyperloop image:this is placed in the MAP
  imgHYPERLOOP = loadImage("hyperloop.png");
  
  //background image
  imgBackgroundTop = loadImage("background_top.png");
  imgBackgroundTectonic = loadImage("frame3.png");
  
  //terminal status picture
  imgStatus = loadImage("status.png");
  
  //load font 
  myFont = loadFont("Digital.vlw");
  titleFont = loadFont("HelveticaNeue-48.vlw");
  
  //load MAP frame
  imgFrame = loadImage("frame_map.png");
  
  //load circle slider
  objCircularSlider = new CK_slider_circle(640,480,80,80,100,"","W",0.002,640,100,1000,7,25,10,"WARNING: HEAT");  
  objCircularSlider2 = new CK_slider_circle(640,315,80,80,100,"","Pa",0.002,640,80,1000,7,25,10,"WARNING: PRESSURE");

  //LIGHT SWITCH TOGGLE
  objCircle = new CK_circle_toggle(850,610,30,30,"");

  //load onOFF autopilot button
  objButton = new CK_button_onOff(730,200,30,30,20);
  
  //load desktop - flashing elliptical toggle 
  objDesktop = new CK_desktop(90,250,30,30,1000,"SURFACE TOPOGRAPHY");
  
  //load toggle square
  objVideoToggle = new CK_toggle_square_simple(55,109,38,38);
  objVideoToggle2 = new CK_toggle_square_simple(395,109,38,38);
  
  //load videos
  videoFeed = new Movie(this, "mov/" + movieFiles[currentMovie]);
  
  //load sounds 
  warning_sound = new SoundFile (this, "warning_sound.mp3");
  underground_sound = new SoundFile(this, "underground_train.mp3");
  underground_sound.loop();
  click_sound = new SoundFile (this, "click.mp3");
 
  //LOAD SPEED CONTROL 
  objSpeed = new CK_speed(640, 400, 325,540, 560, 200, 30, 180, 0.5);
 
  //DOOR TOGGLES
  objToggleDoors8 = new CK_toggle_doors(330,380,643,10,10,14,0.5);
  objToggleDoors7 = new CK_toggle_doors(395,445,643,10,10,14,0.5);
  objToggleDoors = new CK_toggle_doors(500,550,643,10,10,14,0.5);
  objToggleDoors2 = new CK_toggle_doors(565,615,643,10,10,14,0.5);
  objToggleDoors3 = new CK_toggle_doors(665,715,643,10,10,14,0.5);
  objToggleDoors4 = new CK_toggle_doors(730,780,643,10,10,14,0.5);
  objToggleDoors5 = new CK_toggle_doors(835,885,643,10,10,14,0.5);
  objToggleDoors6 = new CK_toggle_doors(900,950,643,10,10,14,0.5);
  //DOOR TOGGLES second set(lower row)
  objToggleDoors9 = new CK_toggle_doors(330,380,687,10,10,14,0.5);
  objToggleDoors10 = new CK_toggle_doors(395,445,687,10,10,14,0.5);
  objToggleDoors11 = new CK_toggle_doors(500,550,687,10,10,14,0.5);
  objToggleDoors12 = new CK_toggle_doors(565,615,687,10,10,14,0.5);
  objToggleDoors13 = new CK_toggle_doors(665,715,687,10,10,14,0.5);
  objToggleDoors14 = new CK_toggle_doors(730,780,687,10,10,14,0.5);
  objToggleDoors15 = new CK_toggle_doors(835,885,687,10,10,14,0.5);
  objToggleDoors16 = new CK_toggle_doors(900,950,687,10,10,14,0.5);
  //TOGGLE FOR OPENING/CLOSING ALL DOORS AT ONCE
  objToggleDoors17 = new CK_toggle_doors(400,480,595,15,25,24,1.0);
 
  //navigation map
  objNavigation = new CK_navigation(1220,60,10,40,0.0);
 
  //SURFACE TOPOGRAPHY: GENERATIVE DISPLAY:  
  terrain = new CK_terrain[nRows][nCols];
  for(int i = 0; i < nRows; i++){
  for(int j = 0; j < nCols; j++){
    float x = x_start-increment2+(int((j)/(nCols * 1.0) * (270*increment)));
    float y = y_start-increment2+(int((i)/(nRows * 1.0) * (270*increment)));
    terrain[i][j] = new CK_terrain(x,y);
  }
    increment += 0.07;  //increments used to give the surface display a realistic vanishing point perspective 
    increment2 += 9;
  }
  
  //tectonic movement display
  alps.add(new CK_xypoint(0,30,255));
  curx = 0;
  cury = 30;
  sval = 255;

  //MAP
  objMap = new CK_map (850, 240, 328, 300);
 
 //SCROLLING SOUND WAVEFORM DISPLAY
 //Create the amplitude object so we can analyze it
  amp = new Amplitude(this);
  // Create the Input stream
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
  // set all the values in our array to zero
  for(int i = 0; i < amps.length; i++){
    amps[i] = 0.0;
  }
  
  //TEXT INPUT FOR PILOT
  PFont font = createFont("arial",20);
  cp5 = new ControlP5(this);
  cp5.addTextfield("NAME").setFont(font).setPosition(540, 300).setSize(200, 40).setColorForeground(palette[1]).setColor(palette[1]).setColorBackground(palette[0]).setColorActive(palette[1]).setColorCaptionLabel(palette[1]).setAutoClear(false);
  cp5.addTextfield("DESTINATION").setFont(font).setPosition(540, 380).setSize(200, 40).setColorForeground(palette[1]).setColor(palette[1]).setColorBackground(palette[0]).setColorActive(palette[1]).setColorCaptionLabel(palette[1]).setAutoClear(false);
  cp5.addBang("Submit").setFont(font).setPosition(800, 380).setSize(80, 40).setColorForeground(palette[1]).setColorBackground(palette[0]).setColorActive(palette[1]).setColorCaptionLabel(palette[1]); 

}

void draw()
{
  //redraw background 
  background(palette[0]);
  
  //draw time in AM/PM format
  //if and else function to change 24 hour clock to 12 hour clock
  //uses clock and calendar of users computer
  h = hour();
  m = minute();
  s = second();
  if (h>11)
  {
    h -= 12;
    AM_PM="PM";
  }
  else 
  {
    AM_PM="AM";
  }
  textFont(myFont, 30); // set font (digital font) 
  fill(palette[1]);
  textAlign(RIGHT);
  text(nf(h,2) + ":" + nf(m,2)+ ":" + nf(s,2)+" "+AM_PM, 1250, 700); //draw numbers
 
  //draw date 
  year = year();
  month = month();
  day = day();
  text(nf(day,2) + ":" + nf(month,2)+ ":" + nf(year,4), 1250, 670);
 
  //draw elliptically shaped timer
  //does one complete rotation every second
  ml = millis() % 1000;
  stroke(palette[1]);
  fill(palette[2]);
  arc(1080, 688, 25, 25, 0, radians(ml/1000.0 * 360.0));
 
  //draw STARTUP PAGE: pilot has to login 
  if(!access)
  {
    cp5.show(); //text input display
   
    //draw title/header of startup page
    fill(palette[1]);
    textFont(titleFont, 35);
    textAlign(CENTER);
    text("COMPLEX-MAGLEV INTERNATIONAL SUBSEA TRANSPORT NETWORK",640,100);
    textFont(myFont, 70);
    text("MAGLEV S13", 640, 200);
    
    if(mouseX > 800 && mouseX < 880 && mouseY > 380 && mouseY < 420 && clicked){
      access = true;
    }
  }

  //draw MAIN PAGE: pilot is loged in
  if(access)
  {
    cp5.hide(); //hide text input controller from startup page
   
    //draw TITLE
    textAlign(CENTER);
    textFont(myFont,55);
    fill(palette[1]);
    text("MAGLEV X13",638,50);
    textAlign(RIGHT);
    textSize(30);
    text("MAP X13",1178,565);
 
    //draw MAGLEV  
    image(imgMaglev,640,670);
 
    //draw background images
    image(imgBackgroundTop,640,115);
 
    //draw video changing toggle
    objVideoToggle.display();
    objVideoToggle2.display();

    //draw train videos
    image(videoFeed, 245, 126, 280, 168); 

    //swap train videos automatically 
    if((millis()) > savedSeconds + intvl2)
    {
      savedSeconds = millis();
      currentMovie +=1;
      if(currentMovie >= movieFiles.length) currentMovie = 0;
      videoFeed = new Movie(this, "mov/" + movieFiles[currentMovie]);
      videoFeed.play();
      videoFeed.volume(0);
    }
    // swapMovie manually with toggle (FORWARD)
    if(objVideoToggle2.bToggle){
      savedSeconds = millis();
      currentMovie +=1;
      if(currentMovie >= movieFiles.length) currentMovie = 0;
      imageClicker = true;
      videoFeed = new Movie(this, "mov/" + movieFiles[currentMovie]);
      videoFeed.play();
      videoFeed.volume(0);
    }
    // swapMovie manually with toggle (BACKWARD)
    if(objVideoToggle.bToggle){
      savedSeconds = millis();
      currentMovie -=1;
      if(currentMovie < 0) currentMovie = 6;
      imageClicker = true;
      videoFeed = new Movie(this, "mov/" + movieFiles[currentMovie]);
      videoFeed.play();
      videoFeed.volume(0);
    }
  
    //draw live camera
      if (cam.available() == true) {
      cam.read();
    }
    image(cam, 1027, 126,280,168);
  
    //display drunken on circular slider (make elliptical slider move continuously up and down by a margin +/-) 
    objCircularSlider.drunken();
    objCircularSlider2.drunken();
 
    //DRAW FRAME FOR DOOR TOGGLE
    noFill();
    stroke(palette[1]);
    rect(400,595,80,25);
    //DRAW TITLE FOR DOOR TOGGLE
    textAlign(CENTER);
    textFont(myFont,40);
    fill(palette[1]);
    text("DOORS",440,590);
    //DRAW TITLE FOR LIGHT TOGGLE
    text("LIGHTS",850,590);

    //AUTOPILOT TEXT
    textAlign(CENTER);
    if (objButton.bToggle){
      fill(palette[3]);
    }
    else{
    fill(palette[1]);
    }
    textFont(myFont, 40);
    text("AUTOPILOT:", 580, 210);
 
    //display HEAT, PRESSURE, SPEED
    objButton.display();
    objSpeed.display();
    objCircularSlider.display();
    objCircularSlider2.display();
    objCircularSlider.numerical_data(); //display value of heat/pressure in text
    objCircularSlider2.numerical_data();
 
    objCircle.display();  //light switch 
      
    if (objCircle.bToggle)
    {
      image(imgMaglev2,640,670);
    }
     
    //DRAW DOORS
    objToggleDoors.display();
    objToggleDoors2.display();
    objToggleDoors3.display();
    objToggleDoors4.display();
    objToggleDoors5.display();
    objToggleDoors6.display();
    objToggleDoors7.display();
    objToggleDoors8.display();
    objToggleDoors9.display();
    objToggleDoors10.display();
    objToggleDoors11.display();
    objToggleDoors12.display();
    objToggleDoors13.display();
    objToggleDoors14.display();
    objToggleDoors15.display();
    objToggleDoors16.display();
    objToggleDoors17.display();

    //if autopilot button toggled you can control speed, temperature, pressure etc. 
    if (objButton.bToggle)
    {
      objSpeed.check_clearance();
      objCircularSlider.checkClearance();
      objCircularSlider2.checkClearance();
      //all doors
      objToggleDoors.check_clearance();
      objToggleDoors2.check_clearance();
      objToggleDoors3.check_clearance();
      objToggleDoors4.check_clearance();
      objToggleDoors5.check_clearance();
      objToggleDoors6.check_clearance();
      objToggleDoors7.check_clearance();
      objToggleDoors8.check_clearance();
      objToggleDoors9.check_clearance();
      objToggleDoors10.check_clearance();
      objToggleDoors11.check_clearance();
      objToggleDoors12.check_clearance();
      objToggleDoors13.check_clearance();
      objToggleDoors14.check_clearance();
      objToggleDoors15.check_clearance();
      objToggleDoors16.check_clearance();
      objToggleDoors16.check_clearance();
      objToggleDoors17.check_clearance();
     
      //lights
      objCircle.autopilotOff();
    }
    //if main door is toggled all of the doors open/close
    if(objToggleDoors17.bToggle)
    {
      objToggleDoors.open_all();
      objToggleDoors2.open_all();
      objToggleDoors3.open_all();
      objToggleDoors4.open_all();
      objToggleDoors5.open_all();
      objToggleDoors6.open_all();
      objToggleDoors7.open_all();
      objToggleDoors8.open_all();
      objToggleDoors9.open_all();
      objToggleDoors10.open_all();
      objToggleDoors11.open_all();
      objToggleDoors12.open_all();
      objToggleDoors13.open_all();
      objToggleDoors14.open_all();
      objToggleDoors15.open_all();
      objToggleDoors16.open_all();
    }
    //draw navigation
    stroke(palette[1]);
    line(1220,40,1220,600);
    line(1216,40,1224,40);
    line(1216,600,1224,600);
    fill(palette[1]);
    textSize(16);
    text("Apex-R",1220,35);
    Submit();
    text(url2,1220,618); //url2 is from user input
    objNavigation.display();
    // assign control of speed
    objNavigation.xspeed = floor(objSpeed.speed_ratio*5);
    objNavigation.updatePosition();
    objMap.updatePosition();
  
    //TERMINAL STATUS PICTURE
    image(imgStatus,723,385); 
    
    //DRAW MAP
    objMap.display();
    //draw map frame
    image(imgFrame,844,234);
  
    //DRAW WAVE AUDIO DISPLAY
    //move each item one place to the left
    for(int i = 0; i < amps.length -1; i++){
      amps[i] = amps[i+1];
    }
    // the last position in the array holds the most recent value
    amps[amps.length - 1] = amp.analyze();
    // draw all the values
    for(int i = 0; i < amps.length; i++){
      line(wx - amps[i] * ampscalar, wy + i,wx + amps[i] * ampscalar,wy + i);
    }
    //frame for sound display(just two lines)
    line(820, 32, 850, 32);
    line(820, 220, 850, 220);
 
    //DRAW USER INPUT NAME AND DESTINATION
    fill(255);
    textAlign(CENTER);
    textFont(myFont,25);
    fill(palette[1]);
    text(url1, 1025,38);
    
    //DRAW TOGGLE FOR SURFACE TOPOGRAPHY:
    objDesktop.display();
    if(objDesktop.bToggle){
      //DRAW SURFACE TOPOGRAPHY 
      for(int i = 0; i < nRows; i++){
        for(int j = 0; j < nCols; j++){
          terrain[i][j].drawNode();          
          //draw lines
          stroke(palette[1]);
          strokeWeight(1);
          if(i < nRows - 1){
            line(terrain[i][j].x,terrain[i][j].y,
            terrain[i+1][j].x,terrain[i+1][j].y);
            if(j < nCols - 1){
            line(terrain[i][j].x,terrain[i][j].y,
            terrain[i+1][j+1].x,terrain[i+1][j+1].y);
            }
          }
          if(j < nCols - 1){
            line(terrain[i][j].x,terrain[i][j].y,
            terrain[i][j+1].x,terrain[i][j+1].y);
          }
          //TECTONIC DISPLAY
          //if a node is clicked => tectonic movement display shows
          if (terrain[i][j].tectonicDisplay)
          {
              //DRAW TECTONIC DISPLAY             
              text("tectonic movement",30,595);
              image(imgBackgroundTectonic,10,565);
              nalps = alps.size();
              if(nalps > 1){
                for(int r = 0; r < nalps - 1; r++){
                  if(alps.get(r).x < alps.get(r+1).x){
                    stroke(palette[1],alps.get(r).s);
                    line(alps.get(r).x+10,alps.get(r).y+600,alps.get(r+1).x+10,alps.get(r+1).y+600);
                  }
                }
              }
              // new point
              curx += int(random(10)) + 30;
              if(curx > 280){
                curx = 0;
                sval = (int(random(255)));
                for(int r = 0; r < nalps; r++){
                  alps.get(r).updateY();
                }
                 cury = 30;
              }
              cury += int(random(-10,10));
              alps.add(new CK_xypoint(curx,cury,sval));

          }
        }
      }  
    }
   
  }
  //END OF MAIN PAGE
 
  //draw cursor mouse 
  strokeWeight(2);
  stroke(palette[4]);
  fill(palette[2]);
  ellipse(mouseX, mouseY, 10, 10);
 
  // draw bracket_1 with some 'magic' around cursor
  // 'magic' is making bracket rotate with movement in the x-direction
  pushMatrix();
  translate(mouseX,mouseY);
  rotate(radians((mouseX/float(width))*720.0));
  imageMode(CENTER);
  image(imgBRKT1,0,0);
  popMatrix(); 
 
  // draw bracket_2 with some 'magic' around cursor
  // 'magic' is making bracket rotate with movement in the y-direction
  pushMatrix();
  translate(mouseX,mouseY);
  rotate(radians((mouseY/float(height))*720.0));
  imageMode(CENTER);
  image(imgBRKT2,0,0);
  popMatrix(); 
  
  //reset click
  bClick = false;
  clicked = false;
  imageClicker = false;
}
//END OF DRAW


void movieEvent(Movie m) 
{
  m.read();
}
void mousePressed()
{
  bClick = true;
  
  // check hover on map
  if ((mouseX >= objMap.x)
      && (mouseX <= objMap.x+objMap.w)
      && (mouseY >= objMap.y)
      && (mouseY <= objMap.y+objMap.h)) {
    objMap.x_drag = mouseX - objMap.x_draw;
    objMap.y_drag = mouseY - objMap.y_draw;
    objMap.m_x_drag = mouseX - objMap.m_x;
    objMap.m_y_drag = mouseY - objMap.m_y;
    objMap.locked = true;
    cursor(HAND);
      }
}

void mouseDragged() {
  // check hover on map
  if ((mouseX >= objMap.x)
      && (mouseX <= objMap.x+objMap.w)
      && (mouseY >= objMap.y)
      && (mouseY <= objMap.y+objMap.h)) {
      if (objMap.locked) {
        objMap.x_draw = mouseX - objMap.x_drag;
        objMap.y_draw = mouseY - objMap.y_drag;
        objMap.m_x = mouseX - objMap.m_x_drag;
        objMap.m_y = mouseY - objMap.m_y_drag;  
      }
   }
}

void mouseReleased()
{
  bClick = false; 
        // check hover on map
  if ((mouseX >= objMap.x)
      && (mouseX <= objMap.x+objMap.w)
      && (mouseY >= objMap.y)
      && (mouseY <= objMap.y+objMap.h)) {
   objMap.locked = false;
   cursor(ARROW);
   }
}

void mouseClicked()
{
  clicked = true;
}

  
void keyPressed ()  { 
  if (keyCode == ENTER)
  {
    access=!access;
  }
}

void customize(ScrollableList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(15);
  ddl.getCaptionLabel().set("dropdown");
  for (int i=0;i<5;i++) {
    ddl.addItem("item "+i, i);
  }
  //ddl.scroll(0);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void populateArrayFromTable(){
  // load data into table object
  table = loadTable("table_map.csv", "header");
  map_data = new String [table.getRowCount()];
  map_data2 = new String [table.getRowCount()];
  int nRow = 0;
  // iterate 
  for (int i = 0; i < map_data.length; i++) {
    String ch = table.getRow(i).getString("Checkpoint");
    String ge= table.getRow(i).getString("Geothermal vent");
    String sp = table.getRow(i).getString("Species");
    String oc = table.getRow(i).getString("Ocean Current");
    map_data[i] = ch+"\n"+ge+"\n"+"Number of Acquatic Species: "+sp+"\n"+ "Ocean Current: " +oc+ " km/h";
  }
  for (int i = 0; i < map_data.length; i++) {
    String thunder = table.getRow(i).getString("Thunder");
    map_data2[i] = "Thunderstorm: level "+thunder;
  }
}

void Submit() {
  print("the following text was submitted :");
  url1 = cp5.get(Textfield.class,"NAME").getText();
  url2 = cp5.get(Textfield.class,"DESTINATION").getText();
  print(" textInput 1 = " + url1);
  print(" textInput 2 = " + url2);
  println();
}