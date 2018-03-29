// Agent Class
//======================================

class Agent {

  constructor(i, x, y, creator) {
    this.i = i;
    this.x = x;
    this.y = y;

    // set random direction 0-5
    this.dir = Math.floor(random(0, 6));

    // set its morality
    this.creator = creator;
  }

  draw() {
    noStroke();
    if (this.creator) {
      fill(255, 30);
    } else {
      fill(255, 0, 100, 40);
    }
    // grab pixel position from corresponding hexagon
    drawHexagon(hexagons[this.x][this.y].pixelPos);
  }

  update() {
    // get current hexagon by x, y
    var curHex = hexagons[this.x][this.y];

    // increment or decrement activity
    // if creator and not double active
    if (this.creator) {
      if (!curHex.active) {
        curHex.active = true;
      }
    }
    // if destroyer and active
    else {
      if (curHex.active) {
        curHex.active = false;
      }
    }

    // randomly chose direction -1 to 1
    this.dir += -1 + Math.floor(random(3));
    // make direction wrap around 0-5
    this.dir = wrap6(this.dir);

    // get next hexagon from current's neighbours
    var nextHex = curHex.neighbours[this.dir];

    // if next hexagon doesn't exist turn around
    if (nextHex === false) {
      this.dir = wrap6(this.dir + 3);
      nextHex = curHex.neighbours[this.dir];
      // if that doesn't work it's a corner
      // return and try again next round
      if (nextHex === false) return;
    }

    // update x and y from next hexagon
    this.x = nextHex.pos.x;
    this.y = nextHex.pos.y;
  }
}

function wrap6(num) {
  // -1 => 5
  // 0 => 0
  // 5 => 5
  // 6 => 0
  // 7 => 1
  return (num+6) % 6;
}
