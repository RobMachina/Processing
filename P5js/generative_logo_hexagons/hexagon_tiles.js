// Hexagon Class
//======================================
class Hex {

  constructor(x, y) {
    //position around center center is 1 around 2 outer 3
    this.x = x;
    this.y = y;
    this.check = false;
    // establish grid position
    this.pos = createVector(x, y);

    // establish pixel position
    this.pixelPos = createVector(0, 0);
    this.pixelPos.x = hexWidth * (1.5 * x + 0.5 + y % 2 * 0.75);
    this.pixelPos.y = hexHeight * (y * 0.5 + 0.5);

    this.active = false;

    this.neighbours = [];

    this.activecount = 0;

    this.letters = "PLAYFUL-ACTION*";
    this.letter = indexLogoArea(logoArea,[this.x,this.y]);

    this.strokeLetter = hexRadius/30;
    this.strokeHex = hexRadius/40;

  }

  initialiseNeighbours(x, y) {
		// initialise neighbours called after all hexagons are constructed
		// because otherwise the hexagons array isn't full yet
		// lots of conditionals to allow for edge hexagons

		// start with array of falses
    let n = [false, false, false, false, false, false];
    const odd = y%2;

    // above
    if (y >= 2) {
      n[0] = hexagons[x][y-2];
    }

    // top right
    if (y >= 1) {
      if (!odd || x < columns-1) {
        n[1] = hexagons[x+odd][y-1];
      }
    }

    // bottom right
    if (y < rows-1) {
      if (!odd || x < columns-1) {
        n[2] = hexagons[x+odd][y+1];
      }
    }

    // bottom
    if (y < rows-2) {
      n[3] = hexagons[x][y+2];
    }

    // bottom left
    if (y < rows-1) {
      if (odd || x >= 1) {
        n[4] = hexagons[x-1+odd][y+1];
      }
    }

    // top left
    if (y >= 1) {
      if (odd || x >= 1) {
        n[5] = hexagons[x-1+odd][y-1];
      }
    }

    this.neighbours = n;
  }

//Check if Hex is a Neighbour of a given HEX
  checkneighbour(x, y) {
    for (var i = 0; i < 6; i++) {
      if (this.neighbours[i] == hexagons[x][y]) {

        this.check = true;
      }
    }
  }

//Check how many Neighbours are active
  countActiveNeighbours() {
		// returns number of active neighbours
    this.activecount=0;
    for (let i = 0; i < 6; i++) {
      if (this.neighbours[i] && this.neighbours[i].active) {
        this.activecount++;
      }
    }
  }

  update() {
    this.activecount=0;
    for (let i = 0; i < 6; i++) {
      if (this.neighbours[i] && this.neighbours[i].active) {
        this.activecount++;
      }
    }
  }

  drawActiveEdge(mX,mY){
    stroke(colorlinesactive);
    strokeWeight(this.strokeHex);
    if (this.neighbours[0] && this.neighbours[0].active) {
      line(this.pixelPos.x-hexRadius/2,this.pixelPos.y-hexHeight/2,this.pixelPos.x+hexRadius/2,this.pixelPos.y-hexHeight/2);
    }

    if (this.neighbours[1] && this.neighbours[1].active) {
      line(this.pixelPos.x+hexRadius/2,this.pixelPos.y-hexHeight/2,this.pixelPos.x+hexRadius,this.pixelPos.y);
    }

    if (this.neighbours[2] && this.neighbours[2].active) {
      line(this.pixelPos.x+hexRadius,this.pixelPos.y,this.pixelPos.x+hexRadius/2,this.pixelPos.y+hexHeight/2);
    }

    if (this.neighbours[3] && this.neighbours[3].active) {
      line(this.pixelPos.x+hexRadius/2,this.pixelPos.y+hexHeight/2,this.pixelPos.x-hexRadius/2,this.pixelPos.y+hexHeight/2);
    }

    if (this.neighbours[4] && this.neighbours[4].active) {
      line(this.pixelPos.x-hexRadius/2,this.pixelPos.y+hexHeight/2,this.pixelPos.x-hexRadius,this.pixelPos.y);
    }

    if (this.neighbours[5] && this.neighbours[5].active) {
      line(this.pixelPos.x-hexRadius,this.pixelPos.y,this.pixelPos.x-hexRadius/2,this.pixelPos.y-hexHeight/2);
    }

    if (this.activecount>2) {
      push();
      textAlign(CENTER,CENTER);
      rotate(0*Math.PI/3);
      let write = this.letters.charAt(this.letter);
      if (write == "-") {
        write = "inter";
        fill(colorletters);
        noStroke();
        textSize(fontsize/3);
      } else if(this.activecount==6) {
        fill(colorletters);
        noStroke();
        textSize(fontsize);
      } else {
        noFill();
        stroke(colorletters);
        strokeWeight(this.strokeLetter);
        textSize(fontsize);
      }
      text(write,this.pixelPos.x,this.pixelPos.y);
      pop();
    } else {

    }

    if (dist(mX,mY,this.pixelPos.x,this.pixelPos.y)<hexRadius*2) {
      push();
      stroke(colorlines);
      noFill();
      strokeWeight(0.5);
  		drawHexagon(this.pixelPos);
      pop();
    }
  }

  drawHex() {

    if (this.activecount==6) {
      noStroke();
      fill(colorhex);
  		drawHexagon(this.pixelPos);
    }else {
      stroke(colorlines);
      noFill();
      strokeWeight(0.25);
  		drawHexagon(this.pixelPos);
    }
    /*textSize(22);
    text(this.x+","+this.y,this.pixelPos.x,this.pixelPos.y,30,30);*/
  }
}

// Helper Function
//======================================
function drawHexagon(pixelPos) {
  // draws hexagon with the center pixelPos
  push();
    translate(pixelPos.x, pixelPos.y);
    beginShape();
    for (let i = 0; i < 6; i++) {
      vertex((hexRadius-hexMargin/2)*cos(i*Math.PI/3), (hexRadius-hexMargin/2)*sin(i*Math.PI/3));
    }
    endShape(CLOSE);
  pop();
}
