float cosDegrees(float a) {
  return cos(radians(a));
}

float sinDegrees(float a) {
  return -1*sin(radians(a)); //negative to make sin respond like normal unit circle with 45 degrees like / not \
}


float xforce = 6;
float yforce = -2;


void mouseClicked() {
  if (mouseButton == LEFT) {
    for (Spring s : player.bones) {
      s.flipping = false;
      player.body.ang = 270;
    }

    for (Spring s : player.bones) {
      s.kicking = true;
      s.kickLeft = player.body.position.x > mouseX;
    }
    kickX = mouseX;
    kickY = mouseY;
  }

  //if (mouseButton == LEFT) {
  //  for (Skeleton dummy : dummies) {
  //    Bone bone = dummy.body;

  //    float a = atan2(bone.position.y-mouseY, bone.position.x-mouseX);
  //    float d = dist(bone.position.x, bone.position.y, mouseX, mouseY);
  //    float forcex = (explodePow*cos(a))/d;
  //    float forcey = (explodePow*sin(a))/d;
  //    dummy.body.applyForce(new PVector(forcex, forcey));
  //    dummy.body.rot(a, new Point(mouseX, mouseY), explodePow);
  //  }
  //}
}

void whee() {
  for (Skeleton dummy : dummies) {
    Bone bone = dummy.body;

    float a = atan2(bone.position.y-player.body.bottom.y, bone.position.x-player.body.position.x);
    float d = dist(bone.position.x, bone.position.y, player.body.position.x, player.body.position.y);
    float forcex = (explodePow*cos(a))/d;
    float forcey = (explodePow*sin(a))/d;
    if (d < 100) {
      dummy.body.applyForce(new PVector(forcex/2, forcey*2));
      dummy.body.rot(a, new Point(mouseX, mouseY), explodePow);
    }
  }
}  



void walls() {
  for (Skeleton dummy : dummies) {
    //if (dummy.body.position.x < 150)  {
    //  dummy.runDir = false;

    //  for (Spring s : dummy.bones) {

    //    s.running = true;
    //  }
    //}
    //if(dummy.body.position.x > width-150){
    //  dummy.runDir = true;
    //  for (Spring s : dummy.bones) {

    //    s.running = true;
    //  }
    //}
    if (dummy.body.position.x > width-10) {
      dummy.body.position.x = width - 9;
      dummy.body.applyForce(new PVector(dummy.body.velocity.x*-1*bounce, 0));
      dummy.body.rvel*=-0.9;
    }
    if (dummy.body.position.x < 10) {
      dummy.body.position.x = 11;
      dummy.body.applyForce(new PVector(dummy.body.velocity.x*-1*bounce, 0));
      //if (dummy.ragdoll) {
      //  dummy.body.rot(atan2(dummy.body.position.y-groundY, dummy.body.position.x - dummy.body.bottom.x), new Point(dummy.body.bottom.x, groundY), 200*dummy.body.velocity.mag());
      //}
      dummy.body.rvel*=-0.9;
    }
    if (dummy.body.ang >= 0 && dummy.body.ang < 180 && dummy.body.top.y > (height-groundY)) {
      dummy.body.position.y = (height-groundY-(50*scale*-1*sinDegrees(dummy.body.ang)));
      dummy.body.applyForce(new PVector(0, dummy.body.velocity.y*-1*bounce));
      dummy.body.velocity.x*=friction;
      dummy.body.onGround = true;
      if (dummy.ragdoll) {
        dummy.body.rot(atan2(dummy.body.position.y-groundY, dummy.body.position.x - dummy.body.top.x), new Point(dummy.body.top.x, groundY), 200*dummy.body.velocity.mag());
      }
    } else if (dummy.body.ang >= 180 && dummy.body.ang < 360 && dummy.body.bottom.y > (height-groundY)) {
      dummy.body.position.y = (height-groundY-(50*scale*sinDegrees(dummy.body.ang)));
      dummy.body.applyForce(new PVector(0, dummy.body.velocity.y*-1*bounce));
      dummy.body.velocity.x*=friction;
      dummy.body.onGround = true;
      if (dummy.ragdoll) {
        dummy.body.rot(atan2(dummy.body.position.y-groundY, dummy.body.position.x - dummy.body.bottom.x), new Point(dummy.body.bottom.x, groundY), 200*dummy.body.velocity.mag());
      }
    } else {
      if (dummy.body.position.y < (height-groundY)-30) {
        dummy.body.onGround = false;
      }
    }
    if (!dummy.ragdoll) {
      //println(dummy.leftShin.y);
      if (dummy.leftShin.y > height-groundY && (dummy.leftShin.jumpAni >= 172 || dummy.leftShin.jumpAni <=160)) {
        dummy.body.onGround = true;
        dummy.body.position.y = (height-groundY)-((dummy.leftShin.y-dummy.body.position.y));

        dummy.body.applyForce(new PVector(0, dummy.body.velocity.y*-1*bounce));
        dummy.body.velocity.x*=friction;
        if (dummy.leftShin.runAni > 0) {
          if (dummy.runDir) {
            dummy.body.applyForce(new PVector(-1*xforce, yforce));
          } else {
            dummy.body.applyForce(new PVector(xforce, yforce));
          }
        }
      } else if (dummy.rightShin.y > height-groundY && (dummy.rightShin.jumpAni >= 172 || dummy.rightShin.jumpAni <=160)) {
        dummy.body.onGround = true;
        dummy.body.position.y = (height-groundY)-((dummy.rightShin.y-dummy.body.position.y));

        dummy.body.applyForce(new PVector(0, dummy.body.velocity.y*-1*bounce));
        dummy.body.velocity.x*=friction;
        if (dummy.rightShin.runAni > 0) {
          if (dummy.runDir) {
            dummy.body.applyForce(new PVector(-1*xforce, yforce));
          } else {
            dummy.body.applyForce(new PVector(xforce, yforce));
          }
        }
      }
    }
  }
}

void keyTyped() {
  if (key == 'g') {
    antiGrav = !antiGrav;
  }
  if (key == 'x') {
    timescale = -1;
  }
  if (key == 'l') {
    for (int i = 0; i < dummies.size(); i++) {
      Skeleton s = dummies.get(i);
      s.body.velocity.mult(0);
      s.body.rvel = 0;
    }
  }

  if (key == 'u') {
    timescale = 0.01;
  }
  if (key == 'i') {
    timescale = 1;
  }
  if (key == 'o') {
    timescale = 2;
  }
  if (key == 'p') {
    timescale = 0.00001;
  }
  if (key == 't') {
    player.body.applyForce(new PVector(-7, -20));
    for (Spring s : player.bones) {
      s.flipLeft = true;
      s.flipping = true;
    }
  }
  if (key == 'y') {
    player.body.applyForce(new PVector(7, -20));
    for (Spring s : player.bones) {
      s.flipLeft = false;
      s.flipping = true;
    }
  }
  if (keys['f']) {
    if (keys['a']) {
      for (Spring s : player.bones) {
        s.slamLeft = true;
        s.slamming = true;
        s.runAni = 0;
      }
    }
    if (keys['d']) {
      for (Spring s : player.bones) {
        s.slamLeft = false;
        s.slamming = true;
        s.runAni = 0;
      }
    }
  }

  if (key == 'z' && !freeze) {
    freeze = true;
    freezeCD = 120;
  }
  if (key == ' ') {
    //for (Skeleton d : dummies) {
    //  for (Spring s : d.bones) {
    //    s.jumping = true;
    //  }
    //}
    for (Spring s : player.bones) {
      s.jumping = true;
      s.runAni = 0;
    }
  }
  if (key == 'v') {
    timefr = 0.01;
  }
  if (key == 'b') {
    timefr = 60;
  }
  if (key == 'r') {
    for (Skeleton d : dummies) {
      for (Spring s : d.bones) {
        s.running = true;
      }
    }
  }
}

void freeze() {
  if (freeze && timescale > 0.0001 && freezeCD > 0) {
    timescale*=0.9;
  }
  if (freezeCD > 0) {
    freezeCD--;
  }
  if (freezeCD == 0 && freeze) {
    if (timescale < 1) {
      timescale/=0.9;
    }
    if (timescale >= 1) {
      timescale = 1;
      freeze = false;
    }
  }
}

void suck() {
  if (suck) {
    for (Skeleton dummy : dummies) {
      Bone bone = dummy.body;

      float a = atan2(bone.position.y-posY, bone.position.x-posX);
      float d = dist(bone.position.x, bone.position.y, posX, posY);
      float forcex = -1*sqrt(d)*(suckPow*cos(a));
      float forcey = -1*sqrt(d)*(suckPow*sin(a));
      dummy.body.applyForce(new PVector(forcex*timescale, forcey*timescale));
      dummy.body.rot(a, new Point(mouseX, mouseY), -1*suckRot);
    }
  }
  if (mousePressed) {
    if (mouseButton == RIGHT) {
      for (Skeleton dummy : dummies) {
        Bone bone = dummy.body;

        float a = atan2(bone.position.y-mouseY, bone.position.x-mouseX);
        float d = dist(bone.position.x, bone.position.y, mouseX, mouseY);
        float forcex = -1*sqrt(d)*(suckPow*cos(a));
        float forcey = -1*sqrt(d)*(suckPow*sin(a));
        dummy.body.applyForce(new PVector(forcex*timescale, forcey*timescale));
        dummy.body.rot(a, new Point(mouseX, mouseY), -1*suckRot);
      }
    }
  }
}

void dummies() {
  for (Skeleton dummy : dummies) {
    dummy.act();
  }
  if (frameCount >= startDelay) {

    for (Skeleton dummy : dummies) {
      if (!antiGrav) {
        dummy.body.applyForce(new PVector(0, (0.4/9)*grav*timescale));
      }
    }
  }
}

void environment() {
  fill(60);
  rect(0, height-groundY, width, groundY);
}

PVector ppos = new PVector(0, 0, 0);
float handVel = 0;
float[] vels = new float[5];

void leap() {
  if (leap.getHands().size() > 0) {
    leapControl = true;
  }
  for (Hand hand : leap.getHands()) {

    Finger index = hand.getIndexFinger(); 
    posX = index.getPosition().x;
    posY = index.getPosition().y;
    fill(255);
    noStroke();
    ellipse(posX, posY, 15, 15);
    if (index.getVelocity().div(1000).y < -1 && player.leftShin.slamAni == 0 && hand.getOutstretchedFingers().size() == 0 && player.body.position.y > height/2) {
      for (Spring s : player.bones) {

        s.slamming = true;
        s.runAni = 0;
      }
    }
    float dz = 150;
    if (hand.getOutstretchedFingers().size() == 2 || hand.getOutstretchedFingers().size() == 1) {
      if (posX < player.body.position.x-dz && player.leftShin.runAni <= 1 && player.leftShin.flipAni <= 0) {
        player.runDir = true;
        for (Spring s : player.bones) {
          s.running = true;
        }
      }
      if (posX > player.body.position.x+dz && player.leftShin.runAni <= 1 && player.leftShin.flipAni <= 0) {
        player.runDir = false;
        for (Spring s : player.bones) {
          s.running = true;
        }
      }
      if ((posX >= player.body.position.x-dz && posX <= player.body.position.x+dz) || player.leftShin.flipAni > 0) {
        for (Spring s : player.bones) {
          s.runAni = 0;
        }
      }
      if (player.leftShin.flipAni <= 0 && player.body.position.y > (height-(2*groundY))) {
        if (hand.getRoll() > 55) {
          runFlip = true;
          runFlipL = false;
        }
        if (hand.getRoll() <= -20) {
          runFlip = true;
          runFlipL = true;
        }
      }
      println(hand.getRoll());
    }
    if ((posX >= (player.body.position.x)-50 && posX <= (player.body.position.x)+150 || (hand.getOutstretchedFingers().size() != 2 && hand.getOutstretchedFingers().size() != 1)) && leapControl) {
      for (Spring s : player.bones) {
        s.runAni = 0;
      }
    }
    if (hand.getOutstretchedFingers().size() == 5) {
      println(index.getVelocity().x);//index.getVelocity().x);
      if (index.getVelocity().x < -4500 && player.leftShin.kickAni <= 0 && player.leftShin.slamAni <= 0 && player.leftShin.flipAni <= 0) {

        float minD = dist(player.body.position.x, player.body.position.y, dummies.get(0).body.position.x, dummies.get(0).body.position.y);
        boolean found = false;
        for (Skeleton s : dummies) {
          if (!s.ragdoll && player.body.position.x > s.body.position.x && dist(player.body.position.x, player.body.position.y, s.body.position.x, s.body.position.y) > 125) {
            found = true;

            float d = dist(player.body.position.x, player.body.position.y, s.body.position.x, s.body.position.y);
            if (d < minD) {
              minD = d;
              kickX = s.body.top.x;
              kickY = s.body.top.y;
            }
          }
        }
        if (found) {
          for (Spring s : player.bones) {
            s.kicking = true;
            s.kickLeft = player.body.position.x > kickX;
          }
        }
      }
      if (index.getVelocity().x > 4500 && player.leftShin.kickAni <= 0 && player.leftShin.slamAni <= 0 && player.leftShin.flipAni <= 0) {

        float minD = dist(player.body.position.x, player.body.position.y, dummies.get(0).body.position.x, dummies.get(0).body.position.y);
        boolean found = false;
        for (Skeleton s : dummies) {
          if (!s.ragdoll && player.body.position.x < s.body.position.x && dist(player.body.position.x, player.body.position.y, s.body.position.x, s.body.position.y) > 125) {
            found = true;
            float d = dist(player.body.position.x, player.body.position.y, s.body.position.x, s.body.position.y);
            if (d < minD) {
              minD = d;
              kickX = s.body.top.x;
              kickY = s.body.top.y;
            }
          }
        }
        if (found) {
          for (Spring s : player.bones) {
            s.kicking = true;
            s.kickLeft = player.body.position.x > kickX;
          }
        }
      }
    }

    if (player.leftShin.slamAni == 104) {
      if (abs(index.getVelocity().div(1000).x) > 2) {
        boolean t = index.getVelocity().x < 0;
        for (Spring s : player.bones) {
          s.slamLeft = t;
          s.slamAni = 70;
        }
      }
    }
    float[] temp = vels;
    for (int i = 0; i < 4; i++) {
      vels[i+1] = temp[i];
    }
    vels[0] = ppos.x-hand.getPalmPosition().x;
    ppos = hand.getPalmPosition();
    float sum = 0;
  }
  pposX = posX;
  pposY = posY;
}