//
// DrawnShape
// This class stores a draw shapes active on the canvas, and is responsible for
// 1/ Interpreting the mouse moves to successfully draw a shape
// 2/ Redrawing the shape every frame, once it is drawn
// 3/ Detecting selection events, and selecting the shape if necessary
// 4/ modifying the shape once it is drawn through further actions

class DrawnShape {
  // type of shape
  // line
  // ellipse
  // Rect .....
  String shapeType;

  // used to define the shape bounds during drawing and after
  PVector shapeStartPoint, shapeEndPoint;

  boolean isSelected = false;
  
  
  
  public DrawnShape(String shapeType) {
    this.shapeType  = shapeType;
  }


  public void startMouseDrawing(PVector startPoint) {
    this.shapeStartPoint = startPoint;
    this.shapeEndPoint = startPoint;
  }



  public void duringMouseDrawing(PVector dragPoint) {
    this.shapeEndPoint = dragPoint;
  }


  public void endMouseDrawing(PVector endPoint) {
    this.shapeEndPoint = endPoint;
  }


  public boolean tryToggleSelect(PVector p) {
    
    UIRect boundingBox = new UIRect(shapeStartPoint, shapeEndPoint);
   
    if ( boundingBox.isPointInside(p)) {
      this.isSelected = !this.isSelected;
      return true;
    }
    return false;
  }



  public void drawMe() {

    if (this.isSelected) {
        setSelectedDrawingStyle();
      }else{
        setDefaultDrawingStyle(); 
      }
    
    float x1 = this.shapeStartPoint.x;
    float y1 = this.shapeStartPoint.y;
    float x2 = this.shapeEndPoint.x;
    float y2 = this.shapeEndPoint.y;
    float w = x2-x1;
    float h = y2-y1;
    
    if ( shapeType.equals("rect")) rect(x1, y1, w, h);
    if ( shapeType.equals("ellipse")) ellipse(x1+ w/2, y1 + h/2, w, h);
    if ( shapeType.equals("line")) line(x1, y1, x2, y2);
    if ( shapeType.equals("circle")) circle(x1+w/2, y1+h/2, w);

  }

  void setSelectedDrawingStyle() {
    strokeWeight(2);
    stroke(0, 0, 0);
    fill(255, 100, 100);
    
  }

  void setDefaultDrawingStyle() {
    //strokeWeight(1);
    //stroke(0, 0, 0);
    //fill(127, 127, 127);
    float r = 0, g = 0, b = 0;
    if ( myUI.getToggleButtonState("Use sliders") ) {
    r = myUI.getSliderValue("Red")*255;
    g = myUI.getSliderValue("Green")*255;
    b = myUI.getSliderValue("Blue")*255;
  }
  if ( myUI.getToggleButtonState("Use text boxes") ) {
    r = int(  myUI.getText("R")  );
    g = int(myUI.getText("G"));
    b = int(myUI.getText("B"));
  }
  int strWeight = int(  myUI.getText("S")  );
 if ( myUI.getToggleButtonState("show fill") )
  { 
    fill(r, g, b);
  } else {
    noFill();
  }

  if ( myUI.getToggleButtonState("show line") )
  { 
    stroke(r, g, b);
    strokeWeight(1);
  } else {
    noStroke();
  }
  if(strWeight!=0){
  strokeWeight(strWeight);
    }
  }
}     // end DrawnShape
