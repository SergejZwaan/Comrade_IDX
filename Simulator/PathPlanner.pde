class PathPlanner {


  boolean listfull = false; // if list is full
  boolean listcreated = false; // if list is created
  boolean mousePres = false;

  boolean createpersonlist = true;
  boolean personlistfull = false;
  boolean personlistcreated = false;

  boolean autonomousdrive = false; // autonomous drive switch state

  boolean find_closest_checkpoint = false;
  boolean autonomous_driving_running = false; // if autonomous driving is running

  int identity = 0;
  int focusCheckPoint = 0;
  int pointnumbers = 40;

  PVector force;

  int[] xcor = {783, 781, 766, 747, 715, 661, 514, 379, 300, 232, 185, 157, 140, 132, 132, 132, 138, 151, 171, 196, 299, 603, 871, 1079, 1283, 1374, 1433, 1469, 1497, 1505, 1505, 1495, 1453, 1383, 1287, 916, 865, 820, 797, 785};
  int[] ycor = {362, 211, 180, 155, 137, 134, 130, 128, 128, 126, 137, 158, 185, 219, 251, 288, 321, 349, 374, 384, 383, 383, 383, 383, 385, 386, 397, 421, 458, 494, 560, 623, 675, 701, 702, 701, 689, 667, 634, 601};

  int[] xcor1 = new int[20];
  int[] ycor1 = new int[20];
  int[] xcor2 = new int[40];
  int[] ycor2 = new int[40];
  int[] xcor3 = new int[80];
  int[] ycor3 = new int[80];
  

  int xcounter = 0;
  int ycounter = 0;

  // array list of point objects
  ArrayList<PathPlannerPoint> ppp;
  ArrayList<PersonPoint>      pp;

  PathPlanner() {
    ppp = new ArrayList<PathPlannerPoint>();// create new array list
    pp = new ArrayList<PersonPoint>();// create new array list
    pp.add(new PersonPoint(gridWidth/2, gridHeight/2, identity));
    if (loadpreset) {// if load preset is true
      loadPreset(); // fil arraylist
      listcreated = true;
      listfull = true;
    }
  }

  void run() {
    if(createpersonlist){
    personupdate();
    persondisplay();
    }
    
    if (startpathplanner) { 
      update();
      displayArray();
      findNearestCheckpoint();
      checkCheckPointSwitch();
      if (autopilot) {
        calculateForce(focusCheckPoint);
      }
    }
  }

  void update() {
    if (mousePressed && listfull == false  && mousePres == false && (mouseButton == RIGHT)) {
      ppp.add(new PathPlannerPoint(mouseX, mouseY, identity));
      //pp.add(new PersonPoint(mouseX, mouseY, identity));
      identity++;
      xcor[xcounter] = mouseX;
      ycor[ycounter] = mouseY;
      xcounter++;
      ycounter++;
      print("{");
      for (int i = 0; i < 40; i++) {
        print(xcor[i] + ",");
      }
      println("}");
      print("{");
      for (int i = 0; i < 40; i++) {
        print(ycor[i] + ",");
      }
      println("}");

      listcreated = true;
      mousePres = true;
    }

    if (ppp.size() > pointnumbers) {
      listfull = true;
    }
  }
  
  void personupdate() {
    if (mousePressed && listfull == false  && mousePres == false && (mouseButton == RIGHT)) {
      pp.add(new PersonPoint(mouseX, mouseY, identity));
      identity++;
      xcor1[xcounter] = mouseX;
      ycor1[ycounter] = mouseY;
      xcounter++;
      ycounter++;
      print("{");
      for (int i = 0; i < 40; i++) {
        print(xcor1[i] + ",");
      }
      println("}");
      print("{");
      for (int i = 0; i < 40; i++) {
        print(ycor1[i] + ",");
      }
      println("}");

      personlistcreated = true;
      mousePres = true;
    }

    if (pp.size() > 10) {
      personlistfull = true;
    }
  }
  
  void persondisplay(){
   for ( int i = 0; i < ppp.size(); i++) {
     // PersonPoint p = pp.get(i);
     // p.display();
    }
   
  }

  void displayArray() {
    for ( int i = 0; i < ppp.size(); i++) {
      PathPlannerPoint p = ppp.get(i);
      PVector LocationFormerPoint = new PVector();
      PVector locationPoint = p.getLocation();

      if (i == 0) {
        PathPlannerPoint f = ppp.get(ppp.size()-1);
        LocationFormerPoint = f.getLocation();
      } else {
        PathPlannerPoint f = ppp.get(i-1);
        LocationFormerPoint = f.getLocation();
      }

      pushMatrix();
      strokeWeight(1);
      line(locationPoint.x, locationPoint.y, LocationFormerPoint.x, LocationFormerPoint.y);
      translate(0, 0, -4);
      strokeWeight(4);
      stroke(0, 200, 200);
      line(locationPoint.x, locationPoint.y, LocationFormerPoint.x, LocationFormerPoint.y);
      stroke(255);
      strokeWeight(1);
      popMatrix();


      p.display();
    }
  }

  void findNearestCheckpoint() {
    if ( autonomousdrive == true &&
      find_closest_checkpoint == false &&
      autonomous_driving_running == false) {

      PVector carloc = car.getLocation().copy();
      int idx_closest = 0;
      float closest_dist = gridHeight;
      for ( int i = 0; i < ppp.size(); i++) {
        PathPlannerPoint p = ppp.get(i);
        PVector pointloc = p.getLocation().copy();
        float d = PVector.dist(carloc, pointloc);
        if (d < closest_dist) {
          idx_closest = i;
          closest_dist = d;
        }
      }

      //println(idx_closest + " " + closest_dist);
      find_closest_checkpoint = true;
      // always go to the next point
      if (idx_closest < 39) {
        focusCheckPoint = idx_closest + 1;
      }
      autonomous_driving_running = true;
    }
  }

  void checkCheckPointSwitch() {


    if (listcreated == true && 
      car.getDriveStatus() == true &&
      autonomousdrive == true &&
      find_closest_checkpoint == true //&&
      //autonomous_driving_running == false
      ) {


      PVector carloc = car.getLocation().copy();
      PathPlannerPoint p = ppp.get(focusCheckPoint);
      PVector pointloc = p.getLocation().copy();
      float distance = PVector.dist(carloc, pointloc);
      if (distance < 30 ) {
        focusCheckPoint++;
        if (focusCheckPoint >= ppp.size()) {
          focusCheckPoint = 0;
        }
      }
    }
  }

  void calculateForce(int idx_checkpoint) {
    if (listcreated == true && 
      car.getDriveStatus() == true &&
      autonomousdrive == true &&
      find_closest_checkpoint == true //&&
      //autonomous_driving_running == false
      ) {
      PVector carloc = car.getLocation().copy();
      PathPlannerPoint p = ppp.get(idx_checkpoint);
      PVector pointloc = p.getLocation().copy();
      PVector force = pointloc.sub(carloc);

      force.normalize();
      force.setMag(0.01);
      //  carloc.mult(0.1);

      car.applyForce(force);
    }
  }

  void checkmouseMoved() {
    mousePres = false;
  }

  void startAutonomousDriving(boolean status) {
    autonomousdrive = status;
  }

  void resetPathPlanner() {
    autonomousdrive = false;

    find_closest_checkpoint = false;
    autonomous_driving_running = false;
  }

  void loadPreset() {
    for (int i = 0; i<40; i++) {
      ppp.add(new PathPlannerPoint(xcor[i], ycor[i], i));
      //println("add new p" + i);
    }
  }
}