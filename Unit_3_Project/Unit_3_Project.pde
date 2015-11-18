import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;
Attractor a;
ArrayList<Sattelite> sat = new ArrayList<Sattelite>();
ArrayList<Boundary> boundaries;

enum MouseState
{
  CLICKED,
  RELEASED,
  DRAGGING
};

MouseState mState = MouseState.RELEASED;
MouseState PrevMState=MouseState.RELEASED;
PVector mStart = new PVector(0,0);

void setup()
{
  fullScreen();
  noStroke();
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0,0);
  a = new Attractor(25,width/2,height/2);
  /*boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(width/2,height-5,width,10));
  boundaries.add(new Boundary(width-5,height/2,10,height));
  boundaries.add(new Boundary(5,height/2,10,height));
  boundaries.add(new Boundary(width/2,5,width,1));*/
}

void draw()
{
  background(200);
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
      sat.add(new Sattelite(10,mStart.x,mStart.y, SatVec));
    }
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