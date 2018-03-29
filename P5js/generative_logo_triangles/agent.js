// Agent Class
//======================================

class Agent {

  constructor(i, x, y, creator) {
    this.i = i;
    this.x = x;
    this.y = y;
    this.Xpos, this.Ypos;

    // set random direction 0-5
    this.dir = Math.floor(random(0, 6));

    // set its morality
    this.creator = creator;
  }

    update() {

      // get current triangle by x, y
      var curTriangle = grid[this.x][this.y];

      this.Xpos = curTriangle.posX;
      this.Ypos = curTriangle.posY;

      // increment or decrement activity
      // if creator and not double active
      if (this.creator) {
        if (!curTriangle.active) {
          curTriangle.active = true;
        }
      }
      // if destroyer and active
      else {
        if (curTriangle.active) {
          curTriangle.active = false;
        }
      }

      // randomly chose direction -1 to 1
      this.dir += -1 + Math.floor(random(4));
      // make direction wrap around 0-5
      this.dir = wrap3(this.dir);


      // get next triangle from current's neighbours
      var nextTriangle = curTriangle.neighbours[this.dir];

      // if next triangle doesn't exist turn around
      if (nextTriangle  === false) {
        this.dir = wrap3(this.dir+1);
        nextTriangle = curTriangle.neighbours[this.dir];
        // if that doesn't work it's a corner
        // return and try again next round
        if (nextTriangle === false) return;
      }

      // update x and y from next triangle
      this.x = nextTriangle.pos.x;
      this.y = nextTriangle.pos.y;
  }

  draw() {
    if(!this.creator){
      fill('darkred');
    }else {
      fill('azure');
    }
    ellipse(this.Xpos,this.Ypos,radius/6,radius/6);
    }

}

function wrap3(num) {
  // -1 => 5
  // 0 => 0
  // 5 => 5
  // 6 => 0
  // 7 => 1
  return (num+4) % 4;
}
