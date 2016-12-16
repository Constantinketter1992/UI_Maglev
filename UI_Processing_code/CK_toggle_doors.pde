//dynamic toggle for doors. When toggled => stretches/shrinks 

class CK_toggle_doors{
  int x, x2;
  int y;
  float h, w;
  
  float startw;
  float stretchw;
  float stretchval;
  int stretch_difference;
  
  boolean bHover = false;
  boolean hover = false;
  boolean bToggle = false;
  boolean openAll = false;
  
  CK_toggle_doors(int tx,int tx2, int ty, int tw, int th, int tstretch_difference, float tstretchval){
     x = tx;
     x2 = tx2;
     y = ty;
     w = tw;
     h = th;
     stretch_difference = tstretch_difference;
     stretchval = tstretchval;
     
     //
     startw = w;
     stretchw = startw + stretch_difference;
     }
     
  void display(){
    // stretch/squash
    if(!bToggle){
    if(w < stretchw) w = w+stretchval;
    //if(h < stretchh) h = h+stretchval;
    }
    else {
    if(w > startw) w = w-stretchval;
    //if(h > starth) h = h-stretchval;
    }
        
    // draw frame
    fill(palette[5]);
    stroke(palette[1]);
    rect(x,y,w,h);
    rectMode(CORNERS);
    rect(x2,y,x2-w,y+h);
    
    // check bClick
    if(bClick && bHover) 
    {
      bToggle = !bToggle;
    }
   
    /* // the same as:
    if(bClick && bHover){
     if(bToggle) bToggle = false;
     else bToggle = true;
    }
    */
    // draw lines when toggled
    if(!bToggle || w > startw){
    fill(palette[2]);
    noStroke();
    rect(x2,y,x2-w,y+h);
    rectMode(CORNER);
    rect(x,y,w,h);
    }
    rectMode(CORNER);
    fill(palette[5]);
    
    //clicking sound
    if(hover && clicked) {
      //bToggle = !bToggle;
      click_sound.play();
      }
    
    bHover=false;
    hover = false;
    
  }
  
  void check_clearance()
  {
    if(mouseX > x
        && mouseX < x2
        && mouseY > y
        && mouseY < y + h) 
    {
      bHover = true; 
      hover = true; //hover for clicking condition
    }
  }
  void open_all()
  {
    bToggle=true;
    bHover = true;
  }

}