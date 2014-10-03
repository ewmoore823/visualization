//doesn't work with negatives as of now
//let the user specify the color of the hovered bar color
int NUM_INTERVALS = 10;
class ChartController{
  //make an is_active() function in each class
  boolean lineGraph = true;
  boolean pieGraph = false;              //TAY ADD
  boolean barGraph = false;              //TAY ADD
  float posx, posy, w, h;
  Rectangle GraphOutline;
  
  BarGraph bar_graph;
  LineGraph line_graph;
  ChartController(float posx1, float posy1,float w1, float h1, String[] keys, float[] values, String[]labels, color barColor, color backgroundColor, color hoverColor){
      posx = posx1;
      posy = posy1;
      w = w1;
      h = h1;
     bar_graph = new BarGraph(posx,posy,w,h, keys, values, labels, barColor, backgroundColor, hoverColor);
     line_graph = new LineGraph(posx,posy,w,h, keys, values, labels, backgroundColor, hoverColor);
     Display();
  }
  
  //where everything is called - basically this class' draw function
  void Display(){
    updateSizes();

    if (lineGraph) {              
      line_graph.Update();
    } else if (barGraph) {
       bar_graph.Update();
    } else {
      //drawPieGraph();
    }
  }
  void updateSizes(){
     bar_graph.w = width*6/10;
     bar_graph.h = height*6/10;
     bar_graph.posx = width* 2/10;
     bar_graph.posy = height*1/10;
     line_graph.w = width*6/10;
     line_graph.h = height*6/10;
     line_graph.posx = width* 2/10;
     line_graph.posy = height*1/10;
     
  }
    void drawPieGraph() {
    float[] angles = new float[values.length];
    float sum = 0;
    //calculate the sum of the values:
    for (int i = 0; i < values.length; i++) {
      sum = sum + values[i];
    }
    //populate the angles array:
    for (int i = 0; i < values.length; i++) {
      angles[i] = ((values[i]/ sum) * 360);
    }
    float smallerEdge = height;
    if (width < height) {
      smallerEdge = width;
    }
    drawPie(smallerEdge - (smallerEdge/2), angles);
  }
  
  void drawPie(float diameter, float[] angles) {
    float lastAngle = 0;
    for (int i = 0; i < angles.length; i++) {
      float shade = map(i, 0, angles.length, 0, 255);      //converting it to a shade of gray
      fill(shade);
      arc(GraphOutline.posx + GraphOutline.w/2, GraphOutline.posy + GraphOutline.h/2, diameter, diameter, lastAngle, lastAngle+radians(angles[i]));
      lastAngle += radians(angles[i]);
    }
  }
  // Sequence: linegraph -> bargraph -> piegraph -> linegraph */
  void switchState(){
    if(lineGraph){
      lineGraph = false;
      barGraph = true;
    }
    else if (pieGraph) {
      pieGraph = false;
      lineGraph = true;
    }
    else {
      barGraph = false;
      pieGraph = true;
    }
  }
}
