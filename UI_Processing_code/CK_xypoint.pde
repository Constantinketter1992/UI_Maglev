//for tectonic movement display: drunken array
class CK_xypoint{
  
int x;
int y;
int s;

CK_xypoint(int tx, int ty, int ts){
  x = tx;
  y = ty;
  s = ts;
}

void updateY(){
  y = y + 10;
}
}