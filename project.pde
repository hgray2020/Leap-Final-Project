import de.voidplus.leapmotion.*;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
float scale = 1;
float grav = 12.0;
float mass = 20.0;
ArrayList<Skeleton> dummies = new ArrayList<Skeleton>();
float explodePow = 10000; //100000
float slamPow = 5000;
float suckPow = 0.25;
float suckRot = 10000;
float kickPow = 40;
float floppy = 0.5; //how floppy the limbs are
float groundY = 200;
float armLength = 45*scale;
float startDelay = 19;
float bounce = 1.4;
float friction = 0.8;
float rotC = 0.7;
float hitRadius = 30;
float collideC = 1;
boolean antiGrav = false;
LeapMotion leap;
float freezeCD = 0;
float timescale = 1;
float posX = 0, posY = 0;
boolean suck = false;
boolean freeze = false;
float armThick = 20*scale;
float timefr = 60;
PImage armTexture;
PImage forearmTexture;
PImage bodyTexture;
PImage parmText;
PImage pHeadFront;
PImage pHeadLeft;
PImage pHeadRight;
Skeleton player = new Skeleton(new PVector(1250, 1050), 0, true);
float kickX;
float kickY;
Point ttop = new Point(0, 0);
Point tbottom = new Point(0, 0);
boolean runFlip = false;
boolean runFlipL = false;

boolean[]keys=new boolean[255];
boolean leapControl = false;
float pposX;
float pposY;

void keyPressed() {
  if (keys.length-1<key) {
    keys=expand(keys, key+1);
  }
  keys[key]=true;
}
void keyReleased() {
  if (keys.length-1<key) {
    keys=expand(keys, key+1);
  }
  keys[key]=false;
}




void setup() {
  size(2500, 1500);
  leap = new LeapMotion(this);
  frameRate(6);
  for (int i = 0; i < 5; i++) {
    dummies.add(new Skeleton(new PVector(100+(i*150), 1050), i+1, false));
  }
  armTexture = loadImage("arm.png");
  forearmTexture = loadImage("forearm.png");
  bodyTexture = loadImage("body.png");
  parmText = loadImage("parm.png");
  pHeadFront = loadImage("pheadfront.png");
  pHeadLeft = loadImage("pheadleft.png");
  pHeadRight = loadImage("pheadright.png");
}



void draw() {
  background(0);
  noStroke();
  fill(60);
  freeze();
  suck();


  dummies();
  walls();

  player();
  environment();
  ellipse((ttop.x+tbottom.x)/2, (ttop.y+tbottom.y/2), 60, 60);
  leap();
  frameRate(timefr);
  if (keyPressed) {
    if (key == ',') {
      timescale -= 0.005;
    }
    if (key == '.') {
      timescale += 0.005;
    }
  }
}





class Enemy {


  boolean dead;

  Enemy(PVector pos) {
  }

  void act() {
  }
}

class Point {
  float x, y;

  Point(float ex, float why) {
    x = ex;
    y = why;
  }
}