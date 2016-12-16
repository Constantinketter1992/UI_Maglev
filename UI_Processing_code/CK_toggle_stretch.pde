class CK_toggle_stretch{
  int x;
  int y;
  int w;
  int h;
  
  int startw;
  int starth;
  
  int stretchw;
  int stretchh;
  
  int stretchval = 4;
  
  boolean bHover = false;
  boolean bToggle = false;
  
  CK_toggle_stretch(int tx, int ty, int tw, int th){
     x = tx;
     y = ty;
     w = tw;
     h = th;
     
     //
     startw = w;
     starth = h;
     
     stretchw = startw + 50;
     stretchh = h;
     }
     
  void display(){
    // set rectMode
    rectMode(RADIUS);
    // set hoverstate
    bHover = false;
    // check mouse - rectMode(
    if(mouseX > x - w
        && mouseX < x + w
        && mouseY > y - h
        && mouseY < y + h) bHover = true;
        
    // stretch/squash
    if(bToggle){
    if(w < stretchw) w = w+stretchval;
    if(h < stretchh) h = h+stretchval;
    }
    else {
    if(w > startw) w = w-stretchval;
    if(h > starth) h = h-stretchval;
    }
        
    // draw frame
    noFill();
    stroke(255);
    rect(x,y,w,h);
    
    // check bClick
    if(bClick && bHover) bToggle = !bToggle;
    /* // the same as:
    if(bClick && bHover){
     if(bToggle) bToggle = false;
     else bToggle = true;
    }
    */
    // draw lines when toggled
    if(bToggle || w > startw){
    fill(palette[5]);
    rect(x,y,w,h);
    }
    
    // end display - reset rectMode
    rectMode(CORNER);
  }
  
}