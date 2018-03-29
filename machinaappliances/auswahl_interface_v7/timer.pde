class timer
{
  float startTime;
  int tOver;
  
  timer(int millisecs)
  {
    startTime=millis();
    tOver=millisecs;
  }
  
  boolean over()
  {
    if ((millis() - startTime)>tOver)
    {
      return true;
    }
    else
      return false;
  }
  
  void reset()
  {
    startTime=millis();
  }
  
  void setOver(int millisecs)
  {
    tOver=millisecs;
    reset();
  }
  
  
}


void clockDot(float x, float y, float w, float h, float angle) {
  timerpict.pushMatrix();
  timerpict.translate(x, y);
  timerpict.rotate(radians(-angle));
  timerpict.rect(0, 0, w, h, w);
  timerpict.popMatrix();
}