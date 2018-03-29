import ddf.minim.*;
import oscP5.*;
import netP5.*;


//Network OSC-Communication
OscP5 osc, oscEvent;
NetAddress hostAdress, deviceAdress;

//SOUNDs
Minim minim;
AudioSample gelesen, read, free, actived, inactived,spur;

//TIMER
timer timereins;
int settime;


//OSC-Receive
String InputAdresse = "";

//OSC-Send
String EVENT = "LEER";
String EVENTCASH = "LEER";
String OSCPATH = "/EVENT";

Table table;
int lineSpacing = 5;


//TIMER
boolean change = false;
boolean leer = true;
boolean load = false;
boolean active = false;
boolean tag = false;
boolean censored = true;
boolean timeron = false;
PFont fontklein, fontgross, fontlogo;

String[] logo, pfeil, sanduhr; 

PGraphics bildsanduhr, tabelle, timerpict;

float rotation = 0;

int timeStamp = millis();
int interval = 1000;	

int timeStamp2 = millis();
int interval2 = 1000;

//TIMER
boolean timerstart=false;
int millisekunde=0;
int sekunde=0;
int minute=0;


String RAUMAUSWAHL = "";

void setup() {
  size(720, 576);
  background(0, 255);	

  // OSC Instanz
  osc = new OscP5(this, 10000);
  hostAdress = new NetAddress("192.168.2.2", 11111);//"127.0.0.1/192.168.2.2"
  oscEvent = new OscP5(this, 10004);
  deviceAdress = new NetAddress("192.168.2.104", 10004);//"127.0.0.1/192.168.2.2"

  //SOUNDS
  minim = new Minim(this);
  gelesen = minim.loadSample("gelesen.aif", 512);
  read  = minim.loadSample("read.aif", 512);
  free  = minim.loadSample("free.aif", 512);
  spur  = minim.loadSample("bombe.aif", 512);
  actived =  minim.loadSample("active.aif", 512);
  inactived =  minim.loadSample("inactive.aif", 512);
  //FONTS  
  fontlogo = loadFont("CourierNew-12.vlw");
  fontklein = loadFont("Courier10PitchBT-Roman-16.vlw");
  fontgross = loadFont("Gulim-48.vlw");
  smooth();

  //OSC Pluggen
  osc.plug(this, "input", "/DEZERNAT/MONITOR/ANSICHT");
  osc.plug(this, "ident", "/DEZERNAT/MONITOR/ID");
  osc.plug(this, "login", "/DEZERNAT/MONITOR/LOGIN");
  osc.plug(this, "button", "/DEZERNAT/MONITOR/BUTTON");
  osc.plug(this, "timestop", "/DEZERNAT/MONITOR/TIMER");
  oscEvent.plug(this, "event", "/EVENT");


  bildsanduhr = createGraphics(200, 400);
  tabelle = createGraphics(width, height);
  timerpict = createGraphics(width, height);

  logo = loadStrings("logo.txt");
  pfeil = loadStrings("pfeil.txt");
  sanduhr = loadStrings("sanduhr.txt");

  table = new Table();

  //input("telefon");

  bildsanduhr.beginDraw();
  bildsanduhr.textFont(fontlogo, 8);
  bildsanduhr.fill(0, 255, 0);
  for (int i = 0; i < sanduhr.length; ++i) {

    bildsanduhr.text(sanduhr[i], 0, 0+(i*8));
  }

  bildsanduhr.endDraw();

  timereins = new timer(1000);
}

void draw() {
  fill(0, 50);
  rect(0, 0, width, height);
  int glow = 255;
  /*if (millis()%500 < 700) {
    glow = (int) random(120, 255);
  } */
  if (!active) {
    
  } else if (active) {
    fill(0, 255, 0, glow);

    if (load) {
      displayLoad(width/2, height/2, glow);
    } else if (tag) {
      if (censored) {
        if (timeStamp2 + interval2 < millis()) {
        displayTable(glow);
        displayCensored(width/2, height/2, glow);
        }
      } else {  
        if (timeStamp2 + interval2 < millis()) {
          displayTable(glow);
          displayLogin();
          EVENT = "LOGIN_AKTIV";
          eventSend(OSCPATH, EVENT, deviceAdress);
        }
      }
    }else if(timeron){

       timerfunction(glow);
       image(timerpict,0,0);
      
    } 
    else {
      displayEmpty();
    }

    displayHeader();
    displayLogo();
  }
}


// Display Funktionen für verschiedene Elemente - Zur Visualsierung

void displayLogo() {
  textFont(fontlogo, 8);
  for (int i = 0; i < logo.length; ++i) {
    text(logo[i], width-width/3.3, 0+32+(i*8));
  }
}

void displayCensored(int x, int y, int glow) {

  String labeltext ="AKTE ZENSIERT";
  String scanntext ="AUSWEIS \n ERFORDERLICH";

  pushStyle();
  pushMatrix();
  textFont(fontgross, 42);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  translate(x-25, y-25);
  rotate(PI/3.0);
  fill(0, 255);
  strokeWeight(2);
  stroke(0, 255, 0, glow);
  rect(0, 0, textWidth(labeltext)+20, 80);
  fill(0, 255, 0, glow);
  text(labeltext, 0, 0); 
  popMatrix();
  textFont(fontgross, 32);
  text(scanntext, width-width/5, height-height/7);
  popStyle();
}

void displayPfeil(int x, int y) {
  textFont(fontlogo, 8);
  for (int i = 0; i < pfeil.length; ++i) {

    text(pfeil[i], x, y+(i*8));
  }
}

void displayPfeiltabelle(int x, int y) {
  tabelle.textFont(fontlogo, 8);
  for (int i = 0; i < pfeil.length; ++i) {

    tabelle.text(pfeil[i], x, y+(i*8));
  }
}


void displayTable(int glow) {

  if (change) {
    
    int linecount = 0;

    timeStamp2 = millis();

    tabelle.beginDraw();

    tabelle.fill(0, 255);
    tabelle.rect(0, 0, width, height);

    tabelle.fill(0, 255, 0);

    for (int i = 0; i < table.getRowCount(); i++) {

      for (int j = 0; j < table.getColumnCount(); j++) {

        //println(table.getString(i,j));

        if (i == 0 && j == 0) {

          //textFont(fontgross, 32);
          //text(table.getString(i,j), 0+width/10 + (j*width/4), 0+height/6 + (i*height/10), width/4, height/6);
        } else if (i == 0 && j == 1) {

          tabelle.textFont(fontgross, 26);
          tabelle.text(table.getString(i, j), 0+width/10, 0+height/6, width, height/table.getRowCount());
          //println((calculateTextHeight(table.getString(i, j), width, 26, lineSpacing)));       
        } else {
          //println((calculateTextHeight(table.getString(i, j), width, 22, lineSpacing))); 
          tabelle.textFont(fontklein, 22);
          
          if(i == 1){
            tabelle.text(table.getString(i, j), 0+width/10 + (j*width/4), 0+height/5+26, width/3, height/table.getRowCount());
            
            if(j == 1){
              linecount = linecount + (22*(calculateTextHeight(table.getString(i, 1), 2, 22, lineSpacing)));
            }
          }else{
            
            tabelle.text(table.getString(i, j), 0+width/10 + (j*width/4), 0+height/5 + linecount, width/3, height/table.getColumnCount());
            if(j == 1){
              linecount = linecount + (22*(calculateTextHeight(table.getString(i, 1), 2, 22, lineSpacing)));
            }
          }  
        }
      }
    }
    tabelle.endDraw();
    change = false;
  }
  tint(255, glow);
  image(tabelle, 0, 0, width, height);
}

void displayLogin() {

  pushStyle();
  textAlign(CENTER);
  textFont(fontgross, 32);
  text("Bestätigen", width-width/6, height-height/4-48);
  popStyle();
  displayPfeil(width-width/5, height-height/4);
}

void displayHeader() {
  textFont(fontgross, 32);
  text("DEZERNAT SYSTEM", 0+width/10-10, 0+75);
}

void displayEmpty() {
  pushStyle();
  textAlign(CENTER);
  textFont(fontgross, 32);
  text("Bitte Beweismittel platzieren", width/2, height/2+2*32);
  popStyle();
  displayPfeil(width/2-12, height/2+3*32);
}

void displayLoad(int x, int y, int glow) {

  
  pushStyle();
  textAlign(CENTER);
  textFont(fontgross, 48);
  text(RAUMAUSWAHL, width/2, height/2);
  textFont(fontgross, 32);
  text("AUSGEWÄHLT", width/2, height/2+2*48);
  popStyle();
  
  /*pushStyle();
  fill(0, 255, 0, glow);
  imageMode(CENTER);
  pushMatrix();
  translate(x, y);
  rotate(rotation);
  image(bildsanduhr, 0, 0);

  if (timeStamp+interval < millis()) {
    rotation += HALF_PI;
    timeStamp = millis();
  }

  popMatrix();
  popStyle();*/
  
  
}


//OSC-PLugged Funktionen - Zur Steuerung 
void input(String id) {
  spur  = minim.loadSample(id+".aif", 512);
  table = loadTable(id + ".csv");
  EVENT = "LOADFILE_"+id;
  gelesen.trigger();
  RAUMAUSWAHL = table.getString(0, 1); 
  eventSend(OSCPATH, EVENT, hostAdress);
  tag = true;
  change = true;
}

void ident(String id) {
  if (id.equals("IDENT")) {
    timeStamp2= millis();
    censored = false;
    free.trigger();
  } else {
    censored = true;
  }
}

void button(String button) {
  //println("Button " + button);
  if (button.equals("T")) {
    inactived.trigger();
  } else {
  }
}

void timestop(String modus) {
  //println("Button " + button);
  if (modus.equals("START")) {
    timeron = true;
    timerstart = true;
  } else if (modus.equals("STOP")) {
    timeron = false;
    //timerstart = true;
  }
}

void event(String event) {

  //EVENT
  if (event.equals("ARCHIV_AKTIV")||event.equals("DEZERNAT_AUSWAHL")) {
    free.trigger();
    tag = false;
    active = true;
    censored = true;
    load = false;
  } else if (event.equals("ARCHIV_INAKTIV")||event.equals("COMPUTERTASK")||event.equals("BOMBETASK")||event.equals("HANDYTASK")) {
    //inactived.trigger();
    active = false;
  } else if (event.equals("TIMERSTART")||event.equals("LISTETASK")||event.equals("KASSETTETASK")||event.equals("PATRONETASK")) {
    if (event.equals("KASSETTETASK")){
    
      settime = 7;
      
    }else{
    
      settime = 6;
      
    }
    
    tag = false;
    load = false;
    timeron = true;
    timerstart = true;
  } else if (event.equals("TIMERSTOP")||event.equals("LISTEWIN")||event.equals("PATRONEWIN")||event.equals("KASSETTEWIN")||event.equals("LISTEFAIL")||event.equals("PATRONEFAIL")||event.equals("KASSETTEFAIL")) {
    timeron = false;
    active = false;
    //timerstart = true;
  }
}

void login(int login) {

  //EVENT
  if (login == 1) {
    load = true;
    spur.trigger();
  } else {
    load = false;
  }
}

void timerfunction(int glow) {

  if (timerstart) {
    timereins.setOver(1000);
    sekunde = 59;
    minute = settime;
    timerstart = false;
  } else {

    if (timereins.over()) {
      //println(sekunde);
      if (sekunde == 0) {
        sekunde = 59;
        minute--;
        sekunde--;
      } else {
        sekunde--;
      }
      
      if (minute == 0){
        EVENT = "TIMEOUT";
        eventSend(OSCPATH, EVENT, hostAdress);
        minute = 6;
        active = false;
        timeron = false;
      }
      
      timerpict.beginDraw();
      timerpict.pushMatrix();
      timerpict.pushStyle();
      timerpict.fill(0, 255);
      timerpict.rect(0, 0, width, height);
      timerpict.translate(width/2, height/2);
      for (int i = 0; i < 360; i+=6) {
        float angle = 0; //sin(radians(i*3+frameCount)) * 30;
        float x = sin(radians(i));
        float y = cos(radians(i));
        timerpict.fill(map(i, 0, 360, 255, 0), map(i, 0, 360, 0, 255), 0);
        /* Moving ellipse from center to posision */
        /*if (sekunde*6 == i) clockDot(x*(mill-angle), y*(mill-angle), 6, 30, i);*/
        /* Show the ellipse if the second has passed */
        if (i < sekunde*6) { 
          clockDot(x*(120-angle), y*(120-angle), 6, 30, i);
        }          
      }
      timerpict.fill(0, 255, 0, glow);
      timerpict.textFont(fontgross, 100);
      timerpict.textAlign(CENTER, CENTER);
      timerpict.text(minute, 0, 0);
      timerpict.popStyle();   
      timerpict.popMatrix();
      timerpict.endDraw();
      timereins.reset();
    }
  }
}



// OSC-Kommunikation Global

void eventSend(String pfad, String event, NetAddress address)
{
  if (!event.equals(EVENTCASH)) {
    println(event);
    // create an osc message to maxmsp
    OscMessage myMessage = new OscMessage(pfad);
    myMessage.add(event); // add an int to the osc message 

    // send the message
    osc.send(myMessage, address);
    EVENTCASH=event;
  }
}

void oscEvent(OscMessage DisplayArchivOsc)        
{  
  InputAdresse = DisplayArchivOsc.addrPattern();

  // print out the message
  print("OSC Message Recieved: ");
  print(DisplayArchivOsc.addrPattern() + " ");
  println(DisplayArchivOsc);
}