
/*ToDo
 
 Vier Telefone verwalten, die von verschiedenen Locations an eine zentrale Funken und in den jeweiligen Räumen ein Ereignis auslösen.
 
 */

//Libraries
import javax.print.*;
import java.net.MalformedURLException;
import oscP5.*;
import netP5.*;
import processing.pdf.*;


PImage dok1,dok2;
int dokcount = 0;

//Network OSC-Communication
OscP5 osc,oscevent;
NetAddress hostAdress,homeAdress;

//OSC-Receive
String InputAdresse = "";

//Telefone
TelefonObjekt telefonBar, telefonBad, telefonDezernat, telefonKrankenhaus;

//OSC-Send
String EVENT = "LEER";
String EVENTCASH = "TEST";
String RECIEVECASH = "TEST";
String OSCPATH = "/LEER";
String OSCPATHINTERN = "/LEER";


void setup() {

  // OSC Instanzen
  osc = new OscP5(this, 11000);
  oscevent = new OscP5(this, 11022);
  hostAdress = new NetAddress("192.168.2.2", 11111);//"192.168.2.2"
  homeAdress = new NetAddress("127.0.0.1", 11022);//"192.168.2.2"

  // Display
  size(400, 400);
  background(125, 100);

  //Telefoneaufrufen

  //telefonBar = new TelefonObjekt("BAR");
  //telefonBad = new TelefonObjekt("BAD");
  telefonKrankenhaus = new TelefonObjekt("KRANKENHAUS");
  telefonDezernat = new TelefonObjekt("DEZERNAT");
}

void draw() {

  //eventSend(OSCPATH,EVENT);
}


// OSC-Kommunikation Global

void eventSend(String pfad, String event, NetAddress address)
{
  // create an osc message to maxmsp
  OscMessage myMessage = new OscMessage(pfad);
  myMessage.add(event); // add an int to the osc message 

  // send the message
  osc.send(myMessage, address);  
}

void oscEvent(OscMessage telefonOsc)        
{ 
  
  String[] OscList = split(telefonOsc.addrPattern(), '/');
  
  if(OscList[1].equals("EVENT")){
   
  }else{
  
    InputAdresse = telefonOsc.addrPattern();
    
  }

  // print out the message
  print("OSC Message Recieved: ");
  print(telefonOsc.addrPattern() + " ");
  println(telefonOsc);
}

void printPDF(String filename) {
  println("Printing "+filename);

  PrintService defaultPrintService = PrintServiceLookup.lookupDefaultPrintService();
  DocPrintJob printerJob = defaultPrintService.createPrintJob();
  File pdfFile = new File(sketchPath(filename));
  SimpleDoc simpleDoc = null;
  try {
    simpleDoc = new SimpleDoc(pdfFile.toURL(), DocFlavor.URL.AUTOSENSE, null);
  }
  catch (MalformedURLException ex) {
    ex.printStackTrace();
  }
  try {
    printerJob.print(simpleDoc, null);
  }
  catch (PrintException ex) {
    ex.printStackTrace();
  }
  
  //String[] params = {"lp " + ~/Documents/Processing/Toxik/TelefoneToxik_v4/data/mailbox.pdf"};
  //exec(params);
   
}