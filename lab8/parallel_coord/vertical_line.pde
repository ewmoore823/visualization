//This class is for the four vertical lines that contain the data points

class vertical_line {
   String label;  //The label at the bottom of the line
   float[] values;
    float posx;  //Top of line
    float posy;  //Top of line
    float lineHeight;  
    //TODO: put an instance of label class here also
    
    vertical_line (String label1, float[]values1, float posx1, float posy1, float lineHeight1) {
      label = label1;
      float[] values = new float[values1.length];
      values = values1;
      posx = posx1;
      posy = posy1;
      lineHeight = lineHeight1;
    }      
