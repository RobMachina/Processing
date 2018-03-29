//import fullscreen.*;
//import oscP5.*;
//import netP5.*;
import processing.serial.*;
//import japplemenubar.*;

//-------------------------------------------------------------------------
//
// Pacman Remake 1.0 made by Florian K. - Moded as Cryrover for machina eX 2012 by Robin Hädicke
//
//  The game was part of our performance "Wir aber erwachen ...". 
//  It was shown on old TV-Screen and controlled by an Arduino based Arcade Controller. 
//  The Goal is to collect all samples and evade the radioactive clouds.
//-------------------------------------------------------------------------

//OscP5 oscP5;
//NetAddress myRemoteLocation;
Serial port;  // The serial port
//String portname = "/dev/cu.usbserial-A6008c5D";  
String portname = Serial.list()[1]; //"/dev/tty.usbmodemfa1311"
int baudrate = 115200;

PFont font;

String[] input = {"test","1"};
int[] cont = {1,1,0};

int[][] level = {{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                 {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1},
                 {1,0,1,1,1,1,1,1,0,0,0,1,1,1,1,0,1,1,0,1},
                 {1,0,1,0,2,0,1,2,0,0,0,0,0,1,0,2,0,1,0,1},
                 {1,0,1,0,0,0,1,0,1,0,0,1,0,1,0,0,0,1,0,1},
                 {1,0,1,1,0,1,1,0,1,0,0,1,0,1,1,0,1,1,0,1},
                 {1,0,0,1,0,1,1,0,0,1,1,0,0,1,1,0,1,0,0,1},
                 {1,1,2,0,0,0,1,0,0,2,0,0,0,1,0,0,0,0,0,1},
                 {1,0,0,1,1,0,1,0,0,1,1,0,0,1,0,1,1,1,0,1},
                 {1,0,0,0,0,0,1,0,1,0,0,1,0,1,0,2,0,0,0,1},
                 {1,0,1,1,0,0,0,0,1,0,0,1,0,0,0,1,1,1,0,1},
                 {1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1},
                 {1,0,1,0,1,0,1,0,0,0,2,0,0,1,0,1,0,1,0,1},
                 {1,0,1,1,1,1,1,0,0,1,1,0,0,1,1,1,0,1,0,1},
                 {1,0,0,0,2,1,0,0,0,0,0,0,0,0,1,2,0,0,0,1},
                 {1,0,1,0,0,1,0,0,0,1,1,0,0,0,1,0,0,1,0,1},
                 {1,0,1,0,0,1,0,0,0,1,1,0,0,0,1,0,0,1,0,1},
                 {1,0,1,1,0,1,1,1,0,1,1,0,1,1,1,0,0,1,0,1},
                 {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1},
                 {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}};


int[][] level2 = {{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                 {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1},
                 {1,0,1,1,1,1,1,1,0,0,0,1,1,1,1,0,1,1,0,1},
                 {1,0,1,0,2,0,1,2,0,0,0,0,0,1,0,2,0,1,0,1},
                 {1,0,1,0,0,0,1,0,1,0,0,1,0,1,0,0,0,1,0,1},
                 {1,0,1,1,0,1,1,0,1,0,0,1,0,1,1,0,1,1,0,1},
                 {1,0,0,1,0,1,1,0,0,1,1,0,0,1,1,0,1,0,0,1},
                 {1,1,2,0,0,0,1,0,0,2,0,0,0,1,0,0,0,0,0,1},
                 {1,0,0,1,1,0,1,0,0,1,1,0,0,1,0,1,1,1,0,1},
                 {1,0,0,0,0,0,1,0,1,0,0,1,0,1,0,2,0,0,0,1},
                 {1,0,1,1,0,0,0,0,1,0,0,1,0,0,0,1,1,1,0,1},
                 {1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1},
                 {1,0,1,0,1,0,1,0,0,0,2,0,0,1,0,1,0,1,0,1},
                 {1,0,1,1,1,1,1,0,0,1,1,0,0,1,1,1,0,1,0,1},
                 {1,0,0,0,2,1,0,0,0,0,0,0,0,0,1,2,0,0,0,1},
                 {1,0,1,0,0,1,0,0,0,1,1,0,0,0,1,0,0,1,0,1},
                 {1,0,1,0,0,1,0,0,0,1,1,0,0,0,1,0,0,1,0,1},
                 {1,0,1,1,0,1,1,1,0,1,1,0,1,1,1,0,0,1,0,1},
                 {1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1},
                 {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}};



//FullScreen fs;

//SoftFullScreen fs;

PImage cryogramm; 

int[] tasten = {0,0,0,0};
int posx1 = 400;
int posy1 = 400;
int posx_geist1 = 40;
int posy_geist1 = 40;
int posx_geist2 = 600;
int posy_geist2 = 600;
int posx_geist3 = 600;
int posy_geist3 = 40;
int richtung = 0;
int richtung_geist1 = 2;
int richtung_geist2 = 1;
int richtung_geist3 = 0;
int p = 0;
int spielstatus = 1;
int w = 0;

int d1 = 0;
int d2 = -20;



boolean dreieck = false;
boolean dreieck2 = false;
boolean halbkreis = false;
boolean halbkreis2 = false;
boolean kreis = false;
boolean bewegung = false;
boolean state = false;


void setup()
  {
    //fs = new FullScreen(this); // Create the fullscreen object
    //fs.enter(); // enter fullscreen mod
     // Create the fullscreen object
    //fs = new SoftFullScreen(this);
    // enter fullscreen mode
    //fs.enter(); 
    //fs.setResolution(1280,960);
    //fs.setShortcutsEnabled(false);
    ellipseMode(CORNER);
    size(800,800);
    
    port = new Serial(this, portname, baudrate);
    
    //oscP5 = new OscP5(this, 9012);
    //myRemoteLocation = new NetAddress("192.168.2.2", 9013);
    
    font = createFont("Arial",32);
    cryogramm = loadImage("cryogramm.jpg");
  }

void draw()
  { steuerung();
    if(spielstatus == 2){
    fill(#000000);
    rect(0,0,800,800);
    }  
    if(spielstatus == 0)
      { 
        steuerung();
        startfenster();
      }
    if(spielstatus == 1)
      { steuerung();
        level();
        titel();
        //Exit();
        frameRate(50);
        Pac1_laufen();
        fill(#6B86B9);
        geistLaufen1();
        geistLaufen2();
        geistLaufen3();
        score();
        if (abstand() < 40 || abstand2() < 40 || abstand3() < 40)
            {  gameover();
            }
      }
      }




// OSC -------      
/*void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("start")==true) {
    //spielstatus = 0;
     }   
    }*/  
   

// Level --------------------------------------------------------------------------------------------------------------------------

void startfenster()
  {
    fill(#97B7F5);
    rect(0,0,800,800);
    fill(#474C55);
    textFont(font, 40);
    text("Strahlungssondensteuerprogramm",40,80);
    textFont(font, 30);
    text("Steuern Sie den Cryobot zur Entnahme", 40,160);
    text("von Bodenproben. Nutzen Sie die", 40,200);
    text("Steurungskonsole um die Sonde", 40, 240);
    text("zu den Entnahmestellen zu lenken.",40,280);
    text("Versuche Sie diese in kuerzester",40,320);
    text(" Zeit zuerreichen. Vermeiden",40,360);
    text("Sie den Kontakt mit Sandläufern,",40,400);
    text("da diese den Fortbewegungsapperat blockieren.",40,440);
    text("Zum Start des Cryobot betätigen sie gleichzeitig:", 40, 480);
    triangle(95, 490, 70, 530, 120, 530);
    arc(130, 460, 70, 70, 0, PI);
    triangle(220, 485, 220, 530, 260, 510);
    text("Dreiecksknopf(D) geleichzeitig", 40, 520);
    text("mit Kreis(H) und Halbkreis(E).", 40, 560); 
    image(cryogramm, 600, 600);
    //OscMessage bew = new OscMessage("/casey/bewegung");
    //bew.add("0");
    //oscP5.send(bew, myRemoteLocation);
    p = 0;
    w = 0;
    posx1 = 400;
    posy1 = 400;
    posx_geist1 = 40;
    posy_geist1 = 40;
    posx_geist2 = 600;
    posy_geist2 = 600;
    posx_geist3 = 600;
    posy_geist3 = 40;
    richtung = 0;
    richtung_geist1 = 2;
    richtung_geist2 = 1;
    richtung_geist3 = 0;
    neustart(); 
                 
  }
  
  public void neustart()
  {
    for(int i=0; i<level.length; i++)
      {
        for(int n=0; n<level.length;n++)
          {
            level[i][n] = level2[i][n];
          }
      }
  }
  
  void gameover()
     {  spielstatus = 3;
        // OscMessage state = new OscMessage("/casey/status");
        // state.add("gameover");
        //oscP5.send(state, myRemoteLocation);
        fill(#97B7F5);
        rect(0,0,800,800);
        fill(#474C55);
        textFont(font, 40);
        text("Cryobot verloren!",50,350);
        textFont(font, 30);
        text("Eingesammelte Proben : "+p+"/13",50,400);
        text("Für Cryobot Reboot die Tasten",50,450);
        triangle(95, 490, 70, 530, 120, 530);
        arc(130, 460, 70, 70, 0, PI);
        triangle(220, 485, 220, 530, 260, 510);
        text("Dreieck(D), Halbkreis(H) und Kreis(E)",100,290);
        text("zu gleich drücken.",50,570);
        image(cryogramm, 600, 600);
        // OscMessage bew = new OscMessage("/casey/bewegung");
        // bew.add("0");
        // oscP5.send(bew, myRemoteLocation);
        int[] tasten = {0,0,0,0};
        posx1 = 400;
        posy1 = 400;
        posx_geist1 = 40;
        posy_geist1 = 40;
        posx_geist2 = 600;
        posy_geist2 = 600;
        posx_geist3 = 600;
        posy_geist3 = 40;
     }

void win(){
        spielstatus = 3;
        fill(#97B7F5);
        rect(0,0,800,800);
        fill(#474C55);
        textFont(font, 40);
        text("Bodenprobenentnahme erfolgreich!",100,150);
        textFont(font, 30);
        text("Eingesammelte Proben : "+p+"/13",100,200);
        text("Die Bodenproben werden analysiert...",100,250);
        text("Das Messergebnis liegt bei",100,290);
        textFont(font, 40);
        text("1198 GRAY.",100,350);
        image(cryogramm, 600, 600);
        // OscMessage state = new OscMessage("/casey/status");
        // state.add("win");
        // oscP5.send(state, myRemoteLocation);
        // OscMessage bew = new OscMessage("/casey/bewegung");
        // bew.add("0");
        // oscP5.send(bew, myRemoteLocation);
        int[] tasten = {0,0,0,0};
       }

void egg(){
        spielstatus = 3;
        fill(#97B7F5);
        rect(0,0,800,800);
        fill(#474C55);
        textFont(font, 40);
         text("Achivement unlocked: Fleißiges Bienchen!!",100,150);
        text("Bodenprobenentnahme äusserst erfolgreich!",100,200);
        textFont(font, 30);
        text("Eingesammelte Proben : "+p+"/13",100,250);
        text("Eingesammelter Müll : "+w+"/203",100,300);
        text("Die Bodenproben werden analysiert...",100,350);
        text("Das Messergebnis liegt bei",100,390);
        textFont(font, 45);
        text("1198 GRAY.",100,350);
        image(cryogramm, 600, 600);
        int[] tasten = {0,0,0,0};
        //OscMessage state = new OscMessage("/casey/status");
        //state.add("egg");
        //oscP5.send(state, myRemoteLocation);
        //OscMessage bew = new OscMessage("/casey/bewegung");
        //bew.add("0"); 
        //oscP5.send(bew, myRemoteLocation);
        }        
  
  
void level()
  {
    for (int i=0; i < level.length; i++)
      {
        for (int n=0; n < level[i].length; n++)
          {
            if (level[i][n] == 1) {noStroke(); fill(#336AD3);}
            if (level[i][n] != 1) {noStroke(); fill(#848EA0);}
            rect (n*width/level[0].length,i*height/level.length,width/level[0].length,height/level.length);
            if (level[i][n] == 0) {fill(#B7F0FF); smooth(); ellipse(n*width/level[0].length+14,i*height/level.length+14,10,10);}
            if (level[i][n] == 2) {fill(#23C600); smooth(); ellipse(n*width/level[0].length+14,i*height/level.length+14,20,20);}
          }
      }
  }

void score()
  {
    textFont(font, 30);
    text("Proben",20,30);
    text("   "+p+"/13 ",100,30);
    if (p == 13)
      {
        win();      
        //println("win");
      }
    if (w == 203)
      {
        egg();      
        //println("win");
      }   
  } 
  
void punkteSammeln()
  {
     if (level[((posy1)/(width/level[0].length))][((posx1)/(width/level[0].length))] == 2)
        {
          level[((posy1)/(width/level[0].length))][((posx1)/(width/level[0].length))] = 3;
          p=p+1;
          // OscMessage punkte = new OscMessage("/casey/punkte");
          // punkte.add("1");
          //oscP5.send(punkte, myRemoteLocation);
        }
     if (level[((posy1)/(width/level[0].length))][((posx1)/(width/level[0].length))] == 0)
        {
          level[((posy1)/(width/level[0].length))][((posx1)/(width/level[0].length))] = 3;
          w=w+1;}  
   }
  
void titel()
  {
    fill(#A0D7E5);
    textFont(font, 30);
    text("     CryoBotSteuerung",230,30);   
    float wertx;
    float werty;
    if (posx1%40 < 10) {wertx = posx1%40;} else {wertx = 40-posx1%40;}
    if (posy1%40 < 10) {werty = posy1%40;} else {werty = 40-posy1%40;}
    
    if (richtung == 0) {arc(600,10,25,25,0+wertx*0.1,2*PI-wertx*0.1);rect(585,10,25,25);}
    if (richtung == 1) {arc(600,10,25,25,0+wertx*0.1,2*PI-wertx*0.1);rect(585,10,25,25);}
    if (richtung == 2) {arc(600,10,25,25,0+wertx*0.1,2*PI-wertx*0.1);rect(585,10,25,25);}
    if (richtung == 3) {arc(600,10,25,25,0+wertx*0.1,2*PI-wertx*0.1);rect(585,10,25,25);}
    if (richtung == 4) {ellipse(600,10,25,25);rect(585,10,25,25);}
}
    
    
// Pacman  ---------------------------------------------------------------------------------------------------------------------------------


void pacZeichnen()
  { float wertx;
    float werty;
    if (posx1%40 < 10) {wertx = posx1%40;} else {wertx = 40-posx1%40;}
    if (posy1%40 < 10) {werty = posy1%40;} else {werty = 40-posy1%40;}
    
    if (richtung == 0) {arc(posx1,posy1,40,40,1.5*PI+werty*0.1,3.5*PI-werty*0.1);rect(posx1,posy1+20,40,40);
                        d1 = 0;
                        d2 = 20;
                        bewegung = true;}
    if (richtung == 1) {arc(posx1,posy1,40,40,PI+wertx*0.1,3*PI-wertx*0.1);rect(posx1+20,posy1,40,40);
                        d1 = 20;
                        d2 = 0;  
                        bewegung = true;}
    if (richtung == 2) {arc(posx1,posy1,40,40,0.5*PI+werty*0.1,2.5*PI-werty*0.1);rect(posx1,posy1-20,40,40);
                        d1 = 0;
                        d2 = -20;
                        bewegung = true;}
    if (richtung == 3) {arc(posx1,posy1,40,40,0+wertx*0.1,2*PI-wertx*0.1);rect(posx1-20,posy1,40,40);
                        d1 = -20;
                        d2 = 0;
                        bewegung = true;}
    if (richtung == 4) {ellipse(posx1,posy1,40,40);rect(posx1+d1,posy1+d2,40,40); bewegung = false;}
    
    if(spielstatus == 1 && bewegung != state)
    { 
      if(bewegung)
      {
                        //OscMessage bew = new OscMessage("/casey/bewegung");
                        //bew.add("1");
                        //oscP5.send(bew, myRemoteLocation);
      }
      else if (!bewegung)
      { 
                        //OscMessage bew = new OscMessage("/casey/bewegung");
                        //bew.add("0");
                        //oscP5.send(bew, myRemoteLocation);
      }   
      state = bewegung;
   } 
 
  if(spielstatus != 1)  { 
                        //OscMessage bew = new OscMessage("/casey/bewegung");
                        //bew.add("0");
                        //oscP5.send(bew, myRemoteLocation);
                        }
}
              
                        
  
void Pac1_laufen()
  {
    if (posx1%40 == 0 && posy1%40 == 0)
      {
      lenken();
      punkteSammeln();
      }
    if (richtung == 0) {posy1-=4;}
    if (richtung == 1) {posx1-=4;}
    if (richtung == 2) {posy1+=4;}
    if (richtung == 3) {posx1+=4;}
    fill(#83ADFF);
    pacZeichnen();
  }
  
      
void lenken()
  {
    richtung = 4;
    if (tasten[0] == 1 && level[posy1/40-1][posx1/40] != 1) {richtung = 0;}
    if (tasten[1] == 1 && level[posy1/40][posx1/40-1] != 1) {richtung = 1;}
    if (tasten[2] == 1 && level[posy1/40+1][posx1/40] != 1) {richtung = 2;}
    if (tasten[3] == 1 && level[posy1/40][posx1/40+1] != 1) {richtung = 3;}
  }
  
  
void steuerung(){  
while (port.available() > 0) {
    String inBuffer = port.readStringUntil('\n');   
    //Test
    if (inBuffer != null) {
      input = split(inBuffer, ';');
      cont = int(split(input[1], ','));
    //Abnahme Controller
    if (input[0].equals("ctrl"))
    {   //println(state);
        switch(cont[0]) 
        {
        case 0: if(cont[1] == 1){tasten[1] = 1;} else {tasten[1] = 0;}break; //links 
        case 1: if(cont[1] == 1){tasten[2] = 1;} else {tasten[2] = 0;} break; //Runter
        case 2: if(cont[1] == 1){tasten[3] = 1;} else {tasten[3] = 0;} break;//recht
        case 3: if(cont[1] == 1){tasten[0] = 1;} else {tasten[0] = 0;} break;//hoch 
        }
     }
    //Abnahme Buttons   
    if (input[0].equals("bttn"))
    {   //println(state);
        switch(cont[0]) 
        {
        case 0: if(cont[1] == 1){dreieck = true;} else {dreieck = false;} break; 
        case 1: if(cont[1] == 1){halbkreis = true;/*spielstatus = 0;*/} else {halbkreis = false;} break;
        case 2: if(cont[1] == 1){dreieck2 = true;} else {dreieck2 = false;} break; 
        //case 3: if(cont[1] == 1){spielstatus=1;} break;
        case 4: if(cont [1] == 1){halbkreis2 = true;} else {halbkreis2 = false;} break;
        case 5: if(cont[1] == 1){kreis = true;} else {kreis = false;} break;
        //case 6: if(cont[1] == 1){spielstatus=1;} break;
        }
     }
    if(dreieck == true && halbkreis2 == true && kreis == true){
        spielstatus = 1; 
        // OscMessage state = new OscMessage("/casey/status");
        // state.add("start");
        // oscP5.send(state, myRemoteLocation);
        dreieck = false;
        halbkreis = false;
        kreis = false;}   
  
    }
  }
 }
void keyPressed()
  {
    if (key == 'w' || key == 'W') {tasten[0] = 1;}
    if (key == 'a' || key == 'A') {tasten[1] = 1;}
    if (key == 's' || key == 'S') {tasten[2] = 1;}
    if (key == 'd' || key == 'D') {tasten[3] = 1;}
  }

void keyReleased()
  {
  if (key == 'w' || key == 'W') {tasten[0] = 0;}
  if (key == 'a' || key == 'A') {tasten[1] = 0;}
  if (key == 's' || key == 'S') {tasten[2] = 0;}
  if (key == 'd' || key == 'D') {tasten[3] = 0;}
  if (key == 'h' || key == 'H') {spielstatus=1;}
  if (key == 'e' || key == 'E') {spielstatus=0;}
  }
  

// Ghost -------------------------------------------------------------------------------------------------------------


void geistZeichnen1()
  {
     stroke(#ABACAD);
     strokeWeight(2);
     noFill();
     ellipse(posx_geist1,posy_geist1,40,40);
     stroke(#618C98);
     fill(#12C9FA);
     ellipse(posx_geist1+12,posy_geist1+12,10,10);
     noFill();
     ellipse(posx_geist1+10,posy_geist1+10,15,15);
     noFill();
     ellipse(posx_geist1+8,posy_geist1+8,20,20);
     noFill();
     ellipse(posx_geist1+6,posy_geist1+6,25,25);
     noFill();
     ellipse(posx_geist1+4,posy_geist1+4,30,30);
     noFill();
     ellipse(posx_geist1+2,posy_geist1+2,35,35);
     
  }


void lenken_geist1()
  {
    richtung_geist1 = lenken_geist1_verfolgen();
  }


int lenken_geist1_verfolgen()
          {
            int wahlx;
            int wahly;
            if (posy_geist1 > posy1) {wahly = 0;} else {wahly = 2;}
            if (posx_geist1 > posx1) {wahlx = 3;} else {wahlx = 1;}
            if (abs(posx_geist1-posx1) < abs(posy_geist1-posy1)) {richtung_geist1 = wahly;} else {richtung_geist1 = wahlx;}
            
            //println(richtung_geist1);
            
            // Hier wird die Richtung überprüft
            
            if (richtung_geist1 == 0 && level[posy_geist1/40-1][posx_geist1/40] != 1) {return (richtung_geist1);}
            if (richtung_geist1 == 1 && level[posy_geist1/40][posx_geist1/40+1] != 1) {return (richtung_geist1);}
            if (richtung_geist1 == 2 && level[posy_geist1/40+1][posx_geist1/40] != 1) {return (richtung_geist1);}
            if (richtung_geist1 == 3 && level[posy_geist1/40][posx_geist1/40-1] != 1) {return (richtung_geist1);}
                
            // Hier ist die 2 Wahl
            
            if (richtung_geist1 == wahly) {richtung_geist1 = wahlx;} else {richtung_geist1 = wahly;}
            if (richtung_geist1 == 0 && level[posy_geist1/40-1][posx_geist1/40] != 1) {return (richtung_geist1);}
            if (richtung_geist1 == 1 && level[posy_geist1/40][posx_geist1/40+1] != 1) {return (richtung_geist1);}
            if (richtung_geist1 == 2 && level[posy_geist1/40+1][posx_geist1/40] != 1) {return (richtung_geist1);}
            if (richtung_geist1 == 3 && level[posy_geist1/40][posx_geist1/40-1] != 1) {return (richtung_geist1);}
                        
            if (abs(posx_geist1-posx1) < abs(posy_geist1-posy1)) {richtung_geist1 = (wahly+2)%4;} else {richtung_geist1 = (wahlx+2)%4;}
            if (richtung_geist1 == 0 && level[posy_geist1/40-1][posx_geist1/40] != 1) {return (richtung_geist1);}
            if (richtung_geist1 == 1 && level[posy_geist1/40][posx_geist1/40+1] != 1) {return (richtung_geist1);}
            if (richtung_geist1 == 2 && level[posy_geist1/40+1][posx_geist1/40] != 1) {return (richtung_geist1);}
            if (richtung_geist1 == 3 && level[posy_geist1/40][posx_geist1/40-1] != 1) {return (richtung_geist1);}

            boolean variable = false;
            int randzahl = 0;
            while(!variable)
              {
                randzahl = (int)random(0, 3.99);
                if (randzahl == 0 && level[posy_geist1/40-1][posx_geist1/40] != 1) {variable=true;}
                if (randzahl == 1 && level[posy_geist1/40][posx_geist1/40+1] != 1) {variable=true;}
                if (randzahl == 2 && level[posy_geist1/40+1][posx_geist1/40] != 1) {variable=true;}
                if (randzahl == 3 && level[posy_geist1/40][posx_geist1/40-1] != 1) {variable=true;}
              }
            return(4);
          }


void geistLaufen1()
  {
    if (posx_geist1%40 == 0 && posy_geist1%40 == 0) {lenken_geist1();}
    if (richtung_geist1 == 0) {posy_geist1--;}
    if (richtung_geist1 == 1) {posx_geist1++;}
    if (richtung_geist1 == 2) {posy_geist1++;}
    if (richtung_geist1 == 3) {posx_geist1--;}
    fill(#F2542C);
    geistZeichnen1();
  }


float abstand()
  {
    return sqrt(sq(posx1-posx_geist1)+sq(posy1-posy_geist1));
  }

//Geist 2  

void geistZeichnen2()
  {
    stroke(#ABACAD);
     strokeWeight(2);
     noFill();
     ellipse(posx_geist2,posy_geist2,40,40);
     stroke(#618C98);
     fill(#12C9FA);
     ellipse(posx_geist2+12,posy_geist2+12,10,10);
     noFill();
     ellipse(posx_geist2+10,posy_geist2+10,15,15);
     noFill();
     ellipse(posx_geist2+8,posy_geist2+8,20,20);
     noFill();
     ellipse(posx_geist2+6,posy_geist2+6,25,25);
     noFill();
     ellipse(posx_geist2+4,posy_geist2+4,30,30);
     noFill();
     ellipse(posx_geist2+2,posy_geist2+2,35,35);
  }


void lenken_geist2()
  {
    richtung_geist2 = lenken_geist2_verfolgen();
  }


int lenken_geist2_verfolgen()
          {
            int wahl2x;
            int wahl2y;
            if (posy_geist2 > posy1) {wahl2y = 0;} else {wahl2y = 2;}
            if (posx_geist2 > posx1) {wahl2x = 3;} else {wahl2x = 1;}
            if (abs(posx_geist2-posx1) < abs(posy_geist2-posy1)) {richtung_geist2 = wahl2y;} else {richtung_geist2 = wahl2x;}
            
            //println(richtung_geist2);
            
            // Hier wird die Richtung überprüft
            
            if (richtung_geist2 == 0 && level[posy_geist2/40-1][posx_geist2/40] != 1) {return (richtung_geist2);}
            if (richtung_geist2 == 1 && level[posy_geist2/40][posx_geist2/40+1] != 1) {return (richtung_geist2);}
            if (richtung_geist2 == 2 && level[posy_geist2/40+1][posx_geist2/40] != 1) {return (richtung_geist2);}
            if (richtung_geist2 == 3 && level[posy_geist2/40][posx_geist2/40-1] != 1) {return (richtung_geist2);}
                
            // Hier ist die 2 Wahl
            
            if (richtung_geist2 == wahl2y) {richtung_geist2 = wahl2x;} else {richtung_geist2 = wahl2y;}
            if (richtung_geist2 == 0 && level[posy_geist2/40-1][posx_geist2/40] != 1) {return (richtung_geist2);}
            if (richtung_geist2 == 1 && level[posy_geist2/40][posx_geist2/40+1] != 1) {return (richtung_geist2);}
            if (richtung_geist2 == 2 && level[posy_geist2/40+1][posx_geist2/40] != 1) {return (richtung_geist2);}
            if (richtung_geist2 == 3 && level[posy_geist2/40][posx_geist2/40-1] != 1) {return (richtung_geist2);}
                        
            if (abs(posx_geist2-posx1) < abs(posy_geist2-posy1)) {richtung_geist2 = (wahl2y+2)%4;} else {richtung_geist2 = (wahl2x+2)%4;}
            if (richtung_geist2 == 0 && level[posy_geist2/40-1][posx_geist2/40] != 1) {return (richtung_geist2);}
            if (richtung_geist2 == 1 && level[posy_geist2/40][posx_geist2/40+1] != 1) {return (richtung_geist2);}
            if (richtung_geist2 == 2 && level[posy_geist2/40+1][posx_geist2/40] != 1) {return (richtung_geist2);}
            if (richtung_geist2 == 3 && level[posy_geist2/40][posx_geist2/40-1] != 1) {return (richtung_geist2);}

            boolean variable2 = false;
            int randzahl2 = 0;
            while(!variable2)
              {
                randzahl2 = (int)random(0, 3.99);
                if (randzahl2 == 0 && level[posy_geist2/40-1][posx_geist2/40] != 1) {variable2=true;}
                if (randzahl2 == 1 && level[posy_geist2/40][posx_geist2/40+1] != 1) {variable2=true;}
                if (randzahl2 == 2 && level[posy_geist2/40+1][posx_geist2/40] != 1) {variable2=true;}
                if (randzahl2 == 3 && level[posy_geist2/40][posx_geist2/40-1] != 1) {variable2=true;}
              } 
            return(4);
          }


void geistLaufen2()
  {
    if (posx_geist2%40 == 0 && posy_geist2%40 == 0) {lenken_geist2();}
    if (richtung_geist2 == 0) {posy_geist2--;}
    if (richtung_geist2 == 1) {posx_geist2++;}
    if (richtung_geist2 == 2) {posy_geist2++;}
    if (richtung_geist2 == 3) {posx_geist2--;}
    fill(#F2542C);
    geistZeichnen2();
  }


float abstand2()
  {
    return sqrt(sq(posx1-posx_geist2)+sq(posy1-posy_geist2));
  }  
  
//Geist 3   
  
void geistZeichnen3()
  {
    stroke(#ABACAD);
     strokeWeight(2);
     noFill();
     ellipse(posx_geist3,posy_geist3,40,40);
     stroke(#618C98);
     fill(#12C9FA);
     ellipse(posx_geist3+12,posy_geist3+12,10,10);
     noFill();
     ellipse(posx_geist3+10,posy_geist3+10,15,15);
     noFill();
     ellipse(posx_geist3+8,posy_geist3+8,20,20);
     noFill();
     ellipse(posx_geist3+6,posy_geist3+6,25,25);
     noFill();
     ellipse(posx_geist3+4,posy_geist3+4,30,30);
     noFill();
     ellipse(posx_geist3+2,posy_geist3+2,35,35);
  }


void lenken_geist3()
  {
    richtung_geist3 = lenken_geist3_verfolgen();
  }


int lenken_geist3_verfolgen()
          {
            int wahl3x;
            int wahl3y;
            if (posy_geist3 > posy1) {wahl3y = 0;} else {wahl3y = 2;}
            if (posx_geist3 > posx1) {wahl3x = 3;} else {wahl3x = 1;}
            if (abs(posx_geist3-posx1) < abs(posy_geist3-posy1)) {richtung_geist3 = wahl3y;} else {richtung_geist3 = wahl3x;}
            
            //println(richtung_geist2);
            
            // Hier wird die Richtung überprüft
            
            if (richtung_geist3 == 0 && level[posy_geist3/40-1][posx_geist3/40] != 1) {return (richtung_geist3);}
            if (richtung_geist3 == 1 && level[posy_geist3/40][posx_geist3/40+1] != 1) {return (richtung_geist3);}
            if (richtung_geist3 == 2 && level[posy_geist3/40+1][posx_geist3/40] != 1) {return (richtung_geist3);}
            if (richtung_geist3 == 3 && level[posy_geist3/40][posx_geist3/40-1] != 1) {return (richtung_geist3);}
                
            // Hier ist die 2 Wahl
            
            if (richtung_geist3 == wahl3y) {richtung_geist3 = wahl3x;} else {richtung_geist3 = wahl3y;}
            if (richtung_geist3 == 0 && level[posy_geist3/40-1][posx_geist3/40] != 1) {return (richtung_geist3);}
            if (richtung_geist3 == 1 && level[posy_geist3/40][posx_geist3/40+1] != 1) {return (richtung_geist3);}
            if (richtung_geist3 == 2 && level[posy_geist3/40+1][posx_geist3/40] != 1) {return (richtung_geist3);}
            if (richtung_geist3 == 3 && level[posy_geist3/40][posx_geist3/40-1] != 1) {return (richtung_geist3);}
                        
            if (abs(posx_geist3-posx1) < abs(posy_geist3-posy1)) {richtung_geist3 = (wahl3y+2)%4;} else {richtung_geist3 = (wahl3x+2)%4;}
            if (richtung_geist3 == 0 && level[posy_geist3/40-1][posx_geist3/40] != 1) {return (richtung_geist3);}
            if (richtung_geist3 == 1 && level[posy_geist3/40][posx_geist3/40+1] != 1) {return (richtung_geist3);}
            if (richtung_geist3 == 2 && level[posy_geist3/40+1][posx_geist3/40] != 1) {return (richtung_geist3);}
            if (richtung_geist3 == 3 && level[posy_geist3/40][posx_geist3/40-1] != 1) {return (richtung_geist3);}

            boolean variable3 = false;
            int randzahl3 = 0;
            while(!variable3)
              {
                randzahl3 = (int)random(0, 3.99);
                if (randzahl3 == 0 && level[posy_geist3/40-1][posx_geist3/40] != 1) {variable3=true;}
                if (randzahl3 == 1 && level[posy_geist3/40][posx_geist3/40+1] != 1) {variable3=true;}
                if (randzahl3 == 2 && level[posy_geist3/40+1][posx_geist3/40] != 1) {variable3=true;}
                if (randzahl3 == 3 && level[posy_geist3/40][posx_geist3/40-1] != 1) {variable3=true;}
              } 
            return(4);
          }


void geistLaufen3()
  {
    if (posx_geist3%40 == 0 && posy_geist3%40 == 0) {lenken_geist3();}
    if (richtung_geist3 == 0) {posy_geist3--;}
    if (richtung_geist3 == 1) {posx_geist3++;}
    if (richtung_geist3 == 2) {posy_geist3++;}
    if (richtung_geist3 == 3) {posx_geist3--;}
    fill(#F2542C);
    geistZeichnen3();
  }


float abstand3()
  {
    return sqrt(sq(posx1-posx_geist3)+sq(posy1-posy_geist3));
  }    

// Ende --------------------------------------------------------------------------------------------------------------------
