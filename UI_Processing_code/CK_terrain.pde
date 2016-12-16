class CK_terrain{
// instance variables
float x;
float y;
float ox;
float oy;

float xs = random(4)-2;
float ys = random(4)-2;

int nSize;

boolean tectonicDisplay = false;



// constructor
  CK_terrain(float tempX, float tempY){
  x = tempX;
  y = tempY;
  ox = x;
  oy = y;
  }

// functions
  void drawNode(){
    if (y<450)
    {
    x = x + 0.5*xs;
    y = y +ys;
    }
    else
    {
      x = x + 0.25*xs;
      y = y +0.5*ys;
    }
    
    //ys = ys+y/height;
    
    // reverse direction?
    // x
    if(x - ox > 4) {
      x = ox + 4;
      xs = xs * -1;
    }
    if(x - ox < -4) {
      x = ox - 4;
      xs = xs * -1;
    }
    // y
    if(y - oy > 4) {
      y = oy + 4;
      ys = ys * -1;
    }
    if(y - oy < -4) {
      y = oy - 4;
      ys = ys * -1;
    }
    
    noStroke();
    fill(palette[1]);
    ellipse(x,y,nSize,nSize);
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < 10 && clicked) 
    {
      tectonicDisplay = !tectonicDisplay;
    }
    if(tectonicDisplay)
    {
      nSize = 15;
    }
    else
    {
      nSize = 5;
    }
    
  }
  
}