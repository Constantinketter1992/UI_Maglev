//An on/off switch. When the ellipse is clicked it changes location. 

class CK_button_onOff
{
  PImage imgON_OFF = loadImage("button onoff.png");
  
  int x;
  int y;
  int w;
  int h;
  int d_x;
  
  boolean circleHover = false;
  boolean bToggle = false;
   
  //CONSTRUCTOR
  CK_button_onOff(int tx, int ty, int tw,int th, int td_x)
  {
     x = tx;
     y = ty;
     w = tw;
     h = th;
     d_x = td_x;
  }
  
  //FUNCTIONALITY
  void display()
  {
    checkHover();
    
    //image
    imageMode(CENTER);
    image(imgON_OFF,x,y);
    
    // check bClick
    if(bClick && circleHover) 
    {
      bToggle = !bToggle;
      click_sound.play();
    }
    // change position of button when toggled
    textAlign(CENTER);
    textFont(titleFont,20);
    if(!bToggle)
    {
      fill(#147534);
      stroke(palette[1]);
      ellipse(x-d_x,y,w,h);
      text("ON",x-5+d_x,y+7);
    }
    else
    {
      fill(palette[3]);
      ellipse(x+d_x,y,w,h);
      text("OFF",x+5-d_x,y+7);
    }
    
  }
  
  //check hover. The hover condition changes when the ellipse changes location (through the transform tool)
  void checkHover()
  {
    circleHover = false;
    //check mouse
    if(bToggle)
    {
    float disX = (x+d_x) - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < h/2 ) 
    {
      circleHover = true;
    }
    }
    if(!bToggle)
    {
    float disX = (x-d_x) - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < h/2 ) 
    {
      circleHover = true;
    }
    }
  }
  
}