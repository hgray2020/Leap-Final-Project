class Bone {
  Bone parent;
  ArrayList<Bone> children;
  Bone child;
  float rotMin;
  float rotMax;
  float ang;
  float bLen; //bone length;
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector rotation;
  Point endpoint;
  boolean b = false;
  boolean ragdoll = false;
  boolean shoulder = false;
  float targAng;
  boolean left = true;
  float diffAng = 0;
  float ab = 500;
  PVector pvel = new PVector(0, 0);
  Point bottom;
  Point top;
  float rvel = 0;
  boolean onGround = false;
  int boneColor = 0;
  boolean freez = false;
  boolean play = false;
  boolean collided = false;
  int collideCD = 0;

  Bone(Bone p, ArrayList<Bone> c, float rMin, float rMax, float aang, float bLength, PVector pos, boolean bee, int co, boolean pl) {
    parent = p;
    children = c;
    rotMin = rMin;
    rotMax = rMax;
    ang = aang;
    bLen = bLength;
    position = pos;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    rotation = new PVector(cosDegrees(ang), sinDegrees(ang));
    endpoint = new Point(position.x+(cosDegrees(ang)*bLen), position.y+(sinDegrees(ang)*bLen));
    bottom = new Point(position.x-(cosDegrees(ang)*bLen*0.5), position.y-(sinDegrees(ang)*bLen)*0.5);
    top = new Point(position.x+(cosDegrees(ang)*bLen*0.5), position.y+(sinDegrees(ang)*bLen)*0.5);
    b = true; //needed to make clear which constructor in case of null as parameter for child
    targAng = ang;
    rvel = 0;
    boneColor = co;
    play = pl;
  }
  Bone(Bone p, Bone c, float rMin, float rMax, float aang, float bLength, PVector pos, int upper, boolean l) {
    parent = p;
    child = c;
    rotMin = rMin;
    rotMax = rMax;
    ang = aang;
    bLen = bLength;
    position = pos;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    rotation = new PVector(cosDegrees(ang), sinDegrees(ang));
    targAng = ang;
    left = l;
    if (upper == 1) {
      shoulder = true;
    }

    if (parent.b && !ragdoll) {
      endpoint = new Point(position.x+(cosDegrees(ang)*bLen), position.y+(sinDegrees(ang)*bLen));
    } else if (!parent.b && !ragdoll) {
      endpoint = new Point(position.x+(cosDegrees(parent.ang-ang)*bLen), position.y+(sinDegrees(parent.ang-ang)*bLen));
    }
  }

  void rot(float a, Point source, float pow) {



    rvel = -1*rotC*((tan(a)/(abs(tan(a))))*pow)/dist(source.x, source.y, position.x, position.y);
  }

  void display() {

    if (!b) {
      stroke(255);
    } else {
      stroke(boneColor);
    }
    if (b) {
      if (!play || (play && player.leftShin.kickAni == 0)) {
        fill(boneColor);
        float tempAng = -1*radians(ang-90);
        pushMatrix();
        translate(position.x, position.y);
        imageMode(CENTER);
        rotate(tempAng+PI);
        image(bodyTexture, 0, 0, 25*scale, bLen*scale);
        popMatrix();
        rectMode(CORNER);
      }

      //line(top.x, top.y, bottom.x, bottom.y);
    } else {
      //line(position.x, position.y, endpoint.x, endpoint.y);
    }
    strokeWeight(scale*10);
  }
  void applyForceJoint(PVector force) {

    float angBetween = PVector.angleBetween(new PVector(position.x-endpoint.x, position.y-endpoint.y), force);
    //println((force.x*sin(angBetween)+", "+force.y*cos(angBetween)));

    force = new PVector(force.x*cos(angBetween), force.y*cos(angBetween));

    acceleration.add(force);
  }
  void applyForce(PVector force) {
    if (freez) {
      force.mult(0);
    }
    acceleration.add(force);
  }
  void setAng(float a) {
    ang = a;
  }
  void update() {
    if(collideCD > 0){
      collideCD--;  
    }
    if(collideCD == 0){
      collided = false;  
    }

    if (parent != null) {
      if (!shoulder) {
        position.x = parent.endpoint.x;
        position.y = parent.endpoint.y;
      } else {
        position.x = parent.position.x;
        position.y = parent.position.y;
      }

      if (parent.b && !ragdoll) {
        endpoint = new Point(position.x+(cosDegrees(ang)*bLen), position.y+(sinDegrees(ang)*bLen));
      } else if (!parent.b && !ragdoll) {
        endpoint = new Point(position.x+(cosDegrees(parent.ang-ang)*bLen), position.y+(sinDegrees(parent.ang-ang)*bLen));
      }
    }
    if (b) {
      top = new Point(position.x-(cosDegrees(ang)*bLen*0.5), position.y-(sinDegrees(ang)*bLen*0.5));
      bottom = new Point(position.x+(cosDegrees(ang)*bLen*0.5), position.y+(sinDegrees(ang)*bLen*0.5));
    }
    if (!b) {
      if (ang >= rotMax) {
        ang = rotMax;

        if (parent != null && parent.b) {
        }
      }
      if (ang <= rotMin) {
        ang = rotMin;
        if (parent != null && parent.b) {
        }
      }
    }



    if (!b) {
      PVector bAcc;
      if (parent.b) {// || (parent.parent != null && parent.parent.b)) {
        bAcc = parent.acceleration;

        bAcc.mult(-1);
        applyForceJoint(bAcc);

        velocity.add(acceleration);
        if (acceleration.mag() > 0) {
          ab = PVector.angleBetween(new PVector(position.x-endpoint.x, position.y-endpoint.y), acceleration);
        }



        if (rotMax > 180) {
          targAng = map(targAng, -180, 180, 0, 360);
        }

        if (targAng < rotMin) {
          targAng = rotMin;
        }
        if (targAng > rotMax) {
          targAng = rotMax;
        }

        diffAng = targAng-ang;
        if (ab != 500) {
          if (ab > 0) {
            if ((ang > 90 && ang < 270) || (ang < -90 && ang > -270)) {
              ang+=floppy*atan2(velocity.y, velocity.x);
            } else {
              ang-=floppy*atan2(velocity.y, velocity.x);
            }
          } else {
            if ((ang > 90 && ang < 270) || (ang < -90 && ang > -270)) {
              ang-=floppy*atan2(velocity.y, velocity.x);
            } else {
              ang+=floppy*atan2(velocity.y, velocity.x);
            }
          }
        }

        /*if (diffAng!=0) {
         if (left) {
         if (diffAng <= 180) {
         ang+=floppy*(diffAng/(abs(diffAng)))*velocity.mag();
         } else {
         ang-=floppy*(diffAng/(abs(diffAng)))*velocity.mag();
         }
         } else {
         if (diffAng <= 180) {
         ang-=floppy*(diffAng/(abs(diffAng)))*velocity.mag();
         } else {
         ang+=floppy*(diffAng/(abs(diffAng)))*velocity.mag();
         }
         }
         }*/
      }
    } else {

      velocity.add(acceleration);
      if (freez) {
        velocity.mult(0);
      }

      position.add(new PVector(velocity.x*timescale, velocity.y*timescale));

      ang+=rvel*timescale;
      if (!antiGrav && !freeze) {
        rvel*=0.99;
      }

      if (onGround && ragdoll) {
        if (ang > 0 && ang < 87.5) {
          rvel-=0.6*timescale;
        } else if (ang >= 92.5 && ang < 177.5) {
          rvel+=0.6*timescale;
        } else if (ang >= 182.5 && ang < 267.5) {
          rvel-=0.6*timescale;
        } else if (ang >= 272.5 && ang < 357.5) {
          rvel+=0.*timescale;
        } else {
          rvel = 0;
        }
      }
      if (abs(rvel) < 0.001) {
        rvel = 0;
      }
      if (ang > 360) {
        ang -= 360;
      }
      if (ang < 0) {
        ang+=360;
      }
    }

    acceleration.mult(0);
    pvel = velocity;
  }
}