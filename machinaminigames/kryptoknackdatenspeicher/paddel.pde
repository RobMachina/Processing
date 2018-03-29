class Paddel {
  public float x;
  private int y;
  
  Paddel(int _x, int _y) {
    x = _x;
    y = _y;
  }

  void show() {
    strokeWeight(3);
    stroke(0);
    line(x-10,y,x+10,y); 
  }
}

