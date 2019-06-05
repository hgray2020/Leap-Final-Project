//JUST A HEADS UP: There's some code no longer in use in here somewhere, probably in the Bone Tab. Because of how long it took to get ragdoll to work, I'm scared to
//delete it even though I'm pretty sure it serves no purpose. Just letting the reader know so they don't get to confused as to the function of certain 
//functions. The spring class name is from some code I copied in making ragdoll. The name stuck, but most of the copied code didn't.

//Also some variable names aren't great. :/



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
PImage eHeadFront;
PImage eHeadLeft;
PImage eHeadRight;
PImage pLeg;
PImage pBody;
PImage parmLeft;
PImage warning;
Skeleton player = new Skeleton(new PVector(1250, 1050), 0, true);
float kickX;
float kickY;
Point ttop = new Point(0, 0);
Point tbottom = new Point(0, 0);
boolean runFlip = false;
boolean runFlipL = false;
boolean blink = false;
float blinkcdc = 15;
float blinkcd = blinkcdc;
float maxHealth = 20;
float health = maxHealth;


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
  frameRate(60);
  for (int i = 0; i < 5; i++) {
    dummies.add(new Skeleton(new PVector(1250+(i*150), 1050), i+1, false));
  }
  armTexture = loadImage("arm.png");
  forearmTexture = loadImage("forearm.png");
  bodyTexture = loadImage("body.png");
  parmText = loadImage("parm.png");
  pHeadFront = loadImage("pheadfront.png");
  pHeadLeft = loadImage("pheadleft.png");
  pHeadRight = loadImage("pheadright.png");
  eHeadFront = loadImage("eheadfront.png");
  eHeadLeft = loadImage("eheadleft.png");
  eHeadRight = loadImage("eheadright.png");
  pBody = loadImage("pbody.png");
  pLeg = loadImage("pleg.png");
  parmLeft = loadImage("parmleft.png");
  warning = loadImage("ohno.png");
}



void draw() {
  background(0);
  noStroke();
  fill(60);
  fill(255);
  textSize(40);
  text("Health: "+health, 50, 50);
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