class Skeleton {
  boolean play = false;
  Bone body;
  Spring rightShoulder;
  Spring rightForearm;
  Spring leftShoulder;
  Spring leftForearm;
  Spring rightThigh;
  Spring rightShin;
  Spring leftThigh;
  Spring leftShin;
  Bone neck;
  Spring leftHand;
  Spring rightHand;
  Spring leftFoot;
  Spring rightFoot;
  int c = color(random(0, 255), random(0, 255), random(0, 255));
  float bm = 0; //slope
  float bb = 0; //y-int
  ArrayList<Point> bodyLine = new ArrayList<Point>();
  int pri = 0; //priority
  int collided = pri;
  int cCD = 0;
  float ragdollcd = 0;
  boolean runDir = true; //true is left, false is right

  ArrayList<Spring> bones = new ArrayList<Spring>();
  boolean ragdoll = false;
  float kickcdc = round(random(200, 1000)); //kick cooldown constant
  float kickcd = kickcdc; //kick cooldown


  Skeleton(PVector pos, int p, boolean pl) {
    pri = p;
    play = pl;
    ArrayList<Bone> temp = new ArrayList<Bone>();

    body = new Bone(null, temp, 0, 360, 270, 100*scale, pos, true, c, pl);

    /* leftShoulder = new Bone(body, leftForearm, 130, 250, 180, 70*scale, pos, 1, true);
     leftForearm = new Bone(leftShoulder, null, -150, 0, 0, 55*scale, new PVector(leftShoulder.endpoint.x, leftShoulder.endpoint.y), 0, true);
     rightShoulder = new Bone(body, rightForearm, -70, 50, 10, 70*scale, pos, 1, false);
     rightForearm = new Bone(rightShoulder, null, 0, 150, 0, 55*scale, new PVector(rightShoulder.endpoint.x, rightShoulder.endpoint.y), 0, false);
     
     leftThigh = new Bone(body, leftShin, -200, 45, -110, 70*scale, new PVector(body.endpoint.x, body.endpoint.y), 0, true);
     leftShin = new Bone(leftThigh, null, -150, 0, 0, 55*scale, new PVector(leftThigh.endpoint.x, leftThigh.endpoint.y), 0, true);
     rightThigh = new Bone(body, rightShin, -225, 20, -70, 70*scale, new PVector(body.endpoint.x, body.endpoint.y), 0, false);
     rightShin = new Bone(rightThigh, null, 0, 150, 0, 55*scale, new PVector(rightThigh.endpoint.x, rightThigh.endpoint.y), 0, false);
     */    neck = new Bone(body, null, 30, 150, 90, 50*scale, pos, 1, false);
    //temp.add(rightShoulder);
    //temp.add(leftShoulder);
    temp.add(neck);


    body.children = temp;
    leftShoulder = new Spring(0, 0, mass, grav, new Point(body.top.x-(scale*20), body.top.y), scale*-20, true, c, true, play);
    rightShoulder = new Spring(0, 0, mass, grav, new Point(body.top.x+(scale*20), body.top.y), scale*20, true, c, false, play);
    leftThigh = new Spring(0, 0, mass, grav, new Point(body.bottom.x-(scale*10), body.bottom.y), scale*-10, false, c, true, play);
    rightThigh = new Spring(0, 0, mass, grav, new Point(body.bottom.x+(scale*10), body.bottom.y), scale*10, false, c, false, play);
    leftForearm = new Spring(0, 0, mass, grav, leftShoulder, c, true, play);
    rightForearm = new Spring(0, 0, mass, grav, rightShoulder, c, false, play);
    leftShin = new Spring(0, 0, mass, grav, leftThigh, c, true, play);
    rightShin = new Spring(0, 0, mass, grav, rightThigh, c, false, play);


    bones.add(leftShoulder);
    bones.add(rightShoulder);
    bones.add(leftForearm);
    bones.add(rightForearm);
    bones.add(leftThigh);
    bones.add(rightThigh);
    bones.add(leftShin);
    bones.add(rightShin);
    //bones.add(leftHand);
    //bones.add(rightHand);
    //bones.add(leftFoot);
    //bones.add(rightFoot);
  }

  void display() {
    body.display();
    noStroke();
    if (leftShin.kickAni == 0) {
      fill(c);
      rectMode(CENTER); 
      float tempAng = -1*radians(body.ang-90);
      pushMatrix();
      translate(body.position.x, body.position.y);
      rotate(tempAng+PI);

      imageMode(CENTER);
      if (play) {
        
        if (leftShin.flipAni <= 0 && leftShin.runAni <= 0 && (leftShin.slamAni >= 60 || leftShin.slamAni <= 0)) {
          image(pHeadFront, 0, body.bLen*-0.82, 50*scale, 50*scale);
        } else if ((leftShin.flipAni > 0 && !leftShin.flipLeft) || (leftShin.runAni > 0 && leftShin.runLeft) || (leftShin.slamAni < 60 && leftShin.slamAni > 0 && leftShin.slamLeft)) {
          image(pHeadLeft, 0, body.bLen*-0.82, 50*scale, 50*scale);
        } else if ((leftShin.flipAni > 0 && leftShin.flipLeft) || (leftShin.runAni > 0 && !leftShin.runLeft) || (leftShin.slamAni < 104 && !leftShin.slamLeft)) {
          image(pHeadRight, 0, body.bLen*-0.82, 50*scale, 50*scale);
        }
      } else { 

        if (leftShin.flipAni <= 0 && leftShin.runAni <= 0 && (leftShin.slamAni >= 60 || leftShin.slamAni <= 0)) {
          image(eHeadFront, 0, body.bLen*-0.82, 50*scale, 50*scale);
        } else if ((leftShin.flipAni > 0 && !leftShin.flipLeft) || (leftShin.runAni > 0 && leftShin.runLeft) || (leftShin.slamAni < 60 && leftShin.slamAni > 0 && leftShin.slamLeft)) {
          image(eHeadLeft, 0, body.bLen*-0.82, 50*scale, 50*scale);
        } else if ((leftShin.flipAni > 0 && leftShin.flipLeft) || (leftShin.runAni > 0 && !leftShin.runLeft) || (leftShin.slamAni < 104 && !leftShin.slamLeft)) {
          image(eHeadRight, 0, body.bLen*-0.82, 50*scale, 50*scale);
        }
      }
      rectMode(CORNER);
      popMatrix();
    }
    for (Spring s : bones) {
      if (s.parent != null) {
        s.display(s.parent, body);
      } else {
        s.display(s.paren.x, s.paren.y, body);
      }
    }
  }

  void update() {

    if (leftShin.slamAni < 52 && leftShin.slamAni > 0) {
      body.velocity.mult(0);  
      body.freez = true;
    }
    if (leftShin.slamAni == 0) {
      body.freez = false;
    }

    body.update();
    if (leftShin.slamAni < 50 && leftShin.slamAni > 0) {
      body.velocity.mult(0);
    }
    neck.update();
    // println(body.position.y);
    //neck.ang = 90;
    //println(body.velocity.mag());
    if (!play) {
      if (body.velocity.mag() > 2000) {
        ragdoll = true;
        ragdollcd = 180;
        for (Spring s : bones) {
          s.standUp = true;
        }
      }
    }
    if (ragdollcd > 0 && body.onGround) {
      ragdollcd--;
    }
    if (ragdollcd <= 0) {
      ragdoll = false;
    }
    for (Spring s : bones) {
      if (s.parent != null) {
        s.update(s.parent.x, s.parent.y);
      } else {
        s.update(s.paren.x, s.paren.y, body);
      }
      s.ragdoll = this.ragdoll;
      s.runLeft = this.runDir;
    }


    if (body.ang > 360) {
      body.ang-=360;
    }
    if (body.ang < 0) {
      body.ang+=360;
    }
    bm = (body.top.y-body.bottom.y)/(body.top.x-body.bottom.x);
    bb = body.top.y - (bm*body.top.x);
  }

  void applyForce(PVector force) {
    body.applyForce(force);
  }
  void applyForceJoint(PVector force) {
    /*for (Bone bone : bones) {
     if (!bone.b) {
     bone.applyForceJoint(force);
     }
     }*/
  }

  void act() {
    if (!play) {
      if (kickcd == 0) {
        for (Spring b : bones) {
          b.kicking = true;
          b.kickLeft = body.position.x > player.body.position.x;
        }
        kickcd = kickcdc;
      }
      if(kickcd < 25 || leftShin.kickAni > 190 || leftShin.kicking){
        imageMode(CENTER);
        image(warning, body.position.x, body.position.y-150, 30, 90);
      }
      if (kickcd > 0) {
        kickcd--;
      }
    }

    update();
    display();

    if (!body.onGround || !ragdoll) {

      for (int i = 0; i < dummies.size(); i++) {
        if (i != pri) {
          //collide(dummies.get(i));
        }
      }
      if (cCD > 0) {
        cCD--;
      }
      if (cCD == 0) {
        collided = pri;
      }
    }
  }
  void collide(Skeleton other) {
    int density = 5;

    float spacing = (body.top.x-body.bottom.x)/10.0;
    for (int i = 0; i < bodyLine.size(); i++) {
      bodyLine.remove(i);
      i--;
    }
    for (int i = 0; i < density; i++) {
      bodyLine.add(new Point(body.bottom.x+(i*spacing), (bm*(body.bottom.x+(i*spacing)))+bb));
    }
    for (int i = 0; i < bodyLine.size(); i++) {
      Point p = bodyLine.get(i);

      for (int j = 0; j < other.bodyLine.size(); j++) {

        Point q = other.bodyLine.get(j);

        if (dist(q.x, q.y, p.x, p.y) < hitRadius) {
          if (pri < other.pri && other.pri != collided) {
            PVector temp = new PVector(body.velocity.x, body.velocity.y);
            body.velocity = new PVector(other.body.velocity.x*collideC, other.body.velocity.y*collideC);
            other.body.velocity = new PVector(temp.x*collideC, temp.y*collideC);
            collided = other.pri;
            cCD = 15;
            break;
          }
        }
      }
    }
  }
}