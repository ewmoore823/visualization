class Bucket{
 String category;
 int count;
 float posx;
 float posy;
 float w;
 float h;
 color col;
 Rectangle rect;
  //hashmap:
 //for each distinct IP: # of instances of IP
 HashMap<String, Integer> ips;
 HashMap<String, ArrayList<String>> time_port;
  //another hashmap:
  //      key -- distinct time
 //      value --- arraylist of source ports. contains duplicates
 
 Bucket(String category1, HashMap<String, Integer> ips1, HashMap<String, ArrayList<String>> time_port1, int count1) {
   category = category1;
   ips = ips1;
   time_port = time_port1;
   count = count1;
//   col = color(175, 100, 220);

 }
 
 void populateRect() {
   rect = new Rectangle(posx, posy, w, h, category, col);
 }
 void Display() {
   rect.Display();
 }
 
}


