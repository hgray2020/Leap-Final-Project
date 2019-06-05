
void player() {
Skeleton blep = dummies.get(0);
  player.act();

  if (!keys['y'] && !keys['t'] && !runFlip) {
    pwalls();
  }
  if (!antiGrav && (player.leftShin.slamAni > 105 || player.leftShin.slamAni < 60) && player.leftShin.kickAni == 0) {
    player.body.applyForce(new PVector(0, (0.4/9)*grav*timescale));
  }

  if (keyPressed) {
    if (!keys['f']) {
      if (key == 'a' && blep.leftShin.runAni <= 1) {
        blep.runDir = true;
        for (Spring s : blep.bones) {
          s.running = true;
        }
      }
      if (key == 'd' && blep.leftShin.runAni <= 1) {
        blep.runDir = false;
        for (Spring s : blep.bones) {
          s.running = true;
        }
      }
    }
  } else {
    if (!leapControl) {
      for (Spring s : blep.bones) {
        s.runAni = 0;
      }
    }
  }
  if (runFlip) {
    if (runFlipL) {
      player.body.velocity.mult(0);
      player.body.applyForce(new PVector(-7, -20));
      for (Spring s : player.bones) {
        s.flipLeft = true;
        s.flipping = true;
      }
    }
    if (!runFlipL) {
      player.body.velocity.mult(0);
      player.body.applyForce(new PVector(7, -20));
      for (Spring s : player.bones) {
        s.flipLeft = false;
        s.flipping = true;
      }
    }
    runFlip = false;
  }
}

void pwalls() {

  //if (dummy.body.position.x < 150)  {
  //  player.runDir = false;

  //  for (Spring s : player.bones) {

  //    s.running = true;
  //  }
  //}
  //if(player.body.position.x > width-150){
  //  player.runDir = true;
  //  for (Spring s : player.bones) {

  //    s.running = true;
  //  }
  //}
  if (player.body.position.x > width-10) {
    player.body.position.x = width - 9;
    player.body.applyForce(new PVector(player.body.velocity.x*-1*bounce, 0));
  }
  if (player.body.position.x < 10) {
    player.body.position.x = 11;
    player.body.applyForce(new PVector(player.body.velocity.x*-1*bounce, 0));
  }
  if (player.body.ang >= 0 && player.body.ang < 180 && player.body.top.y > (height-groundY) && (player.leftShin.slamAni < 20 || player.leftShin.slamAni > 60)) {
    player.body.position.y = (height-groundY-(50*scale*-1*sinDegrees(player.body.ang)));
    player.body.applyForce(new PVector(0, player.body.velocity.y*-1*bounce));
    player.body.velocity.x*=friction;
    player.body.onGround = true;
    if (player.ragdoll) {
      player.body.rot(atan2(player.body.position.y-groundY, player.body.position.x - player.body.top.x), new Point(player.body.top.x, groundY), 200*player.body.velocity.mag());
    }
  } else if (player.body.ang >= 180 && player.body.ang < 360 && player.body.bottom.y > (height-groundY) && (player.leftShin.slamAni < 20 || player.leftShin.slamAni > 60)) {
    player.body.position.y = (height-groundY-(50*scale*sinDegrees(player.body.ang)));
    player.body.applyForce(new PVector(0, player.body.velocity.y*-1*bounce));
    player.body.velocity.x*=friction;
    player.body.onGround = true;
    if (player.ragdoll) {
      player.body.rot(atan2(player.body.position.y-groundY, player.body.position.x - player.body.bottom.x), new Point(player.body.bottom.x, groundY), 200*player.body.velocity.mag());
    }
  } else {
    if (player.body.position.y < (height-groundY)-30) {
      player.body.onGround = false;
    }
  }
  if (!player.ragdoll) {
    //println(player.leftShin.y);
    if (player.leftShin.y > height-groundY && (player.leftShin.jumpAni >= 192 || player.leftShin.jumpAni <=160) && (player.leftShin.slamAni > 172 || player.leftShin.slamAni <=160) && (player.rightShin.slamAni < 10 || player.rightShin.slamAni > 60)) {
      player.body.onGround = true;
      player.body.position.y = (height-groundY)-((player.leftShin.y-player.body.position.y));

      if (player.rightShin.slamAni < 40 || player.rightShin.slamAni > 60) {
        player.body.applyForce(new PVector(0, player.body.velocity.y*-1*bounce));
      }
      if (player.rightShin.slamAni >= 48 && player.rightShin.slamAni <= 51) {
        player.body.velocity.mult(0);
      }
      player.body.velocity.x*=friction;
      if (player.leftShin.runAni > 0) {
        if (player.runDir) {
          player.body.applyForce(new PVector(-1*xforce, yforce));
        } else {
          player.body.applyForce(new PVector(xforce, yforce));
        }
      }
    } else if (player.rightShin.y > height-groundY && (player.rightShin.jumpAni >= 192 || player.rightShin.jumpAni <=160) && (player.leftShin.slamAni > 172 || player.leftShin.slamAni <=160) && (player.rightShin.slamAni < 10 || player.rightShin.slamAni > 60)) {
      player.body.onGround = true;
      player.body.position.y = (height-groundY)-((player.rightShin.y-player.body.position.y));
      if (player.rightShin.slamAni < 40 || player.rightShin.slamAni > 60) {
        player.body.applyForce(new PVector(0, player.body.velocity.y*-1*bounce));
      }
      if (player.rightShin.slamAni >= 48 && player.rightShin.slamAni <= 52) {
        player.body.velocity.mult(0); 
        player.body.position.y = (height-groundY)-(armLength*2.5);
      }
      player.body.velocity.x*=friction;
      if (player.rightShin.runAni > 0) {
        if (player.runDir) {
          player.body.applyForce(new PVector(-1*xforce, yforce));
        } else {
          player.body.applyForce(new PVector(xforce, yforce));
        }
      }
    }
  }
}