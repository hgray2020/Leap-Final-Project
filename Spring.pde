class Spring {
  float vx, vy; // The x- and y-axis velocities
  float x, y; // The x- and y-coordinates
  float gravity;
  float mass;
  float radius = 30;
  float stiffness = 0.1;
  float damping = 0.8;
  float angx = 0, angy = 0;
  Spring parent;
  Point paren;
  float offset;
  boolean arm = false;
  float gy;
  float ang = 0;
  boolean onGround = false;
  int boneColor;
  boolean ragdoll = true;
  boolean left;
  boolean standUp = false;
  float speed = 0.1;
  boolean jumping = false;
  int jumpAni = 0;
  boolean running = false;
  int runAni = 0;
  boolean runLeft = false;
  boolean slamming = false;
  int slamAni = 0;
  boolean slamLeft = false;
  boolean kicking = false;
  int kickAni = 0;
  boolean kickLeft = false;
  float kickAng = 0;
  boolean flipping = false;
  int flipAni = 0;
  boolean flipLeft = false;
  boolean play;
  Bone bd;



  Spring(float xpos, float ypos, float m, float g, Spring p, int c, boolean l, boolean pl) {
    x = xpos;
    y = ypos;
    mass = m;
    gravity = g;
    parent = p;
    boneColor = c;
    left = l;
    arm = parent.arm;
    play = pl;
  }

  Spring(float xpos, float ypos, float m, float g, Point p, float ffset, boolean upper, int c, boolean l, boolean pl) {
    x = xpos;
    y = ypos;
    mass = m;
    gravity = g;
    paren = p;
    offset = ffset;
    arm = upper;
    boneColor = c;
    left = l;
    play = pl;
  }


  void update(float targetX, float targetY, Bone body) {
    bd = body;
    if (parent != null) {
    } else {
      if (arm) {
        paren = new Point(body.top.x+offset, body.top.y);
      } else {
        paren = new Point(body.bottom.x+offset, body.bottom.y);
      }
    }

    if (ragdoll) {
      if (body.onGround) {
        onGround = true;
        if (y > height-groundY || antiGrav) {
          gravity = 0;
        } else if (!antiGrav) {
          gravity = grav;
        }
      }



      if (frameCount < -1) {
        float a = atan2(targetY-y, targetX-x)+PI;

        //x = paren.x+(armLength*cos(a));
        //y = paren.y+(armLength*sin(a));
      } else {
        float forceY = (targetY - y) * stiffness;
        forceY += gravity;
        float ay = forceY / mass;
        vy = damping * (vy + ay);
        float forceX = (targetX - x) * stiffness;
        float ax = forceX / mass;
        vx = damping * (vx + ax);
      }
      x += vx*timescale;
      y += vy*timescale;
    } else {
      if (!jumping && jumpAni == 0 && !running && runAni == 0 && !slamming && slamAni == 0 && !kicking && kickAni == 0 && !flipping && flipAni <= 0) {
        standing(body);
      } else if (jumping) {
        jumpAni = 200; 
        jumping = false;
      } else if (running) {
        runAni = 200;
        running = false;
      } else if (slamming) {
        slamAni = 200;
        slamming = false;
      } else if (kicking) {
        kickAni = 200;
        kicking = false;
      } else if (flipping) {
        flipAni = 200;
        flipping = false;
      }
      if (jumpAni > 0) {
        jump(body);
      }
      if (runAni > 0) {
        run(body, runLeft);
      }
      if (slamAni > 0) {
        slam(body);
      }
      if (kickAni > 0) {
        kick(body);
      }
      if (flipAni > 0) {
        flip(body);
      }

      if (body.onGround) {
        onGround = true;
      }
    }
  }

  void update(float targetX, float targetY) {
    if (ragdoll) {
      if (parent.onGround) {
        onGround = true;

        if (y > height-groundY || antiGrav) {
          gravity = 0;
        } else if (!antiGrav) {
          gravity = grav;
        }
      }
      float a = atan2(targetY-y, targetX-x)+PI;
      if (frameCount <-1) {
        //x = parent.angx+(armLength*cos(a));
        //y = parent.angy+(armLength*sin(a));
      } else {
        float forceX = (targetX - x) * stiffness;
        float ax = forceX / mass;
        vx = damping * (vx + ax);
        float forceY = (targetY - y) * stiffness;
        forceY += gravity;
        float ay = forceY / mass;
        vy = damping * (vy + ay);
      }
      x += vx*timescale;
      y += vy*timescale;
    } else {
      if (!jumping && jumpAni == 0 && !running && runAni == 0 && !slamming && slamAni == 0 && !kicking && kickAni == 0 && !flipping && flipAni <= 0) {
        standing();
      } else if (jumping) {
        jumpAni = 200; 
        jumping = false;
      } else if (running) {
        runAni = 200;
        running = false;
      } else if (slamming) {
        slamAni = 200;
        slamming = false;
      } else if (kicking) {
        kickAni = 200;
        kicking = false;
      } else if (flipping) {
        flipAni = 200;
        flipping = false;
      }
      if (jumpAni > 0) {
        jump();
      }
      if (runAni > 0) {
        run(runLeft);
      }
      if (slamAni > 0) {
        slam();
      }
      if (kickAni > 0) {
        kick();
      }
      if (flipAni > 0) {
        flip();
      }
    }
  }
  void standing(Bone body) {


    float fc = 5; //frames to get to standing
    if (ang > TWO_PI) {
      ang -= TWO_PI;
    }
    if (ang < 0) {
      ang+=TWO_PI;
    }

    if (body.ang > 270 + degrees(speed)) {
      body.ang -= degrees(speed);
    } else if (body.ang < 270 - degrees(speed)) {
      body.ang += degrees(speed);
    } else {
      body.ang = 270;
    }


    if (arm && left) {
      if (standUp) {
        speed = abs(ang-radians(255))/fc;
        standUp = false;
      }

      if ((ang < radians(255) - speed || ang > radians(255)+speed)) {
        ang+=speed*((radians(255)-ang)/(abs(radians(255)-ang)));
      } else {
        ang = radians(255);
      }
      x = (body.top.x+offset)+(cos(ang)*armLength);
      y = (body.top.y)-(sin(ang)*armLength);
    }


    if (arm && !left) {
      if (standUp) {
        speed = abs(ang-radians(285))/fc;
        standUp = false;
      }
      if ((ang < radians(285) - speed || ang > radians(285)+speed)) {
        ang+=speed*((radians(285)-ang)/(abs(radians(285)-ang)));
      } else {
        ang = radians(285);
      }
      x = (body.top.x+offset)+(cos(ang)*armLength);
      y = (body.top.y)-(sin(ang)*armLength);
    }


    if (!arm && left) {
      if (standUp) {
        speed = abs(ang-radians(255))/fc;
        standUp = false;
      }
      if ((ang < radians(255) - speed || ang > radians(255)+speed)) {
        ang+=speed*((radians(255)-ang)/(abs(radians(255)-ang)));
      } else {
        ang = radians(255);
      }
      x = (body.bottom.x+offset)+(cos(ang)*armLength);
      y = (body.bottom.y)-(sin(ang)*armLength);
    }


    if (!arm && !left) {
      if (standUp) {
        speed = abs(ang-radians(285))/fc;
        standUp = false;
      }
      if ((ang < radians(285) - speed || ang > radians(285)+speed)) {
        ang+=speed*((radians(285)-ang)/(abs(radians(285)-ang)));
      } else {
        ang = radians(285);
      }

      x = (body.bottom.x+offset)+(cos(ang)*armLength);
      y = (body.bottom.y)-(sin(ang)*armLength);
    }
    //println("whee"+frameCount);
  }



  void standing() {

    ang = parent.ang;
    x = parent.x+(cos(ang)*armLength);
    y = parent.y-(sin(ang)*armLength);
  }

  void jump(Bone body) {
    float ta = 195;
    float tb = 192;
    if (body.ang > 270 + degrees(speed)) {
      body.ang -= degrees(speed);
    } else if (body.ang < 270 - degrees(speed)) {
      body.ang += degrees(speed);
    } else {
      body.ang = 270;
    }

    float pang = ang;
    if (arm && left) {
      ang = radians(255);
    }
    if (arm && !left) {
      ang = radians(285);
    }
    if (!arm && left) {
      if (jumpAni > ta) {
        ang-=radians(5);
        body.position.y-=2*sin(ang-pang);
      }
      if (jumpAni <= ta && jumpAni > tb) {
        ang+=radians(14.4);
      }
      if (jumpAni == tb) {
        //body.position.y+=10;
        if (y-10 < height-groundY) {
          body.applyForce(new PVector(0, -20));
        }
      }
    }
    if (!arm && !left) {
      if (jumpAni > ta) {
        ang+=radians(5);
        body.position.y-=2*sin(ang-pang);
      }
      if (jumpAni <= ta && jumpAni > tb) {
        ang-=radians(14.4);
      }
    }
    pang = ang;
    jumpAni--;
    if (!arm) {
      x = (body.bottom.x+offset)+(cos(ang)*armLength);
      y = (body.bottom.y)-(sin(ang)*armLength);
    } else {
      x = (body.top.x+offset)+(cos(ang)*armLength);
      y = (body.top.y)-(sin(ang)*armLength);
    }
    if (jumpAni < 145) {
      jumpAni = 0;
    }
  }

  void jump() {
    jumpAni--;
    ang = radians(270);
    x = parent.x+(cos(ang)*armLength);
    y = parent.y-(sin(ang)*armLength);
    if (jumpAni < 145) {
      jumpAni = 0;
    }
  }

  void run(Bone body, boolean l) {
    if (l) {
      if (body.ang > 290 + degrees(speed)) {
        body.ang -= degrees(speed);
      } else if (body.ang < 290 - degrees(speed)) {
        body.ang += degrees(speed);
      } else {
        body.ang = 290;
      }
    } else {
      if (body.ang > 250 + degrees(speed)) {
        body.ang -= degrees(speed);
      } else if (body.ang < 250 - degrees(speed)) {
        body.ang += degrees(speed);
      } else {
        body.ang = 250;
      }
    }

    float pang = ang;

    if (runAni >= 199) {
      if (l) {
        if (!arm && left) {
          ang = radians(220);
        }
        if (!arm && !left) {
          ang = radians(280);
        }
        if (arm && left) {
          ang = radians(320);
        }
        if (arm && !left) {
          ang = radians(280);
        }
      } else {
        if (!arm && left) {
          ang = radians(260);
        }
        if (!arm && !left) {
          ang = radians(330);
        }
        if (arm && left) {
          ang = radians(310);
        }
        if (arm && !left) {
          ang = radians(220);
        }
      }
    }
    if (runAni < 199) {
      if (!arm && left) {
        if ((runAni/10)%2 == 0) {
          ang-=radians(7);
        } else {
          ang+=radians(7);
        }
      }
      if (!arm && !left) {

        if ((runAni/10)%2 == 0) {
          ang+=radians(7);
        } else {
          ang-=radians(7);
        }
      }

      if (arm && left) {
        //println((runAni/10)%2 == 0);
        if ((runAni/10)%2 == 0) {
          ang+=radians(8);
        } else {
          ang-=radians(8);
        }
      }
      if (arm && !left) {

        if ((runAni/10)%2 == 0) {
          ang-=radians(8);
        } else {
          ang+=radians(8);
        }
      }
    }
    pang = ang;
    runAni--;
    if (!arm) {
      x = (body.bottom.x+offset)+(cos(ang)*armLength);
      y = (body.bottom.y)-(sin(ang)*armLength);
    } else {
      x = (body.top.x+offset)+(cos(ang)*armLength);
      y = (body.top.y)-(sin(ang)*armLength);
    }
  }

  void run(boolean l) {
    runAni--;
    if (!arm && !parent.arm) {
      if (l && parent.ang < radians(260) || !l && parent.ang > radians(280)) {
        if (l) {
          ang = parent.ang+radians(40);
        } else {
          ang = parent.ang-radians(40);
        }
      } else {
        if (l) {

          ang = parent.ang+radians(100);
        } else {
          ang = parent.ang-radians(100);
        }
      }
    } else {
      if (l) {
        ang = parent.ang-radians(40);
      } else {
        ang = parent.ang+radians(40);
      }
    }
    //if(parent.arm && !arm){
    //  if (l && parent.ang < radians(260) || !l && parent.ang > radians(280)) {
    //    if (l) {
    //      ang = parent.ang+radians(40);
    //    } else {
    //      ang = parent.ang-radians(40);
    //    }
    //  } else {
    //    if (l) {
    //      ang = parent.ang;
    //    } else {
    //      ang = parent.ang;
    //    }
    //  }
    //}

    x = parent.x+(cos(ang)*armLength);
    y = parent.y-(sin(ang)*armLength);
  }

  void slam(Bone body) {
    if (body.ang > 270 + degrees(speed)) {
      body.ang -= degrees(speed);
    } else if (body.ang < 270 - degrees(speed)) {
      body.ang += degrees(speed);
    } else {
      body.ang = 270;
    }

    float pang = ang;
    if (slamAni > 50) {
      if (arm && left) {
        ang = radians(255);
      }
      if (arm && !left) {
        ang = radians(285);
      }
    }
    if (!arm && left) {
      if (slamAni > 180) {
        ang-=radians(5);
        body.position.y-=2*sin(ang-pang);
      }
      if (slamAni <= 180 && slamAni > 172) {
        ang+=radians(14.4);
      }
      if (slamAni == 172) {
        //body.position.y+=10;
        if (y-10 < height-groundY) {
          body.applyForce(new PVector(0, -30));
        }
      }
    }
    if (!arm && !left) {
      if (slamAni > 180) {
        ang+=radians(5);
        body.position.y-=2*sin(ang-pang);
      }
      if (slamAni <= 180 && slamAni > 172) {
        ang-=radians(14.4);
      }
    }
    pang = ang;
    if (!(leapControl && slamAni == 104)) {
      slamAni--;
    }

    if (!arm) {
      x = (body.bottom.x+offset)+(cos(ang)*armLength);
      y = (body.bottom.y)-(sin(ang)*armLength);
    } else {
      x = (body.top.x+offset)+(cos(ang)*armLength);
      y = (body.top.y)-(sin(ang)*armLength);
    }
    if (slamAni == 105) {
      body.velocity.mult(0);
    }
    if (slamAni == 60) {
      body.applyForce(new PVector(0, 35));
    }
    if (slamAni == 50) {
      body.velocity.mult(0); 
      body.acceleration.mult(0);
      player.body.position.y = (height-groundY)-(armLength*2.5);
      for (Skeleton dummy : dummies) {

        Bone bone = dummy.body;

        float a = atan2(bone.position.y-player.leftShin.y, bone.position.x-player.body.position.x);
        float d = dist(bone.position.x, bone.position.y, player.body.position.x, player.leftShin.y);
        float forcex = (slamPow*cos(a))/d;
        float forcey = (slamPow*sin(a))/d;
        if ((slamLeft && dummy.body.position.x < body.position.x) || (!slamLeft && dummy.body.position.x > body.position.x)) {
          dummy.body.applyForce(new PVector(forcex*2, forcey*2));
          dummy.body.rot(a, new Point(player.body.position.x, player.leftShin.y), explodePow);
          dummy.ragdoll = true;
          dummy.ragdollcd = 180;
        }
      }
    }
    //println(slamAni+", "+body.acceleration.y+", "+body.position.y);
    if (slamAni < 60 && slamAni > 50) {
      standing(body);
    }
    if (slamAni <= 50) {
      if (slamAni > 47) {
        player.body.position.y = (height-groundY)-(armLength*1.75);
      }
      body.velocity.mult(0); 
      body.acceleration.mult(0);
      //player.body.position.y = (height-groundY)-(armLength*2.5);
      if (slamLeft) {
        body.ang = 340;
        if (arm && left) {
          ang = radians(270);
        }
        if (arm && !left) {
          ang = radians(10);
        }
        if (!arm && left) {
          ang = radians(195);
        }
        if (!arm && !left) {
          ang = radians(285);
        }
      } else {
        body.ang = 200;
        if (arm && left) {
          ang = radians(170);
        }
        if (arm && !left) {
          ang = radians(270);
        }
        if (!arm && left) {
          ang = radians(255);
        }
        if (!arm && !left) {
          ang = radians(345);
        }
      }
      if (!arm && !left && slamLeft) {
        noFill();
        strokeWeight(20);
        stroke(175, 205, 255, 150);
        arc(body.bottom.x, player.leftShin.y, (1000-(20*slamAni))*20, (1000-(20*slamAni))*20, HALF_PI, PI+(PI/8));
      }
      if (!arm && !left && !slamLeft) {
        noFill();
        strokeWeight(20);
        stroke(175, 205, 255, 150);
        arc(body.bottom.x, player.rightShin.y, (1000-(20*slamAni))*20, (1000-(20*slamAni))*20, PI+((3*PI)/8)+HALF_PI, TWO_PI+HALF_PI);
      }
    }
  }




  void slam() {
    if (slamAni > 50) {
      ang = radians(270);
      x = parent.x+(cos(ang)*armLength);
      y = parent.y-(sin(ang)*armLength);
    } else {
      if (slamLeft) {
        if (arm && left) {
          ang = radians(270);
        }
        if (arm && !left) {
          ang = radians(0);
        }
        if (!arm && left) {
          ang = radians(270);
        }
        if (!arm && !left) {
          ang = radians(340);
        }
      } else {
        if (arm && left) {
          ang = radians(180);
        }
        if (arm && !left) {
          ang = radians(270);
        }
        if (!arm && left) {
          ang = radians(200);
        }
        if (!arm && !left) {
          ang = radians(270);
        }
      }
      x = parent.x+(cos(ang)*armLength);
      y = parent.y-(sin(ang)*armLength);
    }
    if (!(leapControl && slamAni == 104)) {
      slamAni--;
    }
  }

  void kick(Bone body) {

    if (kickAni >= 199) {
      kickAng = atan2(kickY-body.bottom.y, kickX-body.bottom.x)+HALF_PI;

      if (kickLeft) {
        if (arm && left) {
          ang = radians(240);
        }
        if (arm && !left) {
          ang = radians(240);
        }
        if (!arm && left) {
          ang = radians(255);
        }
        if (!arm && !left) {
          ang = radians(285);
        }
      }
      if (!kickLeft) {
        if (arm && left) {
          ang = radians(300);
        }
        if (arm && !left) {
          ang = radians(300);
        }
        if (!arm && left) {
          ang = radians(255);
        }
        if (!arm && !left) {
          ang = radians(285);
        }
      }
    }
    if (kickAni < 199 && kickAni > 190) {
      if (kickLeft) {
        if (!arm && left) {
          ang -= radians(3);
        } 
        if (!arm && !left) {
          ang -= radians(3);
        }
      } 
      if (!kickLeft) {
        if (!arm && left) {
          ang += radians(3);
        } 
        if (!arm && !left) {
          ang += radians(3);
        }
      }
    }
    if (kickAni <= 190) {
      //body.ang = degrees(kickAng);
      if (kickLeft) {
        if (arm && left) {
          ang = radians(260);
        }
        if (arm && !left) {
          ang = radians(350);
        }
        if (!arm && left) {
          ang = radians(170);
        }
        if (!arm && !left) {
          ang = radians(230);
        }
      }
      if (!kickLeft) {
        if (arm && left) {
          ang = radians(190);
        }
        if (arm && !left) {
          ang = radians(280);
        }
        if (!arm && left) {
          ang = radians(310);
        }
        if (!arm && !left) {
          ang = radians(10);
        }
      }
    }
    if (kickAni == 190) {
      if (arm && left) {
        body.velocity.y *= 0;
        float a = 0;
        if (play) {
          a = atan2(body.position.y-kickY, body.position.x-kickX);
        } else {
          a = atan2(body.position.y-player.body.top.y, body.position.x-player.body.position.x);
        }

        float forcex = -1*(kickPow*cos(a));
        float forcey = -1*(kickPow*sin(a));
        body.applyForce(new PVector(forcex, forcey));
      }
    }

    if (!arm) {
      x = (body.bottom.x+offset)+(cos(ang)*armLength);
      y = (body.bottom.y)-(sin(ang)*armLength);
    } else {
      x = (body.top.x+offset)+(cos(ang)*armLength);
      y = (body.top.y)-(sin(ang)*armLength);
    }
    if (arm && left) {
      Point tp = new Point ((paren.x-offset)+(cosDegrees(body.ang)*body.bLen*0.5), paren.y+(sinDegrees(body.ang)*body.bLen*0.5));
      fill(boneColor);
      float tempAng = -1*radians(body.ang-90);
      pushMatrix();
      translate(tp.x, tp.y);
      imageMode(CENTER);
      rotate(tempAng+PI);
      if (play) {
        image(pBody, 0, 0, 25*scale, body.bLen*scale);
      } else {
        image(bodyTexture, 0, 0, 25*scale, body.bLen*scale);
      }
      popMatrix();
      rectMode(CORNER);
      fill(boneColor);
      rectMode(CENTER); 
      if (play) {
        if (flipAni <= 0 && runAni <= 0 && (slamAni >= 104 || slamAni <= 0)) {
          image(pHeadFront, body.position.x-(cosDegrees(body.ang)*(armLength*(2))), body.position.y-(sinDegrees(body.ang)*(armLength*(2))), 50*scale, 50*scale);
        } else if ((flipAni > 0 && flipLeft) || (runAni > 0 && runLeft) || (slamAni < 104 && slamAni > 0 && slamLeft)) {
          image(pHeadLeft, body.position.x-(cosDegrees(body.ang)*(armLength*(2))), body.position.y-(sinDegrees(body.ang)*(armLength*(2))), 50*scale, 50*scale);
        } else if ((flipAni > 0 && !flipLeft) || (runAni > 0 && !runLeft) || (slamAni < 104 && !slamLeft)) {
          image(pHeadRight, body.position.x-(cosDegrees(body.ang)*(armLength*(2))), body.position.y-(sinDegrees(body.ang)*(armLength*(2))), 50*scale, 50*scale);
        }
      } else { 

        if (flipAni <= 0 && runAni <= 0 && (slamAni >= 104 || slamAni <= 0)) {
          image(eHeadFront, body.position.x-(cosDegrees(body.ang)*(armLength*(2))), body.position.y-(sinDegrees(body.ang)*(armLength*(2))), 50*scale, 50*scale);
        } else if ((flipAni > 0 && flipLeft) || (runAni > 0 && runLeft) || (slamAni < 104 && slamAni > 0 && slamLeft)) {
          image(eHeadLeft, body.position.x-(cosDegrees(body.ang)*(armLength*(2))), body.position.y-(sinDegrees(body.ang)*(armLength*(2))), 50*scale, 50*scale);
        } else if ((flipAni > 0 && !flipLeft) || (runAni > 0 && !runLeft) || (slamAni < 104 && !slamLeft)) {
          image(eHeadRight, body.position.x-(cosDegrees(body.ang)*(armLength*(2))), body.position.y-(sinDegrees(body.ang)*(armLength*(2))), 50*scale, 50*scale);
        }
      }
      rectMode(CORNER);
    }


    if (kickAni < 115) {
      kickAni = 1;
    }
    kickAni--;
  }

  void kick() {
    if (kickAni >= 199) {
      ang = parent.ang;
    }
    if (kickAni < 199 && kickAni > 190) {
      if (arm) {
        ang = parent.ang;
      }

      if (!arm && left) {
        ang = radians(255);
      }
      if (!arm && !left) {
        ang = radians(285);
      }
    }

    if (kickAni <= 190) {


      if (kickLeft) {
        if (arm && left) {
          ang = radians(120);
        }
        if (arm && !left) {
          ang = radians(0);
        }
        if (!arm && left) {
          ang = radians(170);
        }
        if (!arm && !left) {
          ang = radians(350);
        }
      }
      if (!kickLeft) {
        if (arm && left) {
          ang = radians(180);
        }
        if (arm && !left) {
          ang = radians(60);
        }
        if (!arm && left) {
          ang = radians(190);
        }
        if (!arm && !left) {
          ang = radians(10);
        }
      }
    }
    x = parent.x+(cos(ang)*armLength);
    y = parent.y-(sin(ang)*armLength);
    if (kickAni <= 190 && !arm) {
      if (kickLeft && left) {
        stroke(255);
        strokeWeight(10);

        if (play) {
          for (Skeleton s : dummies) {
            Bone b = s.body;
            //PVector[] points = {new PVector(b.top.x-5, b.top.y), new PVector(b.top.x+5, b.top.y), new PVector(b.bottom.x+5, b.bottom.y), new PVector(b.bottom.x-5, b.bottom.y)};
            if (x < b.top.x+(armThick) && x > b.top.x-(armThick) && y > b.top.y && y < b.bottom.y && !b.collided) {
              for (Spring bo : player.bones) {
                bo.kickAni = 1;
                bo.flipping = true;
                bo.flipLeft = false;
              }
              b.applyForce(player.body.velocity.mult(1.5));
              b.rot(ang, new Point(x, y), 500);
              b.collided = true;
              b.collideCD = 60;
              s.ragdoll = true;
              s.ragdollcd = 180;
              println("ye");
              player.body.velocity.x *= -0.1;
              player.body.velocity.y = -22;
            }
          }
        } else {

          Bone b = player.body;
          //PVector[] points = {new PVector(b.top.x-5, b.top.y), new PVector(b.top.x+5, b.top.y), new PVector(b.bottom.x+5, b.bottom.y), new PVector(b.bottom.x-5, b.bottom.y)};
          if (x < b.top.x+(armThick) && x > b.top.x-(armThick) && y > b.top.y && y < b.bottom.y && !b.collided && !b.ragdoll) {
            for (Spring bo : player.bones) {
              bo.kickAni = 1;
              bo.flipping = true;
              bo.flipLeft = true;
            }

            b.applyForce(parent.bd.velocity.mult(1.5));
            b.rot(ang, new Point(x, y), 300);
            health--;
            b.collided = true;
            b.collideCD = 60;
            player.ragdoll = true;
            player.ragdollcd = round(((maxHealth-health)/maxHealth)*200);
            println(player.ragdollcd);
            // println("ye");
            player.body.velocity.x *= -0.1;
            player.body.velocity.y = -22;
          }
        }
      }
      if (!kickLeft && !left) {
        stroke(255);
        strokeWeight(10);

        if (play) {
          for (Skeleton s : dummies) {
            Bone b = s.body;
            //PVector[] points = {new PVector(b.top.x-5, b.top.y), new PVector(b.top.x+5, b.top.y), new PVector(b.bottom.x+5, b.bottom.y), new PVector(b.bottom.x-5, b.bottom.y)};
            if (x < b.top.x+(armThick) && x > b.top.x-(armThick) && y > b.top.y && y < b.bottom.y && !b.collided) {
              for (Spring bo : player.bones) {
                bo.kickAni = 1;
                bo.flipping = true;
                bo.flipLeft = true;
              }

              b.applyForce(player.body.velocity.mult(1.5));
              b.rot(ang, new Point(x, y), 500);
              b.collided = true;
              b.collideCD = 60;
              s.ragdoll = true;
              s.ragdollcd = 180;
              println("ye");
              player.body.velocity.x *= -0.1;
              player.body.velocity.y = -22;
            }
          }
        } else {

          Bone b = player.body;
          //PVector[] points = {new PVector(b.top.x-5, b.top.y), new PVector(b.top.x+5, b.top.y), new PVector(b.bottom.x+5, b.bottom.y), new PVector(b.bottom.x-5, b.bottom.y)};
          if (x < b.top.x+(armThick) && x > b.top.x-(armThick) && y > b.top.y && y < b.bottom.y && !b.collided && !b.ragdoll) {
            for (Spring bo : player.bones) {
              bo.kickAni = 1;
              bo.flipping = true;
              bo.flipLeft = true;
            }

            b.applyForce(parent.bd.velocity.mult(1.5));
            b.rot(ang, new Point(x, y), 500);
            health--;
            b.collided = true;
            b.collideCD = 60;
            player.ragdoll = true;
            player.ragdollcd = round(((maxHealth-health)/maxHealth)*200);
            println(player.ragdollcd);
            // println("ye");
            player.body.velocity.x *= -0.1;
            player.body.velocity.y = -22;
          }
        }
      }
    }
    if (kickAni < 115) {
      kickAni = 1;
    }


    kickAni--;
  }

  void flip(Bone body) {
    float flipSpeed = 2;
    if (flipAni >= 199) {
      if (flipLeft || !flipLeft) {

        if (arm && left) {
          ang = radians(250);
        }
        if (arm && !left) {
          ang = radians(260);
        }
        if (!arm && left) {
          ang = radians(260);
        }
        if (!arm && !left) {
          ang = radians(290);
        }
      }
    }
    if (flipAni < 199) {
      if (flipLeft) {

        body.ang+=flipSpeed;
        if (arm && left) {
          ang = radians(body.ang-50);
        }
        if (arm && !left) {
          ang = radians(body.ang-40);
        }
        if (!arm && left) {
          ang = radians(body.ang-10);
        }
        if (!arm && !left) {
          ang = radians(body.ang+20);
        }
      } else {
        if (arm && left) {
          ang = radians(body.ang+40);
        }
        if (arm && !left) {
          ang = radians(body.ang+50);
        }
        if (!arm && left) {
          ang = radians(body.ang+20);
        }
        if (!arm && !left) {
          ang = radians(body.ang-10);
        }

        body.ang-=flipSpeed;
      }
    }
    if (flipAni < 185) {
      if (abs(270-body.ang) < 5) {
        body.ang = 270;
        flipAni = 0;
      }
    }

    flipAni--;
    if (!arm) {
      x = (body.bottom.x+offset)+(cos(ang)*armLength);
      y = (body.bottom.y)-(sin(ang)*armLength);
    } else {
      x = (body.top.x+offset)+(cos(ang)*armLength);
      y = (body.top.y)-(sin(ang)*armLength);
    }
  }

  void flip() {
    if (flipLeft) {
      if (arm) {
        ang = parent.ang+(QUARTER_PI/2);
      } else {
        ang = parent.ang-(QUARTER_PI/2);
      }
    } else {
      if (arm) {
        ang = parent.ang-(QUARTER_PI/2);
      } else {
        ang = parent.ang+(QUARTER_PI/2);
      }
    }
    if (parent.flipAni <= 0) {
      flipAni = 0;
    }
    flipAni--;

    x = parent.x+(cos(ang)*armLength);
    y = parent.y-(sin(ang)*armLength);
  }


  void display(Spring spring, Bone body) {
    float nx = spring.x;
    float ny = spring.y;

    //noStroke();
    //fill(boneColor);
    //ellipse(nx, ny, 15, 15);
    //stroke(boneColor);
    //strokeWeight(10*scale);
    //line(x, y, nx, ny);

    float ta = atan2(ny-y, nx-x)+HALF_PI;
    fill(boneColor);
    noStroke();
    pushMatrix();
    translate(nx, ny);

    rotate(ta);
    imageMode(CORNER);
    if (!play) {
      image(armTexture, scale*(-1*armThick/2), 0, armThick*scale, armLength*scale);
    } else {
      if (arm) {
        image(pLeg, scale*(-1*armThick/2), 0, armThick*scale, armLength*scale);
      } else {
        image(pLeg, scale*(-1*armThick/2), 0, armThick*scale, armLength*scale);
      }
    }

    popMatrix();
    if (ragdoll) {
      ang = atan2(ny-y, nx-x)+PI;
      x = nx+(armLength*cos(ang));
      y = ny+(armLength*sin(ang));
      ang = body.ang;
    } else {
    }
    float b = degrees(ang);

    //a += (b-spring.ang)/(abs(b-spring.ang))*0.1;


    fill(255);
  }
  void display(float nx, float ny, Bone body) {

    //noStroke();
    //fill(boneColor);
    //ellipse(nx, ny, 15, 15);
    //stroke(boneColor);
    //strokeWeight(10*scale);
    //line(x, y, nx, ny);


    float ta = atan2(ny-y, nx-x)+HALF_PI;
    fill(boneColor);
    noStroke();
    pushMatrix();
    translate(nx, ny);

    rotate(ta);


    rectMode(CORNER);

    imageMode(CORNER);
    if (!play) {
      image(armTexture, scale*(-1*armThick/2), 0, armThick*scale, armLength*scale);
    } else {
      if (arm) {
        if (left) {
          image(parmLeft, scale*(-1*armThick/2), 0, armThick*scale, armLength*scale);
        } else {
          image(parmText, scale*(-1*armThick/2), 0, armThick*scale, armLength*scale);
        }
      } else {
        image(pLeg, scale*(-1*armThick/2), 0, armThick*scale, armLength*scale);
      }
    }

    popMatrix();
    if (ragdoll) {
      ang = atan2(ny-y, nx-x)+PI;
      x = nx+(armLength*cos(ang));
      y = ny+(armLength*sin(ang));
    } 
    float b = degrees(ang);
    //a += (b-body.ang)/(abs(b-body.ang))*0.1;

    fill(255);




    //ellipse(x+(100*cos(a)), y+(100*sin(a)), 50, 50);
  }
}