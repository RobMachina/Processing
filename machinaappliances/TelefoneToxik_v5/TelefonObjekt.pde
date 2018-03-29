//TelefonObjekt
public class TelefonObjekt {

  //Telefoneingabe
  String nummer = "";

  //Mailbox-Abfrage
  String index = "1";
  int versuche = 3;
  int richtig = 0;

  //Telefonstatus
  Boolean aufgelegt = true; // true as long as the the telefon is hungup
  Boolean angerufen = false; // false as long as nobody is called
  Boolean auswahl = false; //false as long as the auswahl is not called
  Boolean service = false; //false as long as the service is not called
  Boolean security = false; //false as long as security is not called
  Boolean question = false; //false as long as question is not active
  Boolean closed = false; //false as long as SPERRUNG is not active

  //XML Databenbank
  XML telefonbuch, levelup;
  XML[] level, seclevel;

  String xmlfile;

  String ort;
  
  String locEvent="";

  public TelefonObjekt (String location) {

    ort = location;
    //OSC Pluggen
    osc.plug(this, "inputStatus", "/"+location+"/TELEFON/STATUS");
    osc.plug(this, "inputTasten", "/"+location+"/TELEFON/TASTE");
    oscevent.plug(this, "internEvent", "/"+location+"/TELEFON/EVENT");
    oscevent.plug(this, "maxEvent", "/EVENT");
    
    //XMLs Laden
    xmlfile = "telefonbuch.xml";//"telefonbuch_"+location+".xml";
    telefonbuch = loadXML(xmlfile);
    level=telefonbuch.getChildren("eintrag");
  }

  void inputTasten(String taste)
  {
    String OscInput = InputAdresse;
    String[] OscList = split(OscInput, '/');

    //OSCPATH = "/"+OscList[1]+"/"+OscList[2];
    OSCPATH = "/"+OscList[1]+"/"+OscList[2]+"/EVENT";

    //println(taste+" "+angerufen+" "+aufgelegt);

    if (!aufgelegt) {

      nummer += taste; // neue Taste hinzufuegen

      println(InputAdresse+": " + nummer);

      //EVENT = "tastendruck";

      if (!auswahl&&!service&&!security) {
        if (nummer.length()<20) {
          checkNumber(nummer);// Funktion zum Prüfen der Telefonnummer
        } else {
          angerufen = true;
          EVENT = "NOCONNECTION";
          nummer = "";
        }
      } else if (!auswahl&&service&&!security) {
        if (nummer.length()<15) {
          checkNumber(nummer);// Funktion zum Prüfen der Telefonnummer
        } else {
          angerufen = true;
          EVENT = "WRONGNUMBER";
          nummer = "";
        }
      } else if (auswahl&&!service&&!security) {
        if (nummer.length()<2) {
          checkNumber(nummer);// Funktion zum Prüfen der Telefonnummer
        } else {
          println(OSCPATH);
          eventSend(OSCPATH, "AUTOTASTE", homeAdress);
          angerufen = true;
          EVENT = "WRONGINPUT";
          nummer = "";
        }
      } else if (!auswahl&&!service&&security) {
        if (nummer.length()<2) {
          checkNumber(nummer);// Funktion zum Prüfen der Telefonnummer
        } else {
          angerufen = true;
          EVENT = "WRONGINPUT";
          nummer = "";
        }
      }

      
      if(!EVENT.equals(EVENTCASH)){
        locEvent=ort+"_"+EVENT;
        println(locEvent); 
        println(OSCPATH);
        eventSend(OSCPATH, locEvent, hostAdress);
        EVENTCASH = EVENT;
      }

      if (EVENT.equals("SERVICECALL")) {
        service = true;
        auswahl = false;
        security = false;
      } else if (EVENT.equals("SERVICEPORTAL")) {
        auswahl = true;
        service = false;
        security = false;
      } else if(EVENT.equals("MAILBOX")){
         if(!closed){
           security = true;
           auswahl = false;
           service = false;
         }else{
           EVENT = "SPERRUNG";
           locEvent=ort+"_"+EVENT;
           println(locEvent); 
           eventSend(OSCPATH, locEvent, hostAdress);
           aufgelegt = true;
         }
      }else if(EVENT.equals("SPERRUNG")){
         security = false;
         closed = true;
      }
    }
  }		

  //Abfrage des Status Aufgelegt oder Abgehoben
  void inputStatus(String state)
  {
    println(state);
    //Incoming Status
    String OscInput = InputAdresse;
    String[] OscList = split(OscInput, '/');

    OSCPATH = "/"+OscList[1]+"/"+OscList[2]+"/EVENT";

    if (state.equals("aufgelegt")) {

      nummer ="";
      level=telefonbuch.getChildren("eintrag");
      angerufen = false;
      auswahl = false;
      security = false;
      question = false;
      service = false;
      aufgelegt = true;
      EVENT = "TELEFONSTOP";
    } else if (state.equals("abgehoben")) {
      aufgelegt = false;
      EVENT = "FREIZEICHEN";
    } else if (state.equals("eingesteckt")) {
      EVENT = "EINGESTECKT";
    } else if (state.equals("ausgesteckt")) {
      EVENT = "AUSGESTECKT";
    } else {  
      // wenn nichts zutrifft
    }
    //question = false;
    //println(EVENT);
    if(!EVENT.equals(EVENTCASH)){
      locEvent=ort+"_"+EVENT;
      println(locEvent); 
      println(OSCPATH);
      eventSend(OSCPATH, locEvent, hostAdress);
      EVENTCASH = EVENT;
    }
  }

  //Überprüfen ob die gewählte Nummer im Telefonbuch steht und Event auslösen

  void checkNumber(String number)
  { 
    if (security) {
      for (int i = 0; i < seclevel.length; ++i) {
        if (!question) {          
          String checkindex = seclevel[i].getString("index");
          if (index.equals(checkindex)) {

            //EVENT = seclevel[i].getString("event");

            if (index.equals("1")&&versuche < 3) {
              EVENT = "SICHERHEITSFRAGEEINS" + versuche;
            } else if(index.equals("2")&&versuche < 3) {              
              EVENT = "SICHERHEITSFRAGEZWEI" + versuche;
            } else if(index.equals("3")&&versuche < 3){
              EVENT = "SICHERHEITSFRAGEDREI" + versuche;
            } else{
              EVENT = seclevel[i].getString("event");
            }
           
            if (seclevel[i].hasAttribute("jumpto")) {
              String jumpto = seclevel[i].getString("jumpto");
              seclevel=seclevel[i].getChildren(jumpto);
              //println(seclevel);
              nummer = "";
              question = true;
              break;
            }
          }
        } else {
          String checknumber = seclevel[i].getString("nr");
          if (number.equals(checknumber)) {
            if (seclevel[i].getString("query").equals("falsch")) {
              //index = "1";
              seclevel = level;
              versuche = versuche - 1;
              println("falsch");
              EVENT = "FLASCH";
              if (versuche == 0) {
                EVENT = "SPERRUNG";
              }                
              question = false;
              nummer ="";
              println(OSCPATH);
              eventSend(OSCPATH, "AUTOTASTE", homeAdress);
              break;
            } else {
              int intex = int(index)+1;
              index = ""+intex;
              seclevel = level;
              richtig = richtig + 1;
              println("richtig");
              EVENT = "RICHTIG";
              if (richtig == 3) {
                EVENT = "ENTSPERRUNG";
              } 
              question = false;
              //println(seclevel);
              nummer ="";
              println(OSCPATH);
              eventSend(OSCPATH, "AUTOTASTE", homeAdress);
              break;
            }
          }/*else{
           EVENT = "KEINEAUSWAHL";
           }*/
        }
      }
    } else {
      for (int i = 0; i < level.length; ++i) {
        String checknumber = level[i].getString("nr");

        if (number.equals(checknumber)) {

          EVENT = level[i].getString("event"); //EVENT wir eingelesen fürs Versenden

          //wenn der Eintrag ein jumpto Attribut hat, springt er eine Ebene tiefer
          if (level[i].hasAttribute("jumpto")) {
            String jumpto = level[i].getString("jumpto");
            //Sprung in Sicherheitsabfrage
            if (jumpto.equals("questioneins")) {
              seclevel=level[i].getChildren(jumpto); 
              level=level[i].getChildren();
              nummer ="";
              println(OSCPATH);
              eventSend(OSCPATH, "AUTOTASTE", homeAdress);
              break;
            } else {
              level=level[i].getChildren(jumpto);
              nummer ="";
              angerufen = true;
              break;
            }
          }
          nummer = "";
        }
      }
    }
  }

 void internEvent(String event) {
   
   if (event.equals("AUTOTASTE")) {
     println(event + "AUTO");
     inputTasten("");  
   }else  if (event.equals("RESET")) {
     versuche = 3;
     richtig = 0;
     aufgelegt = true; 
   }
  }
  
  void maxEvent(String event) {
   
  if(!event.equals(RECIEVECASH)){  
     if (event.equals("RESET")) {
       println("RESET");
       versuche = 3;
       richtig = 0;
       closed = false;
       aufgelegt = true; 
     }else if (event.equals("BALLISTIKER")) {
        printPDF("ballistiker.pdf"); 
     }else if (event.equals("DEZERNAT_ENTSPERRUNG")||event.equals("KRANKENHAUS_ENTSPERRUNG")||event.equals("ENTSPERRUNG")) {
        printPDF("mailbox.pdf"); 
     }
     
     RECIEVECASH = event;
   }
  }
}