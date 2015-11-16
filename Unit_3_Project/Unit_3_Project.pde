import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;
Attractor a;
Sattelite[] sat = new Sattelite[1];
ArrayList<Boundary> boundaries;

void setup()
{
  fullScreen();
  noStroke();
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0,0);
  for(int i = 0; i < sat.length; i++)
  {
    sat[i] = new Sattelite(2.5,random(width),random(height));
  }
  a = new Attractor(25,width/2,height/2);
  /*boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(width/2,height-5,width,10));
  boundaries.add(new Boundary(width-5,height/2,10,height));
  boundaries.add(new Boundary(5,height/2,10,height));
  boundaries.add(new Boundary(width/2,5,width,1));*/
}

void draw()
{
  //background(200);
  box2d.step();
  a.display();
  for(int i = 0; i < sat.length; i++)
  {
    Vec2 force = a.attract(sat[i]);
    sat[i].applyForce(force);
    sat[i].display();
  }
  fill(0,0,255);
}