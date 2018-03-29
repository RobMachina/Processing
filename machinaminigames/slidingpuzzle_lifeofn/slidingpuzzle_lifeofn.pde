//import codeanticode.syphon.*;
//import oscP5.*;
//import netP5.*;

//Netzwerk
//OscP5 oscP5;
//NetAddress myRemoteLocation;

//Anwendung
PImage img,imgplace; //feld1, feld2, feld3, feld4, feld5, feld6, feld7, feld8, feld9;
PImage[] imgarray= new PImage[10];
int counter;
PuzzleTile[] puzzletiles = new PuzzleTile[10];
int[] checkarray = new int[10];
int[] solvearray = {0,1, 2, 3, 4, 5, 6, 7, 8, 9}; 
PGraphics buffer;
boolean changed = true;

//SyphonServer server;

void setup() {
  size(600, 600,P3D);
  noFill();
  stroke(255);
  frameRate(30);

  //Netzwerk  
  //oscP5 = new OscP5(this, 12006);
  //myRemoteLocation = new NetAddress("192.168.2.2", 8001);//Test

  //Syphon
  //server = new SyphonServer(this, "Processing Syphon");

  buffer= createGraphics(width, height);
  
  img = loadImage("Zeichnung_Schieberätsel.png");
  
  counter = 0;
  for(int i = 0; i < 3; i++){
    	for(int j = 0; j < 3; j++){
    		counter = counter +1;
    		imgarray[counter] = img.get(i*200,j*200,200,200);
    	}
  }

  createTiles();
  background(255);
}

void draw() {

	//fill(255,240);
	//rect(0,0,600,600);
    
    if(changed){
      //shuffle();
      refreshBuffer();
      changed=false;
    }
    
   	image(buffer,0,0);
    //server.sendImage(buffer);

}


void createTiles(){

    counter = 0;
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < 3; j++){
        counter = counter +1;
        puzzletiles[counter] = new PuzzleTile(counter, i*200, j*200);
      }
    }  
}

//Refresh
void refreshBuffer(){
    fill(255);
    rect(0,0,600,600);
    checkSolve();
    println("refresh");
    buffer=createGraphics(width, height);
    buffer.smooth();


    buffer.beginDraw();
	  counter = 0;

    for(int i = 0; i < 3; i++){
    	for(int j = 0; j < 3; j++){
    		counter = counter +1;
        puzzletiles[counter].update();
    		puzzletiles[counter].create(this.buffer);
    	}
    }  
    buffer.endDraw(); 
}

void checkSolve(){
    int checksum = 0;
    for(int i = 1; i < 10; i++){
      checkarray[i] = puzzletiles[i].getValue();
      println("checkarray: "+checkarray[i]);
      if(checkarray[i] == solvearray[i]){
        checksum++;
      }else{
        checksum--;
      }
      println(checksum);
      if (checksum == 9){
        //udpsend("/SCHIEBERAETSEL", "solved");
        println("solved");
        break;
      }
    }

}

//SCHUFFEL
void shuffle(){
      
    //START Position randomizer
    int o = 0;
    int[] location = {0, 0, 0, 0, 0, 0, 0, 0, 0}; 

    //Reset "memory" for randomizer
    for(int i=0; i<9; i++){
      location[i] = 0;
    }
    
    counter = 1;
    //Randomizer
    while(counter<9){
        o = int(random(1,9)); //Roll a 9 sided die
        if(location[o]==0){  //if I haven't used this location yet
          puzzletiles[counter].changeImg(o); //Set the piece to this location
          location[o] = 1; //Then remember I used this location
          counter++; //Scroll through the array
        }
    }  
      
  }




//Check if the cursor is over a piece----------------------------------------------------------------------------------------------------------
  boolean checkMouse(int i){
    if(dist(mouseX,mouseY,puzzletiles[i].sendX(),puzzletiles[i].sendY())<50){
      
      println("true:");
      return true;
    }
    else{
      
      //println("false:");
      return false;
      
    }
  }


//CHECK KEY INPUT

void keyReleased() {

    switch(keyCode) {

    case UP: 
      
      //PRÜFEN WELCHES TEIL SICH NACH OBEN BEWEGEN KANN
      for(int i = 0; i < 10; i++){

        if(i == 0 || i == 1 || i == 4 || i == 7){
          
          //do nothing
        }else{

        if(puzzletiles[i-1].getValue()==9){
            println("canmove");
            puzzletiles[i-1].changeImg(puzzletiles[i].getValue());
            puzzletiles[i].changeImg(9);
            changed = true;
            break;
          }  

        }
      }
      
    break;
    
    case DOWN: 

      //PRÜFEN WELCHES TEIL SICH NACH UNTEN BEWEGEN KANN
      for(int i = 0; i < 10; i++){
        
        if(i == 3 || i == 6 || i == 9 || i == 0){

          //do nothing
          
        }else{

            if(puzzletiles[i+1].getValue()==9){
              println("canmove");
              puzzletiles[i+1].changeImg(puzzletiles[i].getValue());
              puzzletiles[i].changeImg(9);
              changed = true;
              break;
            } 

        }

      }
      
      break;
    
    case LEFT: 
      
      //PRÜFEN WELCHES TEIL SICH NACH OBEN BEWEGEN KANN

      for(int i = 0; i < 10; i++){
        if(i == 1 || i == 2 || i == 3 || i == 0){
          //do nothing
        }else{
          if(puzzletiles[i-3].getValue()==9){
            println("canmove");
            puzzletiles[i-3].changeImg(puzzletiles[i].getValue());
            puzzletiles[i].changeImg(9);
            changed = true;
            break;
          }
        }

      }

      break;
    
    case RIGHT: 
     
      //PRÜFEN WELCHES TEIL SICH NACH OBEN BEWEGEN KANN 
      
      for(int i = 0; i < 10; i++){

        if(i == 7 || i == 8 || i == 8 || i == 0){
          //do nothing
        }else{

          if(puzzletiles[i+3].getValue()==9){
            println("canmove");
            puzzletiles[i+3].changeImg(puzzletiles[i].getValue());
            puzzletiles[i].changeImg(9);
            changed = true;
            break;
          }
        }

      }

      break;

    case ENTER: 
     
      shuffle();
      changed = true;
      break;  
    
    default:
      
      break;
    }
  }

/*void udpsend(String OSCADRESS, String message) {
  // OSC-ADRESS DYNAMISCH ERSTELLEN
  OscMessage myMessage = new OscMessage(OSCADRESS);
  myMessage.add(message); // add an int to the osc message 

  // send the message 
  oscP5.send(myMessage, myRemoteLocation);
}*/

  