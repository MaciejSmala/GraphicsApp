// Foolowing on from the example
// DrawSingleShape_CodeExample in week 1 of this unit.
// This example can draw multiple shapes

// Each shape is now contained in a DrawnShape object
// It uses a "DrawingList" to contain all the DrawnShape instances
// as the user creates them

float[][] edge_matrix = { { 0,  -2,  0 },
                          { -2,  8, -2 },
                          { 0,  -2,  0 } }; 
                     
float[][] blur_matrix = {  {0.1,  0.1,  0.1 },
                           {0.1,  0.1,  0.1 },
                           {0.1,  0.1,  0.1 } };                      

float[][] sharpen_matrix = {  { 0, -1, 0 },
                              {-1, 5, -1 },
                              { 0, -1, 0 } };  
float[][] gaussianblur_matrix = { { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.001,  0.020,  0.109, 0.172, 0.109, 0.020, 0.001},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000}
                                  };
                              
PImage myImage;
PImage outputImage;
PImage canvasToSave;
SimpleUI myUI;
DrawingList drawingList;

String toolMode = "";

void setup() {
  size(900,750);
  
  myUI = new SimpleUI();
  drawingList = new DrawingList();
  
  ButtonBaseClass  rectButton = myUI.addRadioButton("rect", 5, 50, "group1");
  myUI.addRadioButton("ellipse", 5, 80, "group1");
  myUI.addRadioButton("line", 5, 110, "group1");
  myUI.addRadioButton("circle", 5, 140, "group1");
  rectButton.selected = true;
  toolMode = rectButton.UILabel;
  
  // add a new tool .. the select tool
  myUI.addRadioButton("select", 5, 180, "group1");
  
  myUI.addToggleButton("show fill", 5, 250).setSelected(true);
  myUI.addToggleButton("show line", 5, 280);
  
    myUI.addRadioButton("Use sliders", 5, 320, "colour setting choice").setSelected(true);
  // add sliders
  myUI.addSlider("Red", 5, 350);
  myUI.addSlider("Green", 5, 380);
  myUI.addSlider("Blue", 5, 410);

  myUI.addRadioButton("Use text boxes", 5, 450, "colour setting choice");
  // add text input boxes
  myUI.addTextInputBox("R", 5, 480, "0");
  myUI.addTextInputBox("G", 5, 510, "0");
  myUI.addTextInputBox("B", 5, 540, "0");
  
  myUI.addLabel("Stroke Weight",5,600,"");
  myUI.addTextInputBox("S", 5, 630, "0");
  
  myUI.addPlainButton("openFile", 620,5);
  myUI.addPlainButton("saveFile", 690,5);
  
  String[] items = { "brighten", "darken", "contrast", "negative","greyscale","edges","blur","sharpen","gaussianblur"};
  myUI.addMenu("Effect", 100, 5, items );
  
  myUI.addPlainButton("undo", 200,5);
  
  myUI.addCanvas(130,60,730,660);
  
}



void draw() {
 background(255);

    if( myImage != null ){
        checkSize(myImage);
        image(myImage,130,60);
        //outputImage = myImage.copy();
        if(outputImage != null){
          image(outputImage, 130, 60);
        }
        //outputImage = myImage.copy();
  }
   drawingList.drawMe();
 myUI.update();
 
}

void checkSize(PImage image){
  if((image.width>590) || (image.height>590)){
       image.width=590;
       image.height=590;
  }
}
void conv_filter(PImage myImage,float[][] matrix){
  checkSize(myImage);
  for(int y = 0; y < myImage.width; y++){
    for(int x = 0; x < myImage.height; x++){
    
    color c = convolution(x, y, matrix, 3, myImage);
    
    outputImage.set(x,y,c);
     }
   }
}

void handleUIEvent(UIEventData eventData){
  if( eventData.eventIsFromWidget("openFile")) {    
       myUI.openFileLoadDialog("open an image");
    }
      if(eventData.eventIsFromWidget("fileLoadDialog")){
       myImage=loadImage(eventData.fileSelection);
        checkSize(myImage);
        //image(myImage,110,10);
        outputImage = myImage.copy();
        checkSize(outputImage);
        //outputImage.width=590;
        //outputImage.height=560;
        
  }
  if(eventData.eventIsFromWidget("saveFile")){
    myUI.openFileSaveDialog("save an image");
  }
  
  //this catches the file save information when the file save dialogue's "save" button is hit
  if(eventData.eventIsFromWidget("fileSaveDialog")){
     canvasToSave= get(131,61,729,659);
    canvasToSave.save(eventData.fileSelection);
  }
  
  if( eventData.eventIsFromWidget("brighten")){
    int[] lut =  makeLUT("brighten", 1.5, 0.0);
    outputImage = applyPointProcessing(lut, myImage);
  }
  
  if( eventData.eventIsFromWidget("darken")){
    int[] lut =  makeLUT("brighten", 0.5, 0.0);
    outputImage = applyPointProcessing(lut, myImage);
  }
  
 if(myImage!=null){
  if( eventData.eventIsFromWidget("contrast")){
    int[] lut =  makeLUT("sigmoid", 0.0, 0.0);
    outputImage = applyPointProcessing(lut, myImage);
  }
  
  if( eventData.eventIsFromWidget("negative")){
    int[] lut =  makeLUT("negative", 0.0, 0.0);
    outputImage = applyPointProcessing(lut, myImage);
  }
  if( eventData.eventIsFromWidget("greyscale")){
    checkSize(myImage);
  for (int y = 0; y < myImage.height; y++) {
    for (int x = 0; x < myImage.width; x++) {
    
    color c = myImage.get(x,y);
    
    int r = (int)red(c);
    int g = (int)green(c);
    int b = (int)blue(c);
    int grey = (int)(r+g+b)/3;
     outputImage.set(x,y, color(grey,grey,grey));
     }
  }
  
  }
  if( eventData.eventIsFromWidget("edges")){
    conv_filter(myImage,edge_matrix);
  }
  if( eventData.eventIsFromWidget("blur")){
    conv_filter(myImage,blur_matrix);
  }
  if( eventData.eventIsFromWidget("sharpen")){
    conv_filter(myImage,sharpen_matrix);
  }
if( eventData.eventIsFromWidget("gaussianblur")){
  checkSize(myImage);
    for(int y = 0; y < myImage.width; y++){
    for(int x = 0; x < myImage.height; x++){
    
    color c = convolution(x, y, gaussianblur_matrix, 7, myImage);
    
    outputImage.set(x,y,c);
   }
   }
  }
  if( eventData.eventIsFromWidget("undo")){
    outputImage = myImage.copy();
    checkSize(outputImage);
    
  }
 }
  
  // if from a tool-mode button, the just set the current tool mode string 
  if(eventData.uiComponentType == "RadioButton"){
    toolMode = eventData.uiLabel;
    return;
  }

  // only canvas events below here! First get the mouse point
  if(eventData.eventIsFromWidget("canvas")==false) return;
  PVector p =  new PVector(eventData.mousex, eventData.mousey);
  
  // this next line catches all the tool shape-drawing modes 
  // so that drawing events are sent to the display list class only if the current tool 
  // is a shape drawing tool
  if( toolMode.equals("rect") || 
      toolMode.equals("ellipse") || toolMode.equals("circle") || 
      toolMode.equals("line")) {    
     drawingList.handleMouseDrawEvent(toolMode,eventData.mouseEventType, p);
     return;
  }
   
  // if the current tool is "select" then do this
  if( toolMode.equals("select") ) {    
      drawingList.trySelect(eventData.mouseEventType, p);
    }
    
  

}
int[] makeLUT(String functionName, float param1, float param2){
  int[] lut = new int[256];
  for(int n = 0; n < 256; n++) {
    
    float p = n/255.0f;  // p ranges between 0...1
    float val = getValueFromFunction( p, functionName,  param1,  param2);
    lut[n] = (int)(val*255);
  }
  return lut;
}
float getValueFromFunction(float inputVal, String functionName, float param1, float param2){
  if(functionName.equals("brighten")){
    return simpleScale(inputVal, param1);
  }
  
  if(functionName.equals("step")){
    return step(inputVal, (int)param1);
  }
  
  if(functionName.equals("negative")){
    return invert(inputVal);
  }
  
   if(functionName.equals("sigmoid")){
    return sigmoidCurve(inputVal);
  }
  
  // should only get here is the functionName is undefined
  return 0;
}
PImage applyPointProcessing(int[] LUT,  PImage inputImage){
  PImage outputImage = createImage(inputImage.width,inputImage.height,RGB);
  
  
  
 checkSize(inputImage);
  for (int y = 0; y < inputImage.height; y++) {
    for (int x = 0; x < inputImage.width; x++) {
    
    color c = inputImage.get(x,y);
    
    int r = (int)red(c);
    int g = (int)green(c);
    int b = (int)blue(c);
    
    int lutR = LUT[r];
    int lutG = LUT[g];
    int lutB = LUT[b];
    
    
    outputImage.set(x,y, color(lutR,lutG,lutB));
    
    }
  }
  
  return outputImage;
}
color convolution(int Xcen, int Ycen, float[][] matrix, int matrixsize, PImage myImage)
{
  checkSize(myImage);
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  // this is where we sample every pixel around the centre pixel
  // according to the sample-matrix size
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      
      //
      // work out which pixel are we testing
      int xloc = Xcen+i-offset;
      int yloc = Ycen+j-offset;
      
      // Make sure we haven't walked off our image
      if( xloc < 0 || xloc >= myImage.width) continue;
      if( yloc < 0 || yloc >= myImage.height) continue;
      
      
      // Calculate the convolution
      color col = myImage.get(xloc,yloc);
      rtotal += (red(col) * matrix[i][j]);
      gtotal += (green(col) * matrix[i][j]);
      btotal += (blue(col) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}
void keyPressed(){
  if(key == BACKSPACE){
    drawingList.deleteSelected();
  }
}
