// main gaming loop & logic
void gameLoop() {

  // draw UI & update userinput
  //showPolyCode();
  showProgress();
  showHelp();
  showLine();
  showThread();  
  textProgress(); 
  control();
  paddel.show();
  particleAnimation();
  

  // switch between level (increasing difficulty)
  switch(level) {
  case 1:
    for (Poly p : polys) {
      p.setSpeed(.5+(.25*unlockState));
      p.update();
      p.show();
    }
    for (Bullet b : bulletList) {
      b.move();
      b.show();
    }
    break;
  case 2:
    for (Poly p : polys) {
      p.setSpeed(.5+(.15*unlockState));
      p.update();
      p.rotatePoly(110);
      p.show();
    }
    for (Bullet b : bulletList) {
      b.move();
      b.show();
    }
    break;
  case 3:
    for (Poly p : polys) {
      p.setSpeed(1.5);
      p.update();
      p.rotatePoly(50);
      p.setSpeed(2);
      p.show();
    }
    for (Bullet b : bulletList) {
      b.move();
      b.show();
    }
    break;
  }

  // check what happend during loop
  checkPolyOutOfBounds();
  checkThreadLevel();
  checkCollison();
}

void screenLoop() {
  switch(textState) {
  case 0:
    startScreen("SPEICHER \n KryptoKnack verschlüsselt", "ENTSCHLÜSSELN \n STARTEN");
    break;
  case 1:
    lastScreenWin("DAS SYSTEM IST ENTSCHLÜSSELT!", "Letztes Chatprotokoll wird geöffnet.");
    break;
  case 2:
    lastScreenLose("ZUGRIFF GESCHEITERT!", "Das System ist gespeert!");
    break;
  }
}

void animationLoop() {
  if (animationCounter<200) {
    textWarning();
    particleAnimation();
  } else {
    mode = game;
    animationCounter=0;
    oscSend("/playloop", polyCode[unlockState]);
    return;
  }
  animationCounter++;
}

// generates unlock-code seen in showPolyCode
void generateCode() {
  switch(level) {
  case 1:
    for (int i=0; i<polyCode.length; i++) {  
      polyCode[i]=int(random(4));
      print(polyCode[i]);
    }
    println();
    break;
  case 2:
    for (int i=0; i<polyCode.length; i++) {  
      polyCode[i]=int(random(8));
      print(polyCode[i]);
    }
    println();
    break;
  case 3:
    for (int i=0; i<polyCode.length; i++) {  
      polyCode[i]=int(random(8));
      print(polyCode[i]);
    }
    println();
    break;
  }
}

// generates random poly sequence 
void generatePolys() {
  switch(level) {
  case 1:
    for (int i=0; i<polys.length; i++) {
      polys[i] = new Poly(width/(polys.length+1)*(i+1), -10, 1, int(random(4)));
    }
    // randomly replace one poly with the needed kind to unlock polyCode
    polys[int(random(polys.length))].setKind(polyCode[unlockState]);
    break;
  case 2:
    for (int i=0; i<polys.length; i++) {
      polys[i] = new Poly(width/(polys.length+1)*(i+1), -10, 1, int(random(8)));
    }
    // randomly replace one poly with the needed kind to unlock polyCode
    polys[int(random(polys.length))].setKind(polyCode[unlockState]);
    break;
  case 3:
    for (int i=0; i<polys.length; i++) {
      polys[i] = new Poly(width/(polys.length+1)*(i+1), -10, 1, int(random(8)));
    }
    // randomly replace one poly with the needed kind to unlock polyCode
    polys[int(random(polys.length))].setKind(polyCode[unlockState]);
    break;
  }
}

void shuffleArray(int[] array) {
  // http://forum.processing.org/two/discussion/3546/how-to-randomize-order-of-array
  Random rng = new Random();
  // i is the number of items remaining to be shuffled.
  for (int i = array.length; i > 1; i--) {
    // Pick a random element to swap with the i-th element.
    int j = rng.nextInt(i);  // 0 <= j <= i-1 (0-based array)
    // Swap array elements.
    int tmp = array[j];
    array[j] = array[i-1];
    array[i-1] = tmp;
  }
}

// check every poly for collision wiht bullets
void checkCollison() {
  for (Poly p : polys) {
    for (int j=bulletList.size ()-1; j>=0; j--) {
      Bullet B  =  bulletList.get(j);
      if ((sq(B.x-p.posX)+sq(B.y-p.posY))<sq(18)) { // check distance
        if (p.kind == polyCode[unlockState]) { // if correct poly hit
          righthit.trigger();
          progress = progress +50;
          blast(true, p);
          return;
        } else { // if wrong poly hit
          wronghit.trigger();
          blast(false, p);
          return;
        }
      } else if (B.y<=1) bulletList.remove(j); // if bullet outofbound
    }
  }
}

// check if pollys are below paddel > rise threadlevel if true
void checkPolyOutOfBounds() {
  if (polys[0].posY>=paddelY-10) {
    for (Poly p : polys) {
      addParticle(p, #B72525);
    }
    generatePolys();
    increaseThread();
    bulletList.clear(); 
    generatePolys();
    mode=animation;
    oscSend("/stop");
  }
}

// helper function; called after bullet hits poly
void blast(boolean correct, Poly p) {
  if (correct) {
    unlockState++;
    addParticle(p, #68BF4B);
    bulletList.clear(); // delete bullets
    if (unlockState<polyCode.length) { // init next round if there are still code polys to unlock  
      generatePolys();
      oscSend("/playloop", polyCode[unlockState]);
    } else levelUP(); // if code completely unlocked level up
  } else { // if wrong poly is hit > rise threadlevel and init next round
    increaseThread();
    addParticle(p, #B72525);
    bulletList.clear(); 
    generatePolys();
    mode=animation;
    oscSend("/stop");
  }
}

// jump to next level and reset values
void levelUP() {
  win.trigger();
  level++;
  unlockState=0;
  generateCode();
  generatePolys();
  oscSend("/playloop", polyCode[unlockState]);
  if (level==4) { // if last level won jump to textScreen
    win.trigger();
    textState=1;    
    mode=menu;
    oscSend("/playloop", 9);
    oscSendToMax("/COMPUTER/EVENT", "COMPUTERWIN");
  }
}

// check if max threadlevel reached
void checkThreadLevel() {
  if (threadLevel>12) {
    textState=2;
    mode=menu;
    //fail.trigger();
    oscSend("/stop");
    oscSendToMax("/COMPUTER/EVENT", "COMPUTERFAIL");
  }
}

void addParticle(Poly p, color c) {
  for (int k=0; k<30; k++) {
    Particle E = new Particle(p.posX+random(-30, 30), p.posY+random(-30, 30), c);
    blastList.add(E);
  }
}

void increaseThread() {
  threadLevel++;
  oscSendToMax("/COMPUTER/THREADLEVEL", ""+threadLevel);
}

