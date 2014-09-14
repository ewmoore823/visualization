//doesn't work with negatives as of now
//let the user specify the color of the hovered bar color

int BUFFER = 10;

int NUM_INTERVALS = 10;
class BarChart{
  Rectangle GraphOutline;
  float range;
  float w, h, posx, posy;
  String[] keys,labels;
  float[] values;
  color barColor;
  color backgroundColor, hoverColor;
  float maxOfValues;
  float minOfValues;
  Rectangle[] bars;
  Circle[] circles;
  BarChart(float w1, float h1, float posx1, float posy1, String[] keys1, float[] values1, String[]labels1, color barColor1, color backgroundColor1, color hoverColor1){
    //data initialization; 
    w = w1;
     h = h1;
     posx = posx1;
     posy = posy1;
     keys = keys1;
     labels = labels1;
     values = values1;
     barColor = barColor1;
     backgroundColor = backgroundColor1;
     hoverColor = hoverColor1;
     bars = new Rectangle[keys.length];
     circles = new Circle[keys.length];
     Display();
  }
  
  //where everything is called - basically this class' draw function
  void Display(){
    GraphOutline = new Rectangle(w, h, posx,posy, "", backgroundColor);
    drawLabels();
    
    //if some state, draw bars, else draw lines
    
    drawLineGraph();
    //drawBars();
    //checkBarHover();
  }
  
  void drawLineGraph(){
     drawCircles(); 
     checkCircleHover();
  }
  void drawCircles(){
     float xInterval = w/keys.length;
     for (int i = 0; i< keys.length; i++){
        float centerX = posx + xInterval * i + xInterval/2;
        float centerY = posy + h - (values[i]/range * h); 
        circles[i] = new Circle(centerX, centerY, (float)width/80, barColor);  
     } 
  }
  
    void checkBarHover(){
     int toolTipIndex = -1;
     for(int i = 0; i<keys.length;i++){
        if(bars[i].within()){
           bars[i].C1 = hoverColor;
           bars[i].Display();
           toolTipIndex = i;
        }
        else{
           bars[i].C1 = barColor;
            bars[i].Display();       
        }
     } 
     if(toolTipIndex!=-1){
       displayAdditionalInfo(toolTipIndex);
     }
  }
  void checkCircleHover(){
    int toolTipIndex = -1;
     for(int i = 0; i<keys.length; i++){
        if(circles[i].within()){
           circles[i].C1 = hoverColor;
           circles[i].Display();
           toolTipIndex = i;
        }
        else{
          circles[i].C1 = barColor;
          circles[i].Display();
        }

     } 
     if(toolTipIndex!=-1){
           displayAdditionalInfo(toolTipIndex);
     }
  }
  void drawLabels(){
    fill(0, 102, 153);
    textAlign(LEFT);
          textSize(12);

    text(labels[1],BUFFER, posy + h/2);
        textAlign(CENTER); 
    text(labels[0],posx + w/2, height - BUFFER);
    labelAxes();
    
  }
  void drawBars(){
    int xInterval = (int)w/keys.length;
    int intervalBuffer = xInterval*1/8;
    Rectangle temp;
     for(int i = 0; i < keys.length; i++){
       float barHeight = (values[i]/range * h);
        temp = new Rectangle(xInterval-intervalBuffer,barHeight,posx + i*xInterval + intervalBuffer/2, posy + h - barHeight,"",barColor);
        bars[i] = temp;        
     } 
  }

  
  //displays the x value and y value when hovered over
  void displayAdditionalInfo(int index){
        String info = "(" + keys[index] + ", " + Float.toString(values[index]) + ")";
        textAlign(CENTER);
        textSize(17);
        fill(color (0,0,0));
        text(info, mouseX, mouseY-20);
  }
  void labelAxes(){
    findMaxMin(); 
    labelYAxis();
    labelXAxis();
  }
  void labelYAxis(){
       int startingPoint;
    if(minOfValues > 0){
      startingPoint = 0;
    }
    else{
      startingPoint = (int)minOfValues;
    }
    range = (abs(maxOfValues) + abs(startingPoint));
    int interval = (int)range/10 +1;
    int currInterval = 0;
    for(int i = 0; i <= NUM_INTERVALS; i++){
      currInterval = startingPoint + i*interval;
      String currText = Float.toString(currInterval);
      textSize(12);
       text(currText, posx - BUFFER, posy + h - h/10*i);
    }
    range = currInterval; 
  }
  void labelXAxis(){
     int interval = (int)w/keys.length;
     for(int i = 0; i < keys.length; i++){
        textAlign(CENTER);
        textSize(10);
        text(keys[i],i*interval + posx, posy+h+BUFFER,interval, posy+h+BUFFER + 1/10*height);
     } 
  }
  
  void findMaxMin(){
    maxOfValues = values[0];
    minOfValues = values[0];
    for(int i = 1; i<values.length;i++){
       if(maxOfValues < values[i]){
         maxOfValues = values[i]; 
       }
       if(minOfValues > values[i]){
         minOfValues = values[i];
       }
    }
  }
}
