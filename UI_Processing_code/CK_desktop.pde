//flashing elliptical toggle. When clicked flashing stops and ellipse is filled. 

class CK_desktop
{
  int x;
  int y;
  int w;
  int h;
  String var;
  
  boolean circleHover = false;
  boolean bToggle = false;
  
  boolean bFlash = true;
  int intvl;
  int savedMillis = 0;
  //starting from 0
  //if millis() > intvl + savedMillis change state of bFlash
  //when we change state update savedMillis


  //CONSTRUCTOR
  CK_desktop(int tx, int ty, int tw,int th, int tintvl,String tvar)
  {
    x = tx;
    y = ty;
    w = tw;
    h = th;
    intvl = tintvl;
    var = tvar;
  }
  
  //FUNCTIONALITY
  void display()
  {
    circleHover = false;
    checkHover();
    //draw outer circle
    noFill();
    stroke(palette[1]);
    ellipseMode(CENTER);
    ellipse(x,y,w,h);
    
    //draw text
    fill(palette[1]);
    textAlign(CORNER);
    textSize(30);
    text(var, x+30, y+10);
    
    //draw flashing circle
    checkMillis();
    if(bFlash && !bToggle)
    {
      fill(palette[1]);
      stroke(palette[1]);
      ellipseMode(CENTER);
      ellipse(x,y,w-10,h-10);
    }
    // check bClick
    if(bClick && circleHover) bToggle = !bToggle;
    
    //draw blue circle when toggled 
    check_toggle();
    
  } 
  //end of display
  
  //hovering condition 
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
  
  //flashing
  void checkMillis()
  {
  if(millis() > savedMillis + intvl)
  {
    //flip flop bFlash boolean 
    bFlash = !bFlash;
    savedMillis = millis();
  }
  }
 
  //when ellipse clicked - flashing stops and ellipse is filled with color 
  void check_toggle()
  {
   if (bToggle)
   {
      fill(palette[2]);
      ellipseMode(CENTER);
      ellipse(x,y,w-10,h-10);
   }
  }
}