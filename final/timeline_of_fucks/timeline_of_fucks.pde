import java.util.*;
//import processing.opengl.*;

String fi = "wowFuckInstances.csv";
String rf = "recordedFucks.csv";

float lerpAmount = 0;
float lerpAmount2 = 0;
float colorLerp = 0;
color white = color(255, 255, 255);
color red = color(186, 0, 25);
color currColor = white;
boolean lerpReady = false;  //set to true after freq_graph finishes. Lerping to line will begin
boolean transitionReady = false;//set to true after lerping finishes. Transition to heart rates begin
boolean heartSimulationReady = false;
heartbeat startingHeart;
int currentRate = 400;
int s_h_alpha = 250;
int countRounds = 30;
PFont font1 = createFont("monoscript", 70);
String str1 = "Compare this to";
float stringHeight = 250;//((height*.5)/2.0 + 70);
boolean secondStringSaid = false;

String [] fuck_strings;
float [] fuck_timestamps;
freq_graph bot;
heart_mgr hearts;
void setup(){
size(800,600);
//size(800, 600, OPENGL);
 parse_data();
 setGradient(0,(int).6*height,(float)width,(float)height, color(250,0,0), color(20,0,0));
 //bot = new freq_graph(fuck_strings, fuck_timestamps, 0.0,.75*height, (float)width, .25*height); 
  bot = new freq_graph(fuck_strings, fuck_timestamps, 0.0,.65*height, (float)width, .25*height); 
 hearts = new heart_mgr(3, 29, 56, 400);
 bot.intro();

  
}
void draw(){
//  setGradient(0,0,width,.75*height, color(250,250,250), color(30,30,30));
  //new Rectangle(0.0, 0.0 ,(float) width,(float).75*height, "",color(0,0,0));
  if ((lerpReady == false)&&(transitionReady == false) && (heartSimulationReady == false)) {
//      setGradient(0,0,width,.75*height, color(250,250,250), color(30,30,30));
      setGradient(0,0,width,.65*height, color(250,250,250), color(30,30,30));
  }
  bot.update();    //TAYLOR COMMENT OUT TEMP
  if (lerpReady == true) {
     setGradient(0,(int).6*height,(float)width,(float)height, color(250,0,0), color(20,0,0));
     //setGradient(0,0,width,.75*height, color(250,250,250), color(30,30,30));
          setGradient(0,0,width,.65*height, color(250,250,250), color(30,30,30));
    lerpFreqGraph();
  }
  if (transitionReady == true) {
     setGradient(0,(int).6*height,(float)width,(float)height, color(250,0,0), color(20,0,0));
     //setGradient(0,0,width,.75*height, color(250,250,250), color(30,30,30));
     setGradient(0,0,width,.65*height, color(250,250,250), color(30,30,30));
     StartHeartRate();
     hearts.update();
  }
  if (heartSimulationReady == true) {
    setGradient(0,(int).6*height,(float)width,(float)height, color(250,0,0), color(20,0,0));
 //   setGradient(0,0,width,.75*height, color(250,250,250), color(30,30,30));
     setGradient(0,0,width,.65*height, color(250,250,250), color(30,30,30));
    hearts.update();
  }
  
  //hearts.update();
  
  
}

void parse_data(){
  
  Table table = loadTable(fi);
  int index = 0;
  fuck_timestamps = new float[table.getRowCount()];
  for (TableRow row : table.rows()) {
      fuck_timestamps[index] = Float.parseFloat(row.getString(0));
      index++;
  }
  table = loadTable (rf);
  index = 0;
  fuck_strings = new String[table.getRowCount()];
  for (TableRow row : table.rows()) {
      fuck_strings[index] = row.getString(0);
      index++;
  }
}


void setGradient(int x, int y, float w, float h, color c1, color c2){
  // calculate differences between color components 
  float deltaR = red(c2)-red(c1);
  float deltaG = green(c2)-green(c1);
  float deltaB = blue(c2)-blue(c1);
    /*nested for loops set pixels
     in a basic table structure */
    for (int i=x; i<=(x+w); i++){
      // row
      for (int j = y; j<=(y+h); j++){
        color c = color(
        (red(c1)+(j-y)*(deltaR/h)),
        (green(c1)+(j-y)*(deltaG/h)),
        (blue(c1)+(j-y)*(deltaB/h)) 
          );
        set(i, j, c);
      }
    }  
  }
  
  void lerpFreqGraph() {
    
    for (int i = 0; i < xCoordStarts.length; i++) {
//      yCoordStarts[i] = lerp(.75*height, .9*height, lerpAmount);
      yCoordStarts[i] = lerp(.65*height, .9*height, lerpAmount);
      yCoordEnds[i] = lerp(yCoordEndsOrig[i], .9*height, lerpAmount);
      currColor = lerpColor(white, red, colorLerp);
      if (yCoordStarts[i] <= .9*height) {
        stroke(currColor);
        line(xCoordStarts[i], yCoordStarts[i], xCoordEnds[i], yCoordEnds[i]);
      } else {
        stroke(red);
        line(lerp(xCoordStarts[0], 0, lerpAmount2), .9*height, lerp(xCoordStarts[xCoordStarts.length-1], 800, lerpAmount2), .9*height);
        lerpAmount2+= .001;
        //lerpReady = false;
        //transitionReady = true;
      }
    }
    if (lerpAmount2 >= 1) {
      lerpReady = false;
      transitionReady = true;
    }
    lerpAmount+= .01;
    colorLerp+= .01;
  }
  
  
  void StartHeartRate() {
         if (currentRate > (MIN_ALLOWABLE_INVERSE + 10)) {
             startingHeart = new heartbeat(0, (int)(.9*height), currentRate);
             //currentRate = currentRate - 10;//MOVING THIS
         }
         startingHeart.update();
 //        if (!(currentRate  > (MIN_ALLOWABLE_INVERSE + 10))) {
 //          transitionReady = false;
 //          heartSimulationReady = true;
 //        }
         
//   if (!(currentRate > (MIN_ALLOWABLE_INVERSE + 10))) {      
     if (!(currentRate > (-500))) {      
          if(s_h_alpha > 5){
            fill(250,250,250,s_h_alpha);

           // PFont font = createFont("monoscript", 70);
            //String str = "Compare this to";
            textFont(font1);
            float len = textWidth(str1);
            //text(str,width/2.0-len/2.0,(height*.5)/2.0 + 70);
            text(str1,width/2.0-len/2.0,stringHeight);
            if (countRounds <= 0) { // just added
              s_h_alpha -=5;
            }                      //just added
            countRounds = countRounds - 1;
            print("Count Rounds is: " + countRounds + "\n");
         }
         else if(s_h_alpha < -200){
           s_h_alpha -=5;
         }
         print("ShAlpha is: " + s_h_alpha+ "\n");
   } else {
       currentRate = currentRate - 10;
   }
   if ((countRounds <= -49) && (secondStringSaid == false) && (s_h_alpha <= 5)) {
     if (stringHeight == 130) {//then its already been here because below this "if" statement, StringHeight is set to 130
         secondStringSaid = true;
         hearts.DisplayFirst = true;
     } else {
     print("its here");
     s_h_alpha = 250;
     str1 = "This movie";
     stringHeight = (130);
     font1 = createFont("monoscript", 40);
//     secondStringSaid = true;
     countRounds = 30;
     }
   } else if ((secondStringSaid == true)&&(s_h_alpha <= 5)) {
     if (stringHeight == 260) { // then it has already been here
     print("IT IS HERE ");
       hearts.DisplaySecond = true;
     } else {
       print("it is here 22222");
     s_h_alpha = 250;
     str1 = "This Other movie";
     stringHeight = 260;
     countRounds = 30;
     font1 = createFont("monoscript", 40);
     }
   }
         
}
