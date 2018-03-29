// TriangleGrid Class
//======================================
class triangleGrid {

  constructor(x, y,px,py,dir,hex) {
    //position around center center is 1 around 2 outer 3
    this.x = x;
    this.y = y;
    // establish grid position
    this.pos = createVector(x, y);
    this.direction = dir;

    // establish pixel position
    this.posX = px;
    this.posY = py;

    this.active = false;
    this.hex = hex;

    this.neighbours = [];

    this.activecount = 0;

  }

  initialiseNeighbours(x, y) {
		// start with array of falses
    let n = [false, false, false, false];

    // above
    if (y >= 1) {
        n[0] = grid[x][y-1];
    }
    // right
      if (x < columns-1) {
          n[1] = grid[x+1][y];
      }
    // bottom
    if (y < rows-2) {
        n[2] = grid[x][y+2];
    }
    //left
      if (x >= 1) {
          n[3] = grid[x-1][y];
      }
    this.neighbours = n;
    //print(this.neighbours);
  }

  //Check if Hex is a Neighbour of a given HEX
  checkneighbour(x, y) {

  }

  //Check how many Neighbours are active
    countActiveNeighbours() {
      // returns number of active neighbours
      this.activecount=0;
      for (let i = 0; i < 3; i++) {
        if (this.neighbours[i] && this.neighbours[i].active) {
          this.activecount++;
        }
      }
      return this.activecount;
    }

    update(state) {
      this.hex = state;
    }

    draw() {

      push();
  		translate(this.posX, this.posY);

      if (this.direction == 'right'&& this.hex) {
        if( this.activecount == 3){
          fill(colorhexactivated);
          noStroke();
        }else {
          fill(colorhex);
          noStroke();
        }
        triangle(-radius/2, radius/2, -radius/2, -radius/2,radius/2, 0);
      }else if  (this.direction == 'left'&& this.hex) {
        if( this.activecount == 3){
          fill(colorhexactivated);
          noStroke();
        }else {
          fill(colorhex);
          noStroke();
        }
        triangle( -radius/2,0,radius/2,-radius/2,radius/2, radius/2);
      }else {

      }
      pop();
  }

drawMpos(mX,mY){
  if (dist(mX,mY,this.posX, this.posY)<radius/4) {
    push();
    fill(0);
    ellipse(this.posX, this.posY,radius/4,radius/4);
    pop();
    if (this.hex) {
      this.hex = false;
    }else {
      print('x: '+this.x,'y: '+this.y)
      this.hex = true;
    }
  }
}

  drawActiveEdge(){
    push();
    translate(this.posX, this.posY);
    stroke(colorlines);
    fill(colorlines);
    strokeWeight(strokesize);
    if (this.hex) {

    if  (this.direction == 'right'&& this.active) {
      if (this.neighbours[0] && this.neighbours[0].active) {
        line(-radius/2,-radius/2,radius/2,0);
        //ellipse(-radius/2,-radius/2,ellipsesize,ellipsesize);
      }
      if (this.neighbours[1] && this.neighbours[1].active) {
        ellipse(radius/2,0,ellipsesize,ellipsesize);
      }
      if (this.neighbours[2] && this.neighbours[2].active) {
        line(radius/2,0,-radius/2,radius/2);
        //ellipse(radius/2,0,ellipsesize,ellipsesize);
      }
      if (this.neighbours[3] && this.neighbours[3].active) {
        line(-radius/2,-radius/2,-radius/2,radius/2);
        //ellipse(-radius/2,radius/2,ellipsesize,ellipsesize);
      }
    }else if(this.active && this.direction == 'left') {
      if (this.neighbours[0] && this.neighbours[0].active) {
        line(-radius/2,0,radius/2,-radius/2);
        //ellipse(radius/2,-radius/2,ellipsesize,ellipsesize);
      }
      if (this.neighbours[1] && this.neighbours[1].active) {
        line(radius/2,-radius/2,radius/2,radius/2);
        //ellipse(radius/2,radius/2,ellipsesize,ellipsesize);
      }
      if (this.neighbours[2] && this.neighbours[2].active) {
        line(radius/2,radius/2,-radius/2,0);
        //ellipse(-radius/2,0,ellipsesize,ellipsesize);
      }
      if (this.neighbours[3] && this.neighbours[3].active) {
        ellipse(-radius/2,0,ellipsesize,ellipsesize);
      }
    }
    noStroke();
    fill('white');
    if  (this.direction == 'right'&& this.active) {
      if (this.neighbours[0] && this.neighbours[0].active) {
        ellipse(-radius/2,-radius/2,ellipsesize,ellipsesize);
      }
      if (this.neighbours[1] && this.neighbours[1].active) {
        ellipse(radius/2,0,ellipsesize,ellipsesize);
      }
      if (this.neighbours[2] && this.neighbours[2].active) {
        ellipse(radius/2,0,ellipsesize,ellipsesize);
      }
      if (this.neighbours[3] && this.neighbours[3].active) {
        ellipse(-radius/2,radius/2,ellipsesize,ellipsesize);
      }
    }else if(this.active && this.direction == 'left') {
      if (this.neighbours[0] && this.neighbours[0].active) {
        ellipse(radius/2,-radius/2,ellipsesize,ellipsesize);
      }
      if (this.neighbours[1] && this.neighbours[1].active) {
        ellipse(radius/2,radius/2,ellipsesize,ellipsesize);
      }
      if (this.neighbours[2] && this.neighbours[2].active) {
        ellipse(-radius/2,0,ellipsesize,ellipsesize);
      }
      if (this.neighbours[3] && this.neighbours[3].active) {
        ellipse(-radius/2,0,ellipsesize,ellipsesize);
      }
    }
  }
  pop();
}

}
// Helper Function
//======================================
