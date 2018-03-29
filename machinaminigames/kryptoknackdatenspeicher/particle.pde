class Particle {
  float r, x, y;
  color c;
  Particle(float x, float y, color c) {
    this.x = x;
    this.y = y;
    r = random(5);
    this.c = c;
  }

  void display() {
    noStroke();
    fill(c);
    ellipse(x, y, r, r);
  }

  void move() {
    r-=0.1;
  }
}


