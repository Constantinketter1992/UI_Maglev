//simple rectangular toggle
class CK_toggle_square_simple{
  int x;
  int y;
  int w;
  int h;
  
  boolean bHover = false;
  boolean bToggle = false;
  

  
  CK_toggle_square_simple(int tx, int ty, int tw, int th){
     x = tx;
     y = ty;
     w = tw;
     h = th;
     }
     
  void display(){
    bHover = false;
    bToggle = false;
    // check mouse
    if(mouseX > x 
        && mouseX < x + w
        && mouseY > y
        && mouseY < y + h) bHover = true;
        
    // draw frame
    noFill();
    stroke(palette[2],1);
    strokeWeight(1);
    rect(x,y,w,h);
    
    // check bClick
    if(bClick && bHover){
    bToggle = true;
    click_sound.play(); //clicking sound
    }
    // end display
  }
}