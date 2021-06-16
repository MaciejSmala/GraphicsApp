////////////////////////////////////////////////////////////////////
// DrawingList Class
// this class stores all the drawn shapes during and after thay have been drawn
//
// 


class DrawingList {

  ArrayList<DrawnShape> shapeList = new ArrayList<DrawnShape>();

  // this references the currently drawn shape. It is set to null
  // if no shape is currently being drawn
  public DrawnShape currentlyDrawnShape = null;

  public DrawingList() {
  }
  
  public void drawMe() {
    for (DrawnShape s : shapeList) {
      s.drawMe();
    }
  }


  public void handleMouseDrawEvent(String shapeType, String mouseEventType, PVector mouseLoc) {

    if ( mouseEventType.equals("mousePressed")) {
      DrawnShape newShape = new DrawnShape(shapeType);
      newShape.startMouseDrawing(mouseLoc);
      shapeList.add(newShape);
      currentlyDrawnShape = newShape;
    }

    if ( mouseEventType.equals("mouseDragged")) {
      currentlyDrawnShape.duringMouseDrawing(mouseLoc);
    }

    if ( mouseEventType.equals("mouseReleased")) {
      currentlyDrawnShape.endMouseDrawing(mouseLoc);
    }
  }


  

  public void trySelect(String mouseEventType, PVector mouseLoc) {
    if( mouseEventType.equals("mousePressed")){
      
      for (DrawnShape s : shapeList) {
        boolean selectionFound = s.tryToggleSelect(mouseLoc);
       if (selectionFound) break;
      }
      
    }
    
  }
  
  
  void deleteSelected(){
    ArrayList<DrawnShape> tempShapeList = new ArrayList<DrawnShape>();
    for (DrawnShape s : shapeList) {
     
        if (s.isSelected == false) tempShapeList.add(s);
      }
    shapeList = tempShapeList;
  }
  
  
  
}
