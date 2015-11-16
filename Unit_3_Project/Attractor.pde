class Attractor
{
  Body body;
  float r;
  Attractor(float r_, float x, float y)
  {
    r = r_;
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    body.createFixture(cs,1);
  }
  
    Vec2 attract(Sattelite m) 
  {
    body.getPosition();
    float G = 200;
    Vec2 pos = body.getWorldCenter();    
    Vec2 moverPos = m.body.getWorldCenter();
    Vec2 force = pos.sub(moverPos);
    float distance = force.length();
    distance = constrain(distance,1,5);
    force.normalize();
    float strength = (G * 1 * m.body.m_mass) / (distance * distance);
    force.mulLocal(strength);
    return force;
  }
  
  void display() 
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(random(30));
    ellipse(0,0,r*2,r*2);
    popMatrix();
  }
}