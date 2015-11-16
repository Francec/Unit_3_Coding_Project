class Sattelite
{
  Body body;
  float r;
  
  Sattelite(float r_, float x, float y)
  {
    r = r_;
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 200;
    fd.friction = 0;
    fd.restitution = 1;
    body.createFixture(fd);
    body.setLinearVelocity(new Vec2(random(-20,20),random(-20,20)));
    body.setAngularVelocity(random(-10,10));
  }
  
  void applyForce(Vec2 v) 
  {
    body.applyForce(v, body.getWorldCenter());
  }
  
  void display()
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(150);
    ellipse(0,0,r*2,r*2);
    popMatrix();
  }
}