import oscP5.*;
import netP5.*;
import java.util.Random;
import controlP5.*;
import ddf.minim.*;

ControlP5 cp5;
DropdownList d1;
int selection=0;
int correctSelection=3;
ControlFont thefont;
String[] wrongSelectionText = {
  "Bitte wählen sie ein \n Ziel für den Zugriff aus!", 
  "Daten gelöscht \n Kein Zugriff möglich.", 
  "Daten verschoben \n Kein Zugriff möglich.", 
  " ", 
  "Es wurde keine \n weiteren Objekte gefunden!", 
  "Steuerung: < & > & LEERTASTE"
};
int wrongSelection=5;

//SOUNDs
Minim minim;
AudioSample wronghit, righthit, fail, win, error;

OscP5 oscP5;
NetAddress myRemoteLocation, myRemoteLocation2;

String piIP = "192.168.2.21";
int piPort = 9001;
String hostIP = "192.168.2.2";
int hostPort = 11000;
int homePort = 11001;
String videoPath = "/media/meXDriveData/toxik/video";
String svgPath = "/media/meXDriveData/toxik/svg/";
String htmlPath = "/home/y/entschluesselt/";
String[] clip = { 
  "/aerobic_1.mp4", "/aerobic_2.mp4", "/aerobic_3.mp4", "/aerobic_4.mp4", 
  "/aerobic_5.mp4", "/aerobic_6.mp4", "/aerobic_7.mp4", "/aerobic_8.mp4", 
  "/intro.mp4", "/outro.mp4", "/jetzt_gehts_los.mp4"
};

// logic variables
final static int game = 0;
final static int menu = 1;
final static int animation = 2;
int mode = menu;

int textState = 0; // default=0
int unlockState = 0;
int threadLevel = 0;
int level=1; //default=1
int lifeLine = 12;
int animationCounter = 0;
int progress = 0;

// graphic variables
Poly[] polys = new Poly[5];
int[] polyCode = new int[5];
ArrayList<Bullet> bulletList = new ArrayList();
ArrayList<Particle> blastList = new ArrayList();
PShape[] shape = new PShape[8];
PFont mono;

color bgColor = color(50);
color threadColor = color(220, 50, 47, 125);
color textColor = color(253, 246, 227);
color progressColor = color(133,153,0,125);

int paddelY = 680;
Paddel paddel = new Paddel(200, paddelY);
float paddelSpeed=3.5;

// control variables
boolean keyright = false;
boolean keyleft = false;
boolean hit = false;

void setup() {
  size(400, 700);
  oscP5 = new OscP5(this, homePort);
  myRemoteLocation = new NetAddress(piIP, piPort);
  myRemoteLocation2 = new NetAddress(hostIP, hostPort);
  initDrowDown();
  loadShapes();
  // init game
  generateCode();
  generatePolys();
  oscSend("/unloop");
  oscSend("/playloop", 8);
  oscSendToMax("/COMPUTER/EVENT", "START");
  
  //SOUNDS
  minim = new Minim(this);
  win = minim.loadSample("win.aif", 512);
  //fail  = minim.loadSample("fail.aif", 512);
  wronghit  = minim.loadSample("wronghit.aif", 512);
  righthit =  minim.loadSample("righthit.aif", 512);
  error =  minim.loadSample("error.aif", 512);

  mono = loadFont("ArialMT-20.vlw");
  textFont(mono);
}

void draw() {
  background(bgColor);

  switch (mode) {
  case game :
    gameLoop();
    break;  
  case menu :
    screenLoop();
    break;  
  case animation :
    animationLoop();
    break;
  }
}

void exit() {
  oscSend("/stop");
  println("stop");//do your thing on exit here
  super.exit();//let processing carry with it's regular exit routine
}

void loadShapes() {
  for (int i=0; i<shape.length; i++) {
    shape[i]=loadShape("aerobic_"+(i+1)+".svg");
  }
}

