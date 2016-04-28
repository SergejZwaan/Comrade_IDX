class JoyStick {

  
  float gas;
  float brake;
  boolean lp;
  boolean rp;
  
  JoyStick() {

    
    if (momo == null) {
      println("No suitable device configured");
     // System.exit(-1); // End the program NOW!
    }
  }

  void run() {
    if(joystickavailable){  
        momoSteer = map(momo.getSlider("W").getValue(), -1, 1,-180, 180);
        gas = map(momo.getSlider("A").getValue(),1, -1,0, 1);
        brake = map(momo.getSlider("B").getValue(),1, -1,0, 1);
        //println("gas: " + gas + " - brake:  " + brake + "-steer: " + momoSteer);
    } else{
        momoSteer = 0.0;
        gas = 0.0;
        brake = 0.0;
    }
  }
  
  float get_Gas(){return gas;}
  float get_Brake(){return brake;}
  float get_Steer(){return momoSteer;}
}