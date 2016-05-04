class Scenario{

  PVector carlocation;
  boolean sendswitch;
  
  Scenario(){
    
   sendswitch = false;
    
  }
  
  void run(){
    carlocation = car.getLocation().copy();
    draw_road();
     draw_Finish();
    pushMatrix();
    translate(0,0,5);
    draw_road();
    if(gui.get_GUI_State() != "PLANNER"){draw_buildings();}
    popMatrix();
    
    
  }
  
  // draw the road visual
  void draw_road(){
  
      
      pushMatrix();
                translate(0,0,-1.1);
                int margin = 75;
                fill(60);
                shape(road, gridWidth-margin, margin, gridWidth-(margin*2), gridHeight-(margin*2));
                translate(0,0,-1);
                stroke(255);
                fill(255,255,255);
                shape(roadlines, gridWidth-margin, margin, gridWidth-(margin*2), gridHeight-(margin*2));
               
      popMatrix();
  }
  
  void draw_buildings(){
    
        int buildingHeight = 270;
  
        for( int i = 0; i <6; i++){
        pushMatrix();
        translate(250 + i*220,250,-150);
        fill(255);
        box(120,80,buildingHeight);
        popMatrix();
        }
        
        for( int i = 0; i <6; i++){
        pushMatrix();
        translate(250 + i*220,550,-150);
        fill(255);
        box(80,120,buildingHeight);
        popMatrix();
        }
        
        // top
        
        for( int i = 0; i <6; i++){
        pushMatrix();
        translate(200 + i*240,0,-150);
        fill(255);
        box(200,80,buildingHeight);
        popMatrix();
        }
        
        // bottom
        
        for( int i = 0; i <6; i++){
        pushMatrix();
        translate(200 + i*240,gridHeight,-150);
        fill(255);
        box(200,80,buildingHeight);
        popMatrix();
        }
  }
  
  void draw_Finish(){
       fill(200,200,0);
       pushMatrix();
        translate(750,450,0);
        //fill(255);
        box(10,10,120);
        popMatrix();
        
        pushMatrix();
        translate(850,450,0);
        //fill(255);
        box(10,10,120);
        popMatrix();
  
  }
  
  void scenario1(){
    int margin = 75;
    // scenario 1 visuals
    pushMatrix();
    // TODO fix this
    if(!firstperson && pathplannerscreen){ translate(0,0,1); }
    if(firstperson){ translate(0,0,-10); }
    
   
    fill(0,0,255);
    rect(580,75,20,80); // area 1
    rect(220,75,20,80); // area 2
   
   rect((gridWidth/2)+margin,gridHeight-margin*2,(gridWidth/3),margin);      // rect 4
    
    fill(30);
    stroke(255);
    rect(240,(gridHeight/2)-margin/2,gridWidth/2,margin); // area 3
    
      
        pushMatrix();
        translate(280,130,-5);
        fill(255);
        box(20);
        popMatrix();
        
        pushMatrix();
        translate((gridWidth/2)+margin*2,gridHeight-margin*2,-5);
        fill(255);
        box(20);
        popMatrix();
        
        pushMatrix();
        translate((gridWidth/2)+margin*4,gridHeight-margin*2,-5);
        fill(255);
        box(20);
        popMatrix();
        
        pushMatrix();
        translate((gridWidth/2)+margin*6,gridHeight-margin*2,-5);
        fill(255);
        box(20);
        popMatrix();
        
        
        
    popMatrix();
    
    // area 1
    if(carlocation.x >580 && carlocation.x <600 && carlocation.y >75 && carlocation.y< 155){
      
                    if(controlState == 1){
                    car.setDriveStatus(false);
                    update = false;
                    }
                    if(controlState == 2){
                    car.setDriveStatus(true);
                    update = true;
                    }
                    
                    if(sendswitch == false && controlState == 1 && serialavailable){
                    myPort.write ('3');
                    sendswitch = true;
      }
      
    // area 2
    }else if(carlocation.x >220 && carlocation.x <240 && carlocation.y >75 && carlocation.y< 155){
            
               if(sendswitch == false && controlState == 2 && serialavailable){
                    myPort.write ('4');
                    sendswitch = true;}

    }else if(carlocation.x > 240 && carlocation.x < 240 + gridWidth/2 && carlocation.y >(gridHeight/2)-(margin/2) && carlocation.y < (gridHeight/2)-(margin/2) + margin ){
            
              //println("test3");
              car.setSpeed(2.0);
    
    }else if(carlocation.x > (gridWidth/2)+margin && carlocation.x < (gridWidth/2)+margin + (gridWidth/3) && carlocation.y >gridHeight-margin*2 && carlocation.y < gridHeight-margin*2 + margin ){
              //println("area 4");
              if(sendswitch == false && controlState == 1 && serialavailable){
                    println("run area 4");
                    myPort.write ('5');
                    sendswitch = true;
                    car.setSpeed(0.3);
                  }
              
    
    }else{
        sendswitch = false;
        car.setSpeed(0.5);
    }
  }

}