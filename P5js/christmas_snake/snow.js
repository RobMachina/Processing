function Snowflake(tempPos){
    this.pos = tempPos || new p5.Vector(random(-100,width), random(-height,0));
    this.d = random(windowWidth/220,windowWidth/120);
    this.hue = color(255);//random(0, 360);
    this.speed = new p5.Vector(0.1,random(0.5,1.5));

    this.show = function(){
        noStroke();
        fill(this.hue,0,100,1);
        ellipse(this.pos.x,this.pos.y,this.d,this.d);
    };

    this.update = function(){
        if (this.pos.y >= (height-(this.d/2))) {
            this.melt();
        } else {
            this.fall();
        }
    };

    this.fall = function(){
        this.pos.add(this.speed);
        //console.log(this.pos);
    };

    this.melt = function(){
        this.d -= 0.1;
    };

    this.dead = function(){
        return (this.d <= 0);
    };

}
