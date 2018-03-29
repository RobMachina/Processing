void showPolyCode() {
  int radius = 10;
  int y = height-60;

  for (int i=0; i<polyCode.length; i++) {
    shape(shape[polyCode[i]], width/(polys.length+1)*(i+1), y, 40, 40);
  }
} 

void showThread() {
  pushStyle();
  noStroke();
  fill(threadColor);
  textAlign(CENTER);
  rectMode(CORNER);
  rect(0, 0, width, ((height-(height-paddelY-3))/lifeLine)*threadLevel);
  popStyle();
}

void showProgress() {
  pushStyle();
  noStroke();
  fill(progressColor);
  textAlign(CENTER);
  rectMode(CORNER);
  rect(0, height-progress, width,progress);
  popStyle();
}

void showLine() {
  pushStyle();
  strokeWeight(2);
  stroke(255);
  line(0, paddelY, width, paddelY);
  popStyle();
}

void showHelp() {
  pushStyle();
  fill(textColor);
  textAlign(CENTER,BOTTOM);
  text("Steuerung: < & > & LEERTASTE", width/2,paddelY+18);
  popStyle();
}

void textProgress() {
  pushStyle();
  showProgress();
  fill(255);
  textSize(14);
  text("ENTSCHLÜSSELUNG ERFOLGREICH \n NÄCHSTE SICHERTHEITSSTUFE ERREICHT" +level+"/3", width/2, paddelY+80);
  popStyle();
}

void textWarning() {
  // draw UI & update userinput
  //showPolyCode();
  showLine();
  showThread();
  //showProgress();
  paddel.show();
  
  fill(255);
  textSize(14);
  text("FALSCHE EINGABE ... \n "+
    "...SPERRUNG NACH "+(lifeLine-threadLevel+1)+" VERSUCHEN", width/2, height/2);
}

void startScreen(String firstText, String secondText) {
  textAlign(CENTER);
  fill(255);
  textSize(20);
  text(firstText, width/2, height/2-80);
  textSize(20);
  fill(125);
  rectMode(CENTER);
  noStroke();
  rect(width/2, height/2, 200, 60);
  textSize(15);
  fill(255);
  text(secondText, width/2, height/2);

  if (wrongSelection!=5)fill(progressColor);
  textSize(15);
  text(wrongSelectionText[wrongSelection], width/2, height/2+100);

  if (mousePressed && dist(mouseX, mouseY, width/2, height/2)<50 && selection==correctSelection) {
    righthit.trigger();
    mode = game;
    d1.hide();
    oscSend("/playloop", polyCode[unlockState]);
  } else if (mousePressed && dist(mouseX, mouseY, width/2, height/2)<50 && selection!=correctSelection) {
    error.trigger();
    wrongSelection=selection;
    //println(selection + " " +wrongSelection);
  }
}

void lastScreenWin(String firstText, String secondText) {
  textAlign(CENTER);
  fill(255);
  textSize(20);
  text(firstText, width/2, height/2-40);
  textSize(15);
  fill(threadColor);
  rectMode(CENTER);
  noStroke();
  rect(width/2, height/2, 200, 30);
  textSize(12);
  fill(255);
  text(secondText, width/2, height/2+5);
  if (mousePressed && dist(mouseX, mouseY, width/2, height/2+5)<50 && level==4) {

    String[] params = { 
      "gnome-open", htmlPath+"sexchat.html"
    };
    exec(params); 

    String[] params2 = { 
      "lp", htmlPath+"Sexchat.pdf"
    };
    exec(params2);    

    // send osc WIN
    exit();
  }
}

void lastScreenLose(String firstText, String secondText) {
  textAlign(CENTER);
  fill(255);
  textSize(20);
  text(firstText, width/2, height/2-40);
  textSize(15);
  fill(threadColor);
  rectMode(CENTER);
  noStroke();
  rect(width/2, height/2, 200, 30);
  textSize(12);
  fill(255);
  text(secondText, width/2, height/2+5);
}

void particleAnimation() {
  for (int i=0; i<blastList.size (); i++) {
    Particle P = blastList.get(i);
    P.display();
    P.move();
    if (P.r<0)blastList.remove(i);
  }
}

void initDrowDown() {
  PFont pfont = createFont("Arial", 15, true); // use true/false for smooth/no-smooth
  thefont = new ControlFont(pfont, 11);
  cp5 = new ControlP5(this);
  // create a DropdownList
  d1 = cp5.addDropdownList("startList")
    .setPosition(width/2-100, height/2+75)
      .setSize(200, 200)
        ;
  d1.setBackgroundColor(color(255));
  d1.setItemHeight(40);
  d1.setBarHeight(30);
  d1.captionLabel().setControlFont(thefont);
  d1.captionLabel().set("Auswahl der Daten");
  d1.captionLabel().style().marginTop = 6;
  d1.captionLabel().style().marginLeft = 3;
  d1.valueLabel().style().marginTop = 3;
  d1.addItem("Projekt_P/Geschlossen/", 1);
  d1.addItem("Projekt_Z", 2);
  d1.addItem("Chatprotokolle", 3);
  d1.addItem("Sonstiges", 4);

  //ddl.scroll(0);
  d1.setColorBackground(color(60));
  d1.setColorActive(color(255, 128));
}

