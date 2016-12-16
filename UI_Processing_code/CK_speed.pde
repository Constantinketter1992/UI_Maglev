//RECTANGULAR SLIDER CONTROLLING THE SPEED (ARC DISPLAY)  

class CK_speed{
  int x,y,r,w,h,x1,y1;
  int range_value;
  int number_indicators;
  int range_indicators;
  float speed_ratio;
  boolean hover = false;
  boolean autopilotOff = false;
  boolean warning = false;
  boolean bFlash = false;
  boolean bToggle = false;

  int intvl = 1000;
  int savedMillis = 0;
  
  float speed_ratio2 = 5*speed_ratio;
  
  
 //CONSTRUCTOR 
 CK_speed (int tX, int tY, int tR,int tX1, int tY1, int tW, int tH, int tRange_value, float tSpeed_ratio){
 range_value = tRange_value;
 speed_ratio = tSpeed_ratio;
 x = tX;
 y = tY;
 x1 = tX1;
 y1 = tY1;
 r = tR;
 w = tW;
 h = tH;
 
 }
 
 //FUNCTIONALITY  
 void display(){
   
   check_warning();
   checkMillis();
   
   range_indicators = int((range_value)/13);  //range of every indicator; total of 13
   number_indicators = int (speed_ratio*(range_value)/range_indicators);
   strokeWeight(3);
   for (int i = 0; i < number_indicators; i++) //draw
   {
     ellipseMode(CENTER);
     noStroke();
     if(speed_ratio < 0.8){fill(palette[2]);}else{fill(palette[3]);}  //RED WARNING COLOR
     arc(x, y, r, r, radians((i*23.3)+120), radians((i*23.3)+140), PIE);  // draw indicators
     fill(palette[0]);
     stroke(palette[0]);
     arc(x, y, r-50, r-50, radians((i*23.3)+120), radians((i*23.3)+140), PIE); // delete inner arc to create segments
   }
   
   //display speed in text
   textAlign(CENTER);
   if(speed_ratio < 0.8){fill(palette[2]);}else{fill(palette[3]);}  //RED WARNING COLOR
   textFont (myFont, 50);
   text(int(speed_ratio*1000),x,y);
   textFont (titleFont,16);
   text("\nkm/h",x,y);
   
   //display horizontally rectangular slider
   checkHover();
   drunken();
   if(autopilotOff){
   if(hover && mousePressed) {
      speed_ratio =  (mouseX - x1)/float(w);
      }
   }
   
   //draw rectangular toggle
    noStroke();
    rect(x1+(speed_ratio*w),y1,-speed_ratio*w,h);
    //draw frame of toggle
    noFill();
    stroke(palette[1]);
    rect(x1,y1,w,h);
    //draw line on toggle 
    strokeWeight(10);
    fill(palette[1]);
    line(x1+(speed_ratio*w),y1-5,x1+(speed_ratio*w),y1+h+5);
   
   
    noFill();
    stroke(palette[1]);
    arc(x+15, y, r, r, radians(-45), radians(45)); 
    arc(x-15, y, r, r,radians(135), radians(225));
    
    
    //WARNING SIGN
    if (bFlash && warning)
    {
      fill(palette[3]);
      textAlign(CENTER);
      textSize(15);
      text("WARNING: SPEED",640,120);
      warning_sound.play();
    } 
    
    //click sound
    if(autopilotOff){
    if(hover && clicked) {
      //bToggle = !bToggle;
      click_sound.play();
      }
   }
    

    
    autopilotOff=false;
    hover = false;
 }
 //END OF DISPLAY
 
 void checkHover (){
   if(mouseX > x1
        && mouseX < x1 + w
        && mouseY > y1-5
        && mouseY < y1+5 + h) hover = true;
 }
  
 void drunken(){
   speed_ratio += random(-0.001,0.001);
   if(speed_ratio < 0.0) speed_ratio = 0.0;
   if(speed_ratio > 1.0) speed_ratio = 1.0;
  }
 void check_clearance(){
   autopilotOff = true;
 }
 
   //flashing "WARNING" text
  void checkMillis()
  {
    if(millis() > savedMillis + intvl)
    {
      //flip flop bFlash boolean 
      bFlash = !bFlash;
      savedMillis = millis();
    }
  }
  //flashing WARNING text
  void check_warning()
  {
    if (speed_ratio >= 0.8)
      {
        warning = true;
      }
    else 
    {
      warning = false;
    }
  }
}
 