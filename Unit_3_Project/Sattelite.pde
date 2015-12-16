class Sattelite
{
  Body body;
  float r;
  PImage img;
 
  Sattelite(float r_, float x, float y, PVector LVel, PImage img_)
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
    fd.density = r*5;
    fd.friction = 0;
    fd.restitution = 0.999;
    body.createFixture(fd);
    body.setLinearVelocity(new Vec2((LVel.x/3),(-1*LVel.y/3)));
    body.setAngularVelocity(1);
    body.setUserData(this);
    img = img_;
  }
  
  void applyForce(Vec2 v) 
  {
    body.applyForce(v, body.getWorldCenter());
  }
  
  PVector ConvVec(Vec2 v)
  {
    return new PVector(v.x,v.y);
  }
  
  void display()
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(0);
  // ellipse(0,0,r*2,r*2);
   imageMode(CENTER);
   img.resize((int)r*2,(int)r*2);
   image(img,0,0);
    popMatrix();
  }
}