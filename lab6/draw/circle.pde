class Circle{
   float centerX;
   float centerY;
   float origX, origY;
   float radius, origRadius;
   
   color C1;
    Circle(float centerX1, float centerY1, float radius1, color originalColor1){
        origRadius = radius1;
        centerX = centerX1;
        centerY = centerY1;
        origX = centerX;
        origY = centerY;
        radius = radius1;
        origRadius = radius1;
        C1 = originalColor1;
        //Display();
    }
    void Display(){
        fill(C1);
        ellipse(centerX, centerY, radius*2,radius*2);
    }
    boolean within(){
      double squareX = Math.pow(mouseX - centerX,2);
      double squareY = Math.pow(mouseY - centerY,2);
       if(squareX + squareY <= Math.pow(radius,2)){
//          return true;   //TEMPORARY-- FOR LAB 6. to remove hovering
       } 
       return false;
    }   
}
