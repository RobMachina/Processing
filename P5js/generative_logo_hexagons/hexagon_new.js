// Sketch for a generative Logo for playfulinteraction.de
// based on a codepen by Charlotte Dann (Hexognal Generative Art)
// under devolpment by Robin Hädicke

// Variables
//======================================
//const hexRadius = 100;          // from center to one of the points
const hexLineWeight = 1;       // thickness of drawing line
const hexDoubleLineOffset = 1; // space between double lines
//const hexMargin = 12;           // space around hexagons
const drawHex = true;
const drawAgents = false;

let timer;

let hexRadius,hexMargin,hexHeight, hexWidth, columns, rows;
let hexagons = [];
let logoArea = [[1,2,"P"],[0,3,"L"],[0,5,"A"],[1,6,"Y"],[1,5,"F"],[1,3,"U"],[1,4,"L"],[2,4,"INTER"],[3,2,"A"],[2,3,"C"],[2,5,"T"],[3,6,"I"],[3,5,"O"],[3,3,"N"],[3,4,"*"]];

let fontsize;

let colorletters, colorlinesactive, colorlines, colorhex;

let agents = [];
let creatorCount = 4;
let destroyerCount = 1;

var canvas

//preload


//Colorconversion
function colorAlpha(aColor, alpha) {
  var c = color(aColor);
  return color('rgba(' +  [red(c), green(c), blue(c), alpha].join(',') + ')');
}

// Setup
//======================================

function setup() {
  // set up canvas
  canvas = createCanvas(window.innerWidth/2,window.innerHeight/2);
  //canvas.position(0, 0); //defined ins Style.css
  canvas.class("logo");

  colorletters = colorAlpha('#005960',1.0);
  colorlinesactive = colorAlpha('#578CA9',1.0);
  colorlines = colorAlpha('#898E8C',0.5);
  colorhex = colorAlpha('#005960',0.3);

  frameRate(60);
  timer = 1; //in seconds bound to framerate

  //Radius Hexagons
  hexRadius = Math.ceil((width/8)/2);//((window.innerWidth/6)/2)-window.innerWidth%6-((((window.innerWidth/6)/2)-window.innerWidth%6)/20);
  // calculate width and height of hexagons
  hexWidth = hexRadius * 2;
  hexHeight = (Math.sqrt(3)*hexRadius);
  hexMargin = hexRadius/20;
  fontsize = hexRadius - 5;

  textSize(fontsize);

  // set rows and columns to overlap page edge
  columns = Math.ceil(width / (hexRadius * 2));
  rows = Math.ceil(height / (hexHeight/2));

  // initialise 2D array of hexagons
  for (let x = 0; x < columns; x++) {
    hexagons.push([]);
    for (let y = 0; y < rows; y++) {
      hexagons[x].push(new Hex(x, y));
    }
  }

  for (let x = 0; x < columns; x++) {
    for (let y = 0; y < rows; y++) {
      hexagons[x][y].initialiseNeighbours(x, y);
    }
  }

  for (let x = 0; x < columns; x++) {
    for (let y = 0; y < rows; y++) {
      hexagons[x][y].checkneighbour(1, 3);
    }
  }

  for (let i = 0; i < creatorCount + destroyerCount; i++) {
    // randomly place near centre of screen
    let x = Math.round(columns * (0.3 + random(0.4)));//1;
    let y = Math.round(rows * (0.3 + random(0.4)));//3;
    let creator = (i < creatorCount) ? true : false;
    agents.push(new Agent(i, x, y, creator));
  }


  fill(255, 100);
  stroke(255);
  strokeWeight(2);

}


// Global Draw
//======================================

function draw() {

  if (frameCount % 5 == 0 && timer > 0) { // if the frameCount is divisible by 60, then a second has passed. it will stop at 0
    timer --;
  }
  if (timer == 0) {

    canvas.clear();
    //background(55);
    /*noFill();
    strokeWeight(hexRadius/40);
    stroke(colorlinesactive);
    rect(0,0,width,height);*/

    if (drawHex) {
      for (let x = 0; x < columns; x++) {
        for (let y = 0; y < rows; y++) {
          if (inLogoArea(logoArea,[x,y])) {
            hexagons[x][y].drawHex();
            hexagons[x][y].update();
            hexagons[x][y].drawActiveEdge(mouseX,mouseY);
          }
        }
      }
    }

    if (drawAgents){
      for (let i = 0; i < creatorCount + destroyerCount; i++) {
        agents[i].draw();
      }
    }
    for (let i = 0; i < creatorCount + destroyerCount; i++) {
      agents[i].update();
    }

    timer = 1;
  }
}

// Changed Browserwindow
//======================================
function windowResized() {
  location.reload();
}

//Support Functions
//======================================
function getEdgePos(i, offset) {
  // return position of this edge of the hexagon
  // if (offset == 1) clockwise from middle edge
  // if (offset == 0) middle of edge
  // if (offset == -1) anti-clockwise from middle edge
  var pos = createVector(offset*hexDoubleLineOffset*0.5, -hexHeight/2);
  pos.rotate(i*Math.PI/3);
  return pos;
}

function inLogoArea(source, search) {
  for (var i = 0, len = source.length; i < len; i++) {
      if (source[i][0] === search[0] && source[i][1] === search[1]) {
          return true;
      }
  }
  return false;
}

function indexLogoArea(source, search) {
  for (var i = 0, len = source.length; i < len; i++) {
      if (source[i][0] === search[0] && source[i][1] === search[1]) {
          return i;
      }
  }
  return -1;
}

function mouseClicked() {
  for (let x = 0; x < columns; x++) {
    for (let y = 0; y < rows; y++) {
      if (dist(mouseX,mouseY,hexagons[x][y].pixelPos.x,hexagons[x][y].pixelPos.y)<hexRadius-5) {
        if (inLogoArea(logoArea,[x,y])) {
          let i = indexLogoArea(logoArea,[x,y]);
          if (i >= 0) logoArea.splice(i, 1);
        }else {
          logoArea.push([x,y]);
        }

      }
    }
  }
  // prevent default
  return false;
}
