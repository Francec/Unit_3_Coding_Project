import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.dynamics.contacts.Contact.*;

Box2DProcessing box2d;
Attractor a;
ArrayList<Sattelite> sat = new ArrayList<Sattelite>();
ArrayList<Boundary> boundaries;
float radius = 25;

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
  box2d.listenForCollisions();
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
    Disasm(b2);
    Disasm(b1);
  }
}

PVector ConvVec(Vec2 v)
  {
    return new PVector(v.x,v.y);
  }
  
  void Disasm(Body body)
  {
    for (int i = 0; i < 4; i++)
    {
      sat.add(new Sattelite(radius,box2d.getBodyPixelCoord(body).x, box2d.getBodyPixelCoord(body).y, ConvVec(body.getLinearVelocity()),loadImage("image.png")));
    }
    box2d.destroyBody(body);
  }