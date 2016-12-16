//elliptical arc slider

class CK_slider_circle
{
  
  float x;
  float y;
  float w;
  float h;
  int x_warning;
  int y_warning;
  int x_frame;
  int font_size;
  int r_tracker;
  
  boolean circleHover = false;
  boolean warning = false;
  boolean bFlash = false;

  int intvl;
  int savedMillis = 0;
  
  //variables for cursor
  float point_cursor;
  float angle = PI/4;
  
  //variable for drunken value
  float up_down;
  //variable for text display (circular slider)
  int text_mult;
  String unit;
  String var;
  String alarm;
  
  
  //CONSTRUCTOR
  CK_slider_circle(int tx, int ty, int tw, int th, int tText_mult, String tvar,String tUnit,float tUp_down, int tx_warning, int ty_warning, int tintvl, int tX_frame,int tFont_size, int tR_tracker,String talarm)
  {
     x = tx;
     y = ty;
     w = tw;
     h = th;
     text_mult = tText_mult;
     var = tvar;
     unit = tUnit;
     up_down = tUp_down;
     x_warning = tx_warning;
     y_warning = ty_warning;
     intvl = tintvl;
     x_frame = tX_frame;
     font_size = tFont_size;
     r_tracker = tR_tracker;
     alarm = talarm;
  }
  
  
  //FUNCTIONALITY
  void display()
  {
    checkHover();
    check_warning();
    checkMillis();
   
    //draw outer circle(frame)
    //noFill();
    //stroke(255);
    //ellipse(x,y,w,h);

    
    //draw slider
    //slider's color changes with angle- indicates danger level. Once an angle of >= 1.5*PI is reached, the siren is initiated.
    noStroke();
    if (angle <1.5*PI)
    {
    fill(palette[2]);
    arc(x,y,w,h,0, angle, PIE);
    }
    if (angle >= 1.5*PI)
    {
      fill(palette[3]);
      arc(x, y, w, h, 0, angle, PIE);
    }
    
    //draw tracker in circle
    noStroke();
    fill(palette[1]);
    arc(x,y,w+r_tracker,h+r_tracker, angle-0.1, angle+0.1, PIE);
    //draw inner circle
    fill(palette[0]);
    ellipse(x,y,w*3/4,h*3/4);
    
    //draw frame
    strokeWeight(2);
    noFill();
    stroke(palette[1]);
    arc(x+x_frame, y, w, h, radians(-30), radians(30)); 
    arc(x-x_frame, y, w, h,radians(150), radians(210));
    
    
    //alarm - a flashing text "WARNING" shows up for when the angle is >= 1.5*PI
    if (bFlash && warning)
    {
      fill(palette[3]);
      textAlign(CENTER);
      textSize(15);
      text(alarm,x_warning,y_warning);
      warning_sound.play();
    }
    
    
    //SIREN
    //if(warning)
    //{
      //warning_sound.loop();
    //}
    //if(!warning)
    //{
      //warning_sound.stop();
    //}
    
    //click sound
    if(circleHover && clicked) {
      //bToggle = !bToggle;
      click_sound.play();
      }
   
  } 
  //END OF DISPLAY 
  
 
  //check if slider is being hovered 
  void checkHover()
  {
    circleHover = false;
    //check mouse
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < h/2 ) 
    {
      circleHover = true;
    }
  }
 
  //implement a function where the angle changes on its own 
  void drunken()
  {
   angle += random(-up_down,up_down);
   // defensive
   if(angle < 0.0) angle = 0.0;
   if(angle > 2.0*PI) angle = 2.0*PI;
  }
  
  //display variable information - e.g. "Pressure" with units of pressure "PA"
  //the value of pressure changes with the angle and a multiplier "text_mult"
  //for the speed for example the "text_mult" will be lower than for the pressure
  //in order to display a realistic value for speed, pressure, and heat
  void numerical_data()
  {
    if(angle < 1.5*PI){fill(palette[2]);} else{fill (palette[3]);} //WARNING THRESHOLD 
    textAlign(CENTER);
    textFont(myFont,font_size);
    text(round(angle*text_mult),x,y+5);
    textFont(titleFont,0.5*font_size);
    text("\n" +unit,x,y+5);
    text(var + " ",x,y-h);
  }
  
  // check alarm condition
  void check_warning()
  {
    if (angle >= 1.5*PI)
      {
        warning = true;
      }
    else 
    {
      warning = false;
    }
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
  
  //how the slider moves
  //3 lines were drawn to apply the cosine formula
  void checkClearance()
  {
    if(circleHover && mousePressed) 
    {
      //draw fill of circle
      //do math first
      point_cursor = mouseY;
      float d_1 = dist(x+(w/2),y,mouseX,point_cursor); 
      float d_2 = dist(x,y,mouseX,point_cursor);
      float d_3 = dist(x,y,x+(w/2),y); 
      if (point_cursor >= y)
      {
        angle = acos((sq(d_2)+sq(d_3)-sq(d_1))/(2*d_2*d_3));
      }
      else
      {
        angle = 2*PI - acos((sq(d_2)+sq(d_3)-sq(d_1))/(2*d_2*d_3));
      } 
    }
  }

  
}