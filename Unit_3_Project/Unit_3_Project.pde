import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.dynamics.contacts.Contact.*;

Kinect kinect;
ArrayList <SkeletonData> bodies;

Box2DProcessing box2d;
Attractor a;
ArrayList<Sattelite> sat = new ArrayList<Sattelite>();
ArrayList<Boundary> boundaries;
float radius = 25;
int rh;
int lh;
float rx;
float ry;
float lx;
float ly;

enum MouseState
{
  CLICKED,
  RELEASED,
  DRAGGING
};

MouseState mState = MouseState.RELEASED;
MouseState PrevMState=MouseState.RELEASED;
PVector mStart = new PVector(0,0);
PImage asteroidImg;

void setup()
{
  fullScreen();
  noStroke();
  smooth();
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  box2d.setGravity(0,0);
  kinect = new Kinect(this);
  a = new Attractor(25,width/2,height/2);
  bodies = new ArrayList<SkeletonData>();
  /*boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(width/2,height-5,width,10));
  boundaries.add(new Boundary(width-5,height/2,10,height));
  boundaries.add(new Boundary(5,height/2,10,height));
  boundaries.add(new Boundary(width/2,5,width,1));*/
  asteroidImg = loadImage("image.png");
}

void draw()
{
  background(200);
    if (keyPressed)
    {
      if (key == '.')
      {
        radius += 5;
      }
      if (key == ',')
      {
        if (radius >= 5)
        {
          radius -= 5;
        }
        else
        radius = 1;
      }
    }
    
  image(kinect.GetDepth(),(0.5*width),(0.5*height),width,height);
  if (mousePressed)
  {
    mState = MouseState.CLICKED;
    if (PrevMState == MouseState.RELEASED)
    {
      mStart = new PVector(mouseX,mouseY);
    }
    else
    {
      stroke(0,0,0);
      strokeWeight(2);
      line(mStart.x,mStart.y,mouseX,mouseY);
    }
  }
  else
  {
    mState = MouseState.RELEASED;
    if(PrevMState == MouseState.CLICKED)
    {
      PVector SatVec = PVector.sub(mStart,new PVector(mouseX,mouseY));
      sat.add(new Sattelite(radius,mStart.x,mStart.y, SatVec,loadImage("image.png")));
    }
  }
  fill(0);
  textSize(35);
  text(radius,100,100);
  for (int i=0; i<bodies.size (); i++) 
  {
    drawSkeleton(bodies.get(i));
    drawPosition(bodies.get(i));
  }
  if (keyPressed)
  {
    if (key == 'r')
    {
      sat.clear();
    }
  }
  
  PrevMState = mState;
  box2d.step();
  a.display();
  for(Sattelite s : sat)
  {
    Vec2 force = a.attract(s);
    s.applyForce(force);
    s.display();
  }
  fill(0,0,255);
}

void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Sattelite.class && o2.getClass() == Sattelite.class) {
    Sattelite s1 = (Sattelite) o1;
    Sattelite s2 = (Sattelite) o2;
    //Disasm(b2);
    //Disasm(b1);
  }
}

PVector ConvVec(Vec2 v)
  {
    return new PVector(v.x,v.y);
  }
  
  /*void Disasm(Body body)
  {
    box2d.destroyBody(body);
    for (int i = 0; i < 4; i++)
    {
      sat.add(new Sattelite(radius,box2d.getBodyPixelCoord(body).x, box2d.getBodyPixelCoord(body).y, ConvVec(body.getLinearVelocity()),asteroidImg));
    }
  }*/
  
  
  void drawPosition(SkeletonData _s) 
{
  noStroke();
  fill(0, 100, 255);
  String s1 = str(_s.dwTrackingID);
  text(s1, _s.position.x*width/2, _s.position.y*height/2);
}
 
void drawSkeleton(SkeletonData _s) 
{
  lh = Kinect.NUI_SKELETON_POSITION_HAND_LEFT;
  rh=Kinect.NUI_SKELETON_POSITION_HAND_RIGHT;
  lx=_s.skeletonPositions[lh].x*width;
  rx=_s.skeletonPositions[rh].x*width;
  ly=_s.skeletonPositions[lh].y*height;
  ry=_s.skeletonPositions[rh].y*height;
  PVector R = new PVector(rx,ry);
  PVector L = new PVector(lx,ly);
  // Body
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HEAD, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_CENTER, 
  Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT, 
  Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_SPINE);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SPINE, 
  Kinect.NUI_SKELETON_POSITION_HIP_CENTER);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_CENTER, 
  Kinect.NUI_SKELETON_POSITION_HIP_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_CENTER, 
  Kinect.NUI_SKELETON_POSITION_HIP_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_LEFT, 
  Kinect.NUI_SKELETON_POSITION_HIP_RIGHT);
 
  // Left Arm
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_LEFT, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_LEFT, 
  Kinect.NUI_SKELETON_POSITION_WRIST_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_WRIST_LEFT, 
  Kinect.NUI_SKELETON_POSITION_HAND_LEFT);
 
  // Right Arm
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_SHOULDER_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ELBOW_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_HAND_RIGHT);
 
  // Left Leg
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_LEFT, 
  Kinect.NUI_SKELETON_POSITION_KNEE_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_KNEE_LEFT, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_LEFT, 
  Kinect.NUI_SKELETON_POSITION_FOOT_LEFT);
 
  // Right Leg
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_HIP_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_KNEE_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT);
  DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_ANKLE_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_FOOT_RIGHT);
 fill(0);
 ellipse(R.x,R.y,20,20);
 ellipse(L.x,L.y,20,20);
}
 
void DrawBone(SkeletonData _s, int _j1, int _j2) 
{
  noFill();
  stroke(255, 255, 0);
  if (_s.skeletonPositionTrackingState[_j1] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED &&
    _s.skeletonPositionTrackingState[_j2] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED) {
    line(_s.skeletonPositions[_j1].x*width, 
    _s.skeletonPositions[_j1].y*height, 
    _s.skeletonPositions[_j2].x*width, 
    _s.skeletonPositions[_j2].y*height);
    
    
    
  }
}
 
void appearEvent(SkeletonData _s) 
{
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) 
  {
    return;
  }
  synchronized(bodies) {
    bodies.add(_s);
  }
}
 
void disappearEvent(SkeletonData _s) 
{
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.remove(i);
      }
    }
  }
}