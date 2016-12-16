//A draggable map with dynamic data. Based on https://processing.org/examples/mousefunctions.html

class CK_map {
 
  int x,y,w,h;
  PGraphics mapDynamic;
  int x_drag;   
  int y_drag;
  int x_draw = w/2; 
  int y_draw = h/2; 
  boolean locked = false; 
  PImage imgMap;
  PImage imgHyperLoop;
  PImage imgThunder;
  
  int m_x = w/2;
  int m_y = h/2;
  int m_x_drag;
  int m_y_drag;
  int m_speed = 1;
  float[] randomEllipses= new float[60];
  
  //CONSTRUCTOR
  CK_map(int tX, int tY, int tW, int tH)
  {
    x = tX;
    y = tY;
    w = tW;
    h = tH;
    
    mapDynamic = createGraphics(w, h);
    imgMap = loadImage("Mediterranean.png"); //https://commons.wikimedia.org/wiki/File:Mediterranean_Sea_Bathymetry_map.svg
    imgHyperLoop = loadImage("hyperloop.png");
    imgThunder = loadImage("thunder.png");
    
    for(int i = 0; i<60 ; i++)
    {
      float randomN = random(-500,500);
      randomEllipses[i] = randomN;
    }
    
  }
  
  
  //FUNCTIONALITY
  void display()
  {
    //DRAW MAP
    mapDynamic.beginDraw();
    mapDynamic.background(palette[0]);
    mapDynamic.imageMode(CENTER);
    mapDynamic.image(imgMap, x_draw, y_draw);
    //draw moving ellipse
    //mapDynamic.ellipse(m_x,m_y+50,20,30);
    mapDynamic.image(imgHyperLoop,m_x,m_y+55,100,118);
    for(int i=0;i<30;i++)
    {
    ellipseMode(CENTER);
    mapDynamic.fill(palette[2],150);
    //float x_random = noise(-50,50);
    //float y_random = noise(-50,50);
    mapDynamic.imageMode(CORNER);
    mapDynamic.image(imgThunder,x_draw+randomEllipses[i],y_draw+randomEllipses[i+1],20,20);
    mapDynamic.ellipse(x_draw+(50*i)-2*w,y_draw+(50*i)-2*h,20,20);
    int x1 = x_draw+(50*i)-2*w;
    int y1 = y_draw+(50*i)-2*h;
    //hover state
    float disX = x1+x - mouseX;
    float disY = y1+y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < 20/2 ) 
    {
    mapDynamic.fill(palette[1],200);
    mapDynamic.ellipse(x_draw+(50*i)-2*w,y_draw+(50*i)-2*h,30,30);
    mapDynamic.textSize(12);
    mapDynamic.fill(palette[2],200);
    mapDynamic.noStroke();
    mapDynamic.rect(x_draw+(50*i)+25-2*w,y_draw+(50*i)-40-2*h,240,78);
    mapDynamic.fill(palette[1]);
    mapDynamic.text(map_data[i],x_draw+(50*i)+30-2*w,y_draw+(50*i)-25-2*h);
    }
    if(mouseX > x+x_draw+randomEllipses[i]
        && mouseX < x+x_draw+randomEllipses[i]+20
        && mouseY > y+y_draw+randomEllipses[i+1]
        && mouseY < y+y_draw+randomEllipses[i+1]+20)
    {
      mapDynamic.fill(palette[2],200);
      mapDynamic.noStroke();
      mapDynamic.rect(x_draw+randomEllipses[i]+50,y_draw+randomEllipses[i+1],130,11);
      mapDynamic.image(imgThunder,x_draw+randomEllipses[i],y_draw+randomEllipses[i+1],30,30);
      mapDynamic.fill(palette[1]);
      mapDynamic.text(map_data2[i],x_draw+randomEllipses[i]+50,y_draw+randomEllipses[i+1]+10);
    }
    mapDynamic.stroke(0);
    }
    mapDynamic.endDraw();
    imageMode(CORNER);
    image(mapDynamic, x, y, w, h);
  }
  
  // UPDATE POSITION
    void updatePosition(){
    // update pos
    m_x = m_x+m_speed;
    m_y = m_y+m_speed;
    imageMode(CENTER);
    if(m_x > x+w || m_y > y+h)
    {
      m_x -= 300;
      m_y -= 300;
    }
  }
}