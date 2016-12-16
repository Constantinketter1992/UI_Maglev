//navigation system. Showing maglev's location relative to the location of departure and destination. 

class CK_navigation{
  int x;
  float y;
  int w;
  int h;
  
  float xspeed;
  
  boolean bHover = false;
  boolean bToggle = false;
  
  CK_navigation(int tx, float ty, int tw, int th, float txspeed){
     x = tx;
     y = ty;
     w = tw;
     h = th;
     
     xspeed = txspeed;
     }
     
  void display(){
    bHover = false;
    // check mouse
    if(mouseX > x 
        && mouseX < x + w
        && mouseY > y
        && mouseY < y + h) bHover = true;
        
    // draw frame
    fill(palette[2]);
    stroke(palette[1]);
    ellipse(x,y,w,h);
    
    // check bClick
    //if(bClick && bHover) bToggle = !bToggle;
    /* // the same as:
    if(bClick && bHover){
     if(bToggle) bToggle = false;
     else bToggle = true;
    }
    */
    // draw lines when toggled
    //if(bToggle){
    //line(x,y,x+w,y+h);
    //line(x,y+h,x+w,y);
    //}
    

    
    // end display
  }
  
  void updatePosition(){
    // update pos
    y = y+xspeed;
    if(y > 580) y = 60;
  }
  
}