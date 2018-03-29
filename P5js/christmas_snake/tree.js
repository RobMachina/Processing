function Tree(x,y,scl,elements) {
    var baumKugeln = [];
    var anzahlbaumKugeln = winkugeln/2;
    this.x = x;
    this.y = y;
    this.scl = scl;
    this.elements = elements;
    this.fillcolor = 'darkgreen';
    this.strokecolor = 'lightgreen';

    this.update = function() {
      for (var i = 0; i < anzahlbaumKugeln; i++) {
        var xpos = this.x;
  			var ypos = this.y;
        if (i%2 == 0) {
              if (i == 0) {
              xpos = this.x;
        			ypos = this.y;
              baumKugeln.push(new Kugel(xpos,ypos,scl));
              }else {
              xpos = this.x-this.scl/2*i;
        			ypos = this.y+this.scl*i;
              baumKugeln.push(new Kugel(xpos,ypos,scl));
              xpos = this.x+this.scl/2*i;
        			ypos = this.y+this.scl*i;
              baumKugeln.push(new Kugel(xpos,ypos,scl));
              }
            }
         }
    }

    this.display = function() {
        stroke(this.strokecolor);
        fill(this.fillcolor);
        triangle(this.x-(this.scl/4)*this.elements,this.y+(this.scl/2)*this.elements,this.x,this.y,this.x+(this.scl/4)*this.elements,this.y+(this.scl/2)*this.elements)

        for (var i = 0; i < this.elements; i++) {
          if (i == 0) {
            ellipse(this.x,this.y,this.scl,this.scl);
          }else {
            ellipse(this.x-this.scl/4*i,this.y+this.scl/2*i,this.scl,this.scl);
            ellipse(this.x+this.scl/4*i,this.y+this.scl/2*i,this.scl,this.scl);
          }
        }

        for (var i = 0; i < baumKugeln.length; i++) {
  			  baumKugeln[i].display();
  		  }
      };
}
