var canvas;

let dirX = 1;
let dirY = 1;

let paused = 1; // Enable pausing of the game.  Start paused
let heartbeat = 160;

var xBallPos, yBallPos, topPaddlePosX,topPaddlePosY, botPaddlePosX,botPaddlePosY; // position of ball and paddles
let radius, diameter, paddleWidth, paddleHeight,paddleStep,fontsize;

//TODO Flüssigere Regulation der Geschwindigkeit
let origSpeed = 10;
let speed = origSpeed; // Speed of the ball.  This increments as the game plays, to make it move faster
let speedInc = origSpeed / 15;
let ySpeed = 0; // Start the ball completely flat.  Position of impact on the paddle will determine reflection angle.

//Pong
let multiPress = 0; // Initial setting of key states, ie 0 = nothing pressed
let LEFTUP = 1; // Use bitwise 'or' to track multiple key presses
let LEFTDOWN = 2;
let RIGHTUP = 4;
let RIGHTDOWN = 8;

function setup() {
  // set up canvas
  canvas = createCanvas(window.innerWidth/2, window.innerHeight/2);
  //canvas.position(0, 0); //defined ins Style.css
  canvas.class("pong");

  background(0);
  smooth();
  noStroke();
  //stroke(120, 240, 40);
  //scoreFont = loadFont("OCRAStd-10.vlw"); // Score font
  //playerFont = loadFont("OCRAStd-10.vlw"); // Player font
  //frameRate(60);
  xBallPos = width / 2; // Start the ball in the centre
  yBallPos = height / 2;

	paddleWidth = width/15;
	paddleHeight = height/50;
	diameter = paddleWidth/6;
	radius = diameter/2;
	fontsize = height/40;

	topPaddlePosX = width - paddleWidth;
  botPaddlePosX = paddleWidth;
	topPaddlePosY =  paddleHeight*2;
	botPaddlePosY = height - paddleHeight*2;
	paddleStep = paddleWidth/4;

}

function draw() {
  rectMode(CORNER);
  fill(0,175); // Second argument can be added to create a slight motion blur when the ball moves.
  rect(0, 0, width, height);

	// The middle line or 'net'
  rectMode(CENTER);
  for (let i = 0; i < 17; i++) { // There should be an odd number of rects to make up the middle line
    if (i % 2 == 0) {
      fill(255);
    } else {
      fill(255, 0);
    }
    rect(i * width / 16, height / 2, width / 16, diameter); // The height of each is one less than the max number of iterations of 'for' loop as we are drawing rectMode(CENTER)
  }

  controlInput(multiPress);

  if (botPaddlePosX > width - paddleWidth/2) {
    botPaddlePosX = -paddleWidth/2;
  }

  if (topPaddlePosX > width) {
    topPaddlePosX = -paddleWidth/2;
  }

  // Show current heartbeat and hint
  textSize(fontsize*2);
  fill(120, 240, 40);
  text(heartbeat, width - textWidth(heartbeat+"")-10, height/2+(fontsize*3));
	textSize(fontsize);
  fill(120, 240, 40);
  text("Hz", width - textWidth(heartbeat+"")-5, height/2+(fontsize*4+5));
  textSize(fontsize);
  fill(120, 240, 40);
  text("catch the heartbeat with q + w and o +p", width - textWidth("catch the heartbeat with q + w and o +p")-10, height-fontsize*2);


  // Draw some paddles
  rectMode(CENTER);
  rect(topPaddlePosX, topPaddlePosY, paddleWidth, paddleHeight); // Left Paddle
  rect(botPaddlePosX, botPaddlePosY, paddleWidth, paddleHeight); // Right Paddle


  // Define the boundaries
  if (dist(xBallPos,yBallPos,botPaddlePosX,botPaddlePosY)<paddleWidth/2) { // test to see if it is touching right paddle
    dirY = -1; // Make the ball move from bottom to top
    ySpeed = (botPaddlePosX + xBallPos) / 220; // TODO Make position of impact on paddle determine deflection angle.
    speed -= speedInc;
		botPaddlePosY -=paddleHeight/2;
		topPaddlePosY +=paddleHeight/2;
    heartbeat -= 10;
  }

	if (dist(xBallPos,yBallPos,topPaddlePosX,topPaddlePosY)<paddleWidth/2){ // test to see if it is touching left paddle
    dirY = 1; // Make the ball move from left to right
    ySpeed = (topPaddlePosX + xBallPos) / 220; // TODO Make position of impact on paddle determine deflection angle.
    speed -= speedInc;
		topPaddlePosY +=paddleHeight/2; //TODO
		botPaddlePosY -=paddleHeight/2;
    heartbeat -= 10;
  }

  if ((yBallPos > height - diameter) || (yBallPos < diameter)) {
    dirY = -dirY;
    ySpeed = xBallPos / 220;
    speed = origSpeed;
    if (heartbeat < 250) {
      heartbeat += 10;
    }
		if (botPaddlePosY < height - paddleHeight*2) {
			botPaddlePosY +=paddleHeight/2;
		}
		if (topPaddlePosY > paddleHeight*2) {
			topPaddlePosY -=paddleHeight/2;
		}
  }
  if (xBallPos < radius) {
    dirX = -dirX;
    speed = origSpeed;
    if (heartbeat < 250) {
      heartbeat += 10;
    }
  }

  if (xBallPos > width) {
    xBallPos = 0 + diameter;
  }

  if (yBallPos > height + diameter*2) { // If the ball goes off the screen, reset it to the centre.
    speed = origSpeed;
    xBallPos = width / 2;
    ySpeed = random(-1., 1.);
    yBallPos = height / 2;
  }

  if (yBallPos < 0 - diameter*2) {
    speed = origSpeed;
    xBallPos = width / 2;
    ySpeed = random(-1., 1.);
    yBallPos = height / 2;
  }

  // Draw the ball
  fill(100, 200, 30);
  rect(xBallPos, yBallPos, diameter, diameter);

  // Draw the trace

  if (dirY == 1) {
    for (let i = 1; i < height / 10; i++) {
      fill(120, 240, 30, 255 - i * 5);
      rect(xBallPos - i, yBallPos - i * 10, diameter, diameter);
    }
  }
  if (dirY == -1) {
    for (let i = 1; i < height / 10; i++) {
      fill(120, 240, 30, 255 - i * 5);
      rect(xBallPos - i, yBallPos + i * 10, diameter, diameter);
    }
  }

  // Current ball position
  xBallPos = xBallPos + ySpeed * dirX;
  yBallPos = yBallPos + speed * dirY;
  if (heartbeat < 80) {
    // TODO Hier muss eine WinResultat rein
  }

}


//Input-Handling
//===========================================================================================

function controlInput(keyState){
	// Handle the possible multiple key presses
  switch (keyState) {
    case LEFTUP:
      if (topPaddlePosX >= paddleWidth/2) {
        topPaddlePosX -= paddleStep;
      }
      break;
    case LEFTDOWN:
      if (topPaddlePosX <= width) {
        topPaddlePosX += paddleStep;
      }
      break;
    case RIGHTUP:
      if (botPaddlePosX >= paddleWidth/2) {
        botPaddlePosX -= paddleStep;
      }
      break;
    case RIGHTDOWN:
      if (botPaddlePosX <= width) {
        botPaddlePosX += paddleStep;
      }
      break;
    case LEFTUP | RIGHTUP:
      if (topPaddlePosX >= paddleWidth/2) {
        topPaddlePosX -= paddleStep;
      }
      if (botPaddlePosX >= paddleWidth/2) {
        botPaddlePosX -= paddleStep;
      }
      break;
    case LEFTUP | RIGHTDOWN:
      if (topPaddlePosX >= paddleWidth/2) {
        topPaddlePosX -= paddleStep;
      }
      if (botPaddlePosX <= width) {
        botPaddlePosX += paddleStep;
      }
      break;
    case LEFTDOWN | RIGHTUP:
      if (topPaddlePosX <= width) {
        topPaddlePosX += paddleStep;
      }
      if (botPaddlePosX >= paddleWidth/2) {
        botPaddlePosX -= paddleStep;
      }
      break;
    case LEFTDOWN | RIGHTDOWN:
      if (topPaddlePosX <= width) {
        topPaddlePosX += paddleStep;
      }
      if (botPaddlePosX <= width) {
        botPaddlePosX += paddleStep;
      }
      break;
  }
}

function keyPressed() {
  switch (key) {
    case ('q'):
    case ('Q'):
      multiPress |= LEFTUP;
      break;
    case ('w'):
    case ('W'):
      multiPress |= LEFTDOWN;
      break;
    case ('o'):
    case ('O'):
      multiPress |= RIGHTUP;
      break;
    case ('p'):
    case ('P'):
      multiPress |= RIGHTDOWN;
      break;
  }
}

function keyReleased() {
  switch (key) {
    case ('q'):
    case ('Q'):
      multiPress ^= LEFTUP;
      break;
    case ('w'):
    case ('W'):
      multiPress ^= LEFTDOWN;
      break;
    case ('o'):
    case ('O'):
      multiPress ^= RIGHTUP;
      break;
    case ('p'):
    case ('P'):
      multiPress ^= RIGHTDOWN;
      break;
  }
}
