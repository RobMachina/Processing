void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) keyleft = true; 
    if (keyCode == RIGHT) keyright = true;
  }
  if (key == ' ') hit= true;
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) keyleft = false; 
    if (keyCode == RIGHT) keyright = false;
  }
  if (key == ' ') hit= false;
}

void control() {
  if (keyleft) {
    if (paddel.x<=0)paddel.x=0;
    else paddel.x-=paddelSpeed;
  }
  if (keyright) {
    if (paddel.x>=width)paddel.x=width;
    else paddel.x+=paddelSpeed;
  }
  if (hit) {
    Bullet B = new Bullet(paddel.x, paddel.y);
    bulletList.add(B); 
    hit=false;
  }
}

void oscSend(String msg, int polyCode) {
  OscMessage myMessage = new OscMessage("/stop");
  oscP5.send(myMessage, myRemoteLocation);
  println(myMessage);

  OscMessage myMessage2 = new OscMessage(msg);
  myMessage2.add(videoPath+clip[polyCode]);
  oscP5.send(myMessage2, myRemoteLocation);
  println(msg+videoPath+clip[polyCode]);
}

void oscSend(String msg) {
  OscMessage myMessage = new OscMessage(msg);
  oscP5.send(myMessage, myRemoteLocation);
  println(myMessage);
}

void oscSendToMax(String path, String msg) {
  OscMessage myMessage = new OscMessage(path);
  myMessage.add(msg);
  oscP5.send(myMessage, myRemoteLocation2);
  println(myMessage);
}

void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  print(" typetag: "+theOscMessage.typetag());
  
  if (theOscMessage.checkAddrPattern("/EVENT")==true) {
    if (theOscMessage.checkTypetag("s")) {
      String val = theOscMessage.get(0).stringValue();
      println(" "+val);
      if (val.equals("COMPUTEREXIT")) {
        exit();
        println("exit!");
      }
    }
  }
}

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    selection = (int)theEvent.getGroup().getValue();
  } else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

