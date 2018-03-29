// "Based on Daniel Shiffman's Youtube video CREATED BY: AKSHAY MAHAJAN MODED FOR CHRISTMAS BY: Robin Hädicke");

var snake, tree, tree2, tree3;

var anzahlKugeln = 10;
var winkugeln = 28;
var dimKugel = 35;
var Kugeln = [];
var Trees =[];

var deathtimer;
var interval=10000;

var old_touchX, old_touchY;

let snow = [];

function setup() {

    createCanvas(windowWidth, windowHeight);
		angleMode(DEGREES);
		frameRate(25);
  	dimKugel = windowWidth/50;

    snake = new Snake();
		tree = new Tree(windowWidth/2,dimKugel*2,dimKugel,winkugeln);
		tree2 = new Tree(windowWidth-dimKugel*3,windowHeight-(winkugeln*(dimKugel/2)),dimKugel/2,winkugeln);
		tree3 = new Tree(dimKugel*3,windowHeight-(winkugeln*(dimKugel/2)),dimKugel/2,winkugeln);

    if (snake.x > (windowWidth / 2))
        snake.set_dir(-1, 0);

		for (var i = 0; i < anzahlKugeln; i++) {
			var xpos = floor(random(dimKugel,floor(windowWidth - dimKugel)));
			var ypos = floor(random(dimKugel,floor(windowHeight - dimKugel)));
			Kugeln.push(new Kugel(xpos,ypos,dimKugel));
		}

		for (var i = 0; i < 400; i++) {
				snow[i] = new Snowflake();
		}
}

function draw() {
    background(51);
		stroke('PaleGoldenRod');
    fill('gold');
		strokeWeight(1);
    textStyle(NORMAL);
    textSize(windowWidth/50);
    text('Christbaumkugeln: ' + snake.score + ' / ' + winkugeln, 20, 30);

		for (var i = 0; i < Kugeln.length; i++) {
			for (var j = 0; j < Kugeln.length; j++) {
				if(i!=j){
					if (dist(Kugeln[i].x,Kugeln[i].y,Kugeln[j].x,Kugeln[j].y)<dimKugel) {
						var xpos = floor(random(dimKugel,floor(windowWidth - dimKugel)));
						var ypos = floor(random(dimKugel,floor(windowHeight - dimKugel)));
						Kugeln[i]= new Kugel(xpos,ypos,dimKugel);
						print("Collision");
					}
				}
			}
			Kugeln[i].display();
		}

    if (snake.die()) {
				deathtimer = millis();
        stroke('tomato');
        fill('tomato');
				textAlign(CENTER,CENTER);
        textSize(48);
        text('Nightmare before Christmas', windowWidth / 2, windowHeight / 2+100);
				textSize(36);
        text('Try Again', windowWidth / 2, windowHeight / 2+150);
				if(deathtimer+interval < millis()){
					//noLoop();
				}else {
					location.reload();
				}

    }else if (snake.win()) {
				tree.update();
		    tree.display();
				tree2.update();
				tree2.display();
				tree3.update();
				tree3.display();
        stroke('gold');
        fill('gold');
				strokeWeight(2);
        textSize(windowWidth/30);
				textAlign(CENTER,CENTER);
        text('MERRY CHRISTMAS AND A HAPPY NEW YEAR', windowWidth/2, windowHeight/2+dimKugel*8);
				textSize(windowWidth/40);
        text('FROM BENEDIKT AND ROBIN', windowWidth/2, windowHeight/2+dimKugel*10);
        noLoop();
    }else {
			snake.eat();
			snake.update();
	    snake.display();
    }

		for (var i = 0; i < snow.length; i++) {
				snow[i].update();
				snow[i].show();

				if (snow[i].dead()) {
						snow.splice(i,1); // entferne die Schneefloke, wenn sie geschmolzen ist
						snow.push(new Snowflake()); // erzeuge eine neue Schneefloke
				}
		}
		stroke('darkgreen');
		strokeWeight(8);
		noFill();
		rect(0,0,windowWidth,windowHeight);
}




///////////------------------------------USER-INPUT-----------------------/////

function keyPressed() {
    if ((keyCode === LEFT_ARROW && snake.xDir != 1 && snake.snakeLength != 0) || (keyCode === LEFT_ARROW && snake.snakeLength == 0)) {
        snake.set_dir(-1, 0);
    } else if ((keyCode === RIGHT_ARROW && snake.xDir != -1 && snake.snakeLength != 0) || (keyCode === RIGHT_ARROW && snake.snakeLength == 0)) {
        snake.set_dir(1, 0);
    } else if ((keyCode === UP_ARROW && snake.yDir != 1 && snake.snakeLength != 0) || (keyCode === UP_ARROW && snake.snakeLength == 0)) {
        snake.set_dir(0, -1);
    } else if ((keyCode === DOWN_ARROW && snake.yDir != -1 && snake.snakeLength != 0) || (keyCode === DOWN_ARROW && snake.snakeLength == 0)) {
        snake.set_dir(0, 1);
    }
    return false;
}

function touchStarted() {
    //console.log("started - > " + floor(touchX) + "," + floor(touchY));
    old_touchX = touchX;
    old_touchY = touchY;
    return false;
}

function touchMoved() {
    //to avoid browsers scroll  or drag behaviour
    return false;
}

function touchEnded() {
    // console.log(floor(touchX) + "," + floor(touchY));
    var x_diff = touchX - old_touchX;
    var y_diff = touchY - old_touchY;

    if (snake.xDir == 0) { //snake going up or down
        //console.log(x_diff);
        if (x_diff > 40)
            snake.set_dir(1, 0);
        else if (x_diff < -40)
            snake.set_dir(-1, 0);
    } else if (snake.yDir == 0) { //snake going left or right
        //console.log(y_diff);
        if (y_diff > 40)
            snake.set_dir(0, 1);
        else if (y_diff < -40)
            snake.set_dir(0, -1);
    }
    return false;
}
