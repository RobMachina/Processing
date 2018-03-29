class Poly {

  int posX;
  float posY;
  float speed;
  int kind;
  color c=color(255);
  float rotation;
  boolean isdead = false;

  Poly(int _posX, float _posY, float _speed, int _kind) {
    posX = _posX;
    posY = _posY;
    speed = _speed;
    kind = _kind;
    rotation = 0;
  }

  // move poly further down
  void update() {
    posY+= speed;
  }

  // rotate Poly around its center
  void rotatePoly(int rotateSpeed) {
    rotation += TWO_PI/rotateSpeed;
  }

  void setSpeed(float _speed) {
    speed = _speed;
  }

  void show() {
    if (!isdead) {
      pushMatrix();
      translate(posX, posY);
      rotate(rotation);
      shapeMode(CENTER);
      shape(shape[kind], 0, 0, 40, 40);
      popMatrix();
    }
  }

  void changeColor(color _c) {
    c = _c;
  }

  void setKind(int _kind) {
    kind = _kind;
  }
}    

