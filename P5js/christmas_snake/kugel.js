function Kugel(x,y,dim) {

    this.sizekugel=dim;
    this.x = x;
    this.y = y;
    this.color = ['lightblue','gold','cornflowerblue','darkorange','tomato', 'slateblue', 'hotpink','steelblue','aquamarine','salmon'];
    this.fillcolor = random(this.color);
    this.strokecolor = this.fillcolor;
    this.bandcolor = 'PaleGoldenRod';

    this.display = function() {
        ellipseMode(CENTER);
        stroke(this.bandcolor);
        strokeWeight(1.5);
        noFill();
        ellipse(this.x-(this.sizekugel/8),this.y-this.sizekugel,this.sizekugel/4,this.sizekugel);
        stroke(this.strokecolor);
        fill(this.fillcolor);
        ellipse(this.x, this.y, this.sizekugel, this.sizekugel);
        fill(255,50);
        arc(this.x,this.y, this.sizekugel,this.sizekugel, 230, 30, CLOSE);
    };
}
