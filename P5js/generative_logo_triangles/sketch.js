  //Variables
  //==============================================

  var canvas;
  let fontsize;
  let colorletters, colorlines, colorhex,colorhexactivated;

  let strokesize,ellipsesize;

  let radius;
  let x, y;
  let prevX, prevY;
  let columns, rows;

  let grid = [];
  let agents = [];

  let creatorCount = 12;
  let destroyerCount = 2;

  let logoArea =[[3,8],[3,10],[3,12],[4,5],[4,6],[4,7],[4,8],[4,9],[4,10],[4,11],[4,12],[4,14],[5,5],[5,6],[5,7],[5,8],[5,9],[5,11],[5,12],[5,14],[6,3],[6,5],[6,6],[6,8],[6,11],[6,12],[6,13],[6,14],[7,3],[7,5],[7,6],[7,8],[7,10],[7,11],[7,12],[7,13],[7,14],[8,5],[8,7],[8,8],[8,9],[8,10],[8,11],[8,12],[9,5],[9,7],[9,9],[9,11]];
  /*[[4,8],[4,10],[4,12],[5,7],[5,8],[5,9],[5,10],[5,12],[6,5],[6,7],[6,8],[6,9],[6,10],[6,11],[6,12],[7,5],[7,7],[7,8],[7,9],[7,10],[7,11],[7,12],[8,7],[8,9]]; - klein voll*/
  /*[[3,8],[3,10],[3,12],[4,5],[4,6],[4,7],[4,8],[4,9],[4,10],[4,11],[4,12],[4,14],[5,5],[5,6],[5,7],[5,8],[5,9],[5,10],[5,11],[5,12],[5,14],[6,3],[6,5],[6,6],[6,7],[6,8],[6,9],[6,10],[6,11],[6,12],[6,13],[6,14],[7,3],[7,5],[7,6],[7,7],[7,8],[7,9],[7,10],[7,11],[7,12],[7,13],[7,14],[8,5],[8,7],[8,8],[8,9],[8,10],[8,11],[8,12],[9,5],[9,7],[9,9],[9,11]]; -groß voll*/

  //setup
  //===============================================
  function setup() {
    // set up canvas
    canvas = createCanvas(window.innerWidth / 2, window.innerHeight / 2);
    //canvas.position(0, 0); //defined ins Style.css
    canvas.class("logo");
    radius = (width/2)/8;
    ellipsesize = radius/10;
    strokesize = radius/30;

    colorletters = colorAlpha('#005960', 0.4);
    colorlines = colorAlpha('#898E8C', 0.8);
    colorhex = colorAlpha('#7ac1fa', 0.4);
    colorhexactivated = colorAlpha('#7ac1fa', 1.0);

    frameRate(60);
    timer = 1; //in seconds bound to framerate

    x = width / 2;
    y = height / 2;
    prevX = x;
    prevY = y;

    columns = Math.ceil(width / (radius)) + 2;
    rows = Math.ceil(height / (radius/2)) + 2;

    for (let i = 0; i < columns; i++) {
      grid.push([]);
      for (let j = 0; j < rows; j++) {
        if (i % 2 == 0) { //jedes zweite Dreieck umdrehen
          if (j % 2 == 0) {
            grid[i].push(new triangleGrid(i, j, 0 + (i * (radius)) + radius, 0 + j * (radius/2) - radius,'left',false));  //jede zweite Reihe ein Feld nach rechts oben verrücken
          }else {
            grid[i].push(new triangleGrid(i, j, 0 + i * (radius), 0 + j * (radius/2), 'left',false));
                  //Reihe normal Links
          }
        } else {
          if (j % 2 == 0) {
            grid[i].push(new triangleGrid(i, j, 0 + (i * (radius)) + radius, 0 + j * (radius/2) - radius, 'right',false));
          }else {
            grid[i].push(new triangleGrid(i, j, 0 + i * (radius), 0 + j * (radius/2), 'right',false));
          }
        }
      }
    }

    for (let x = 0; x < columns; x++) {
      for (let y = 0; y < rows; y++) {
        grid[x][y].initialiseNeighbours(x, y);
          if (inLogoArea(logoArea,[x,y])) {
            grid[x][y].update(true);
          }
      }
    }

    for (let i = 0; i < creatorCount + destroyerCount; i++) {
      // randomly place near centre of screen
      let x = 6;//Math.round(columns * (0.3 + random(0.4))); //1;
      let y = 9;//Math.round(rows * (0.3 + random(0.4))); //3;
      let creator = (i < creatorCount) ? true : false;
      agents.push(new Agent(i, x, y, creator));
    }

  }

  //Draw
  //=============================================================

  function draw() {

    if (frameCount % 15 == 0 && timer > 0) { // if the frameCount is divisible by 60, then a second has passed. it will stop at 0
      timer--;
    }
    if (timer == 0) {
      canvas.clear();

      for (let i = 0; i < columns; i++) {
        for (let j = 0; j < rows; j++) {
            grid[i][j].drawActiveEdge();
            grid[i][j].draw();
        }
      }
      for (let i = 0; i < creatorCount + destroyerCount; i++) {
        agents[i].update();
        //agents[i].draw();
      }
      for (let i = 0; i < columns; i++) {
        for (let j = 0; j < rows; j++) {
            grid[i][j].  countActiveNeighbours();
        }
      }
    }
    timer = 1;
  }

  //Helper
  //=============================================================

  //Colorconversion
  function colorAlpha(aColor, alpha) {
    var c = color(aColor);
    return color('rgba(' + [red(c), green(c), blue(c), alpha].join(',') + ')');
  }

//Mouse Grid Select
function mouseClicked( ){
  for (let i = 0; i < columns; i++) {
    for (let j = 0; j < rows; j++) {
      grid[i][j].drawMpos(mouseX,mouseY);
      // prevent default
    }
  }
  //return false;
}

//Logo Area in Grid
function inLogoArea(source, search) {
  for (var i = 0, len = source.length; i < len; i++) {
      if (source[i][0] === search[0] && source[i][1] === search[1]) {
          return true;
      }
  }
  return false;
}

// Changed Browserwindow
//======================================
function windowResized() {
  location.reload();
}
