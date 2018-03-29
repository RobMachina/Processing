function Snake() {
    this.x = (floor(random(floor((windowWidth - dimKugel) / dimKugel)))) * dimKugel;
    this.y = (floor(random(floor((windowHeight - dimKugel) / dimKugel)))) * dimKugel;
    this.xDir = 1;
    this.yDir = 0;
    this.speed = 0.15;
    this.speedinc = 0.015;
    this.score = 0;
    this.snakeLength = 0;
    this.tail = [];
    this.eatenFillColor= 'dimgray';
    this.eatenStrokeColor= 'gray';

    this.display = function() {
        var offset;
        fill(this.eatenFillColor);
        stroke(this.eatenStrokeColor);
        ellipseMode(CENTER);
        //for the tail
        for (var i = 0; i < this.tail.length; i++) {
          ellipse(this.tail[i].x, this.tail[i].y, dimKugel, dimKugel);
          /*pop();
          fill(255,50);
          arc(this.tail[i].x,this.tail[i].y, dimKugel,dimKugel, 230, 30, CLOSE);
          push();*/
        }

        //for the head
        ellipse(this.x, this.y, dimKugel, dimKugel);
        //for the eyes
        if (this.yDir == 0){

            if (this.xDir == 1){
                push();
                  fill('black');
                  stroke('white');
                  ellipse(this.x+dimKugel/4, this.y+dimKugel/4, dimKugel/10, dimKugel/10);
                  ellipse(this.x+dimKugel/4, this.y-dimKugel/4, dimKugel/10, dimKugel/10);
                  fill('darkred');
                  stroke('black');
                  ellipse(this.x+dimKugel/2-dimKugel/9, this.y, dimKugel/9, dimKugel/9);
                pop();
            }
            else{
                push();
                  fill('black');
                  stroke('white');
                  ellipse(this.x-dimKugel/4, this.y+dimKugel/4, dimKugel/10, dimKugel/10);
                  ellipse(this.x-dimKugel/4, this.y-dimKugel/4, dimKugel/10, dimKugel/10);
                  fill('darkred');
                  stroke('black');
                  ellipse(this.x-dimKugel/2+dimKugel/9, this.y, dimKugel/9, dimKugel/9);
                pop();
            }
        }
        else if (this.xDir == 0){

            if (this.yDir == 1){
                push();
                  fill('black');
                  stroke('white');
                  ellipse(this.x+dimKugel/4, this.y+dimKugel/4, dimKugel/10, dimKugel/10);
                  ellipse(this.x-dimKugel/4, this.y+dimKugel/4, dimKugel/10, dimKugel/10);
                  fill('darkred');
                  stroke('black');
                  ellipse(this.x, this.y+dimKugel/2-dimKugel/9, dimKugel/9, dimKugel/9);
                pop();
            }
            else{
                push();
                  fill('black');
                  stroke('white');
                  ellipse(this.x+dimKugel/4, this.y-dimKugel/4, dimKugel/10, dimKugel/10);
                  ellipse(this.x-dimKugel/4, this.y-dimKugel/4, dimKugel/10, dimKugel/10);
                  fill('darkred');
                  stroke('black');
                  ellipse(this.x, this.y-dimKugel/2+dimKugel/9, dimKugel/9, dimKugel/9);
                pop();
            }
        }
    };
    this.update = function() {

        if (this.snakeLength === this.tail.length) {
          for (var i = 0; i < this.tail.length-1; i++) {
              this.tail[i] = this.tail[i + 1];
          }
        }
        this.tail[this.snakeLength - 1] = createVector(this.x, this.y);

        this.x += this.xDir * (dimKugel*this.speed);
        this.y += this.yDir * (dimKugel*this.speed);

        //put constraint
        this.x = constrain(this.x, 0, windowWidth - 20);
        this.y = constrain(this.y, 0, windowHeight - 20);
    };
    this.set_dir = function(x, y) {
        this.xDir = x;
        this.yDir = y;
    };
    this.eat = function() {
        for (var i = 0; i < Kugeln.length; i++) {
            var d = dist(this.x, this.y, Kugeln[i].x, Kugeln[i].y);

            if (d < dimKugel/2) {
                this.snakeLength++;
                this.score += 1;
                this.eatenStrokeColor = Kugeln[i].strokecolor;
                this.eatenFillColor = Kugeln[i].fillcolor;
                this.speed =this.speed+this.speedinc;

                Kugeln.splice(i,1); //Kugel aus Array entfernen

                //Neue Kugel zu Array hinzufügen
                var xpos = floor(random(dimKugel,floor(windowWidth - dimKugel)));
          			var ypos = floor(random(dimKugel,floor(windowHeight - dimKugel)));
                Kugeln.push(new Kugel(xpos,ypos,dimKugel));
            }
        }
    };
    this.die = function() {
        if (this.tail.length == 0) {
            if (this.x >= windowWidth - 20 || this.y >= windowHeight - 20 || this.x <= 0 || this.y <= 0)
                return true;
        } else if (this.tail.length != 0) {
            for (var i = 0; i < this.tail.length; i++) {
                var pos = this.tail[i];
                var d = dist(this.x, this.y, pos.x, pos.y);
                if (d < 0.1) {
                    this.score = 0;
                    this.total = 0;
                    this.speed = 4;
                    this.tail = [];
                    return true;
                }
            }
        } else {
            return false;
        }
    };
    this.win = function() {
        if (this.tail.length == winkugeln) {
                return true;
        } else {
            return false;
        }
    };
}
