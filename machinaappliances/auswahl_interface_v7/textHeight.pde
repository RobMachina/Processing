int calculateTextHeight(String string, int specificWidth, int fontSize, int lineSpacing) {
  String[] wordsArray;
  String tempString = "";
  int numLines = 0;
  float textHeight;
 
  wordsArray = split(string," ");
 
  for (int z=0; z < wordsArray.length; z++) {
    tempString += wordsArray[z] + " ";
    if (textWidth(tempString) < 10) {
       //tempString += wordsArray[i] + " ";
       println(tempString);
    }
    else {
     tempString = " ";
     numLines++;
    }
  }
   
  numLines = numLines + 1 ; //adds the last line
  //numLines++; //adds the last line
  //println(numLines); 
  textHeight = numLines * (textDescent() + textAscent() + lineSpacing); 
  return(numLines);//round(textHeight)
} 