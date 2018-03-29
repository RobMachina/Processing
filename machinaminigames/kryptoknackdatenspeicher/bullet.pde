class Bullet {
  float x, y, speed;
  Bullet(float x, float y) {
    this.x = x;
    this.y = y;
    speed = 3;
  }

  void show() {
    pushStyle();
    noStroke();
    rectMode(CENTER);
    fill(255);
    rect(x, y, 2, 4);
    popStyle();
  }

  void move() {
    y-=speed;
  }
}

