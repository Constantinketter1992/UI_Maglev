//elliptical toggle. When clicked ellipse fills a color. 

class CK_circle_toggle
{
  int x;
  int y;
  int w;
  int h;
  String var;
  
  boolean boxHover = false;
  boolean bToggle = false;
  boolean box_button;
  
  //CONSTRUCTOR
  CK_circle_toggle(int tx, int ty, int tw, int th, String tvar)
  {
     x = tx;
     y = ty;
     w = tw;
     h = th;
     var = tvar;
  }
  
  //FUNCTIONALITY
  void display()
  {
    //boxHover = false;

    
    //draw ellipse
    fill(palette[2]);
    stroke(palette[1]);
    ellipse(x,y,w,h);
    
   //draw text vertically next to ellipse
    pushMatrix();
    translate(x,y);
    rotate(-PI/2);
    fill(palette[3]);
    textFont(titleFont, 12);
    textAlign(CENTER);
    text(var,0,-24);
    popMatrix();
    
    // check bClick
    if(bClick && boxHover) 
    {
      bToggle = !bToggle;
      //clicking sound
      click_sound.play();
    }
    
    // if toggled ellipse is filled
    if(bToggle || box_button)
    {
      fill(#fff900);
      ellipse(x,y,w-10,h-10);
    }
    
    
    box_button =false; 
    boxHover = false;
    // end display
  }
  
  //whether ellipse is toggled or not changes the condition
  void onOffBox ()
  {
    box_button = !box_button;
  }
  void autopilotOff()
  {
        // check mouse
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < h/2 ) 
    {
      boxHover = true;
    }
  }
}