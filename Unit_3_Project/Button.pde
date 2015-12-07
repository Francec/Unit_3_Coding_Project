class Button
{
  PVector[] pos;
  color Color;
  int colorCode;
  float size;
  int numButtons;
  PImage Asteroid1;
  PImage Asteroid2;
  PImage Asteroid3;
  PImage Asteroid4;
  PImage Asteroid5;
  
  Button(PImage ast1, PImage ast2, PImage ast3, PImage ast4, PImage ast5)
  {
    numButtons = 5;
    pos = new PVector[numButtons];
    colorCode = (int)random(0,5);
    if (colorCode == 0)
    {
      Color = color(0,0,255);      
    }
    if (colorCode == 1)
    {
      Color = color(255,0,0);
    }
    if (colorCode == 2)
    {
      Color = color (0,255,0);
    }
    if (colorCode == 3)
    {
      Color = color(155,155,0);
    }
    if (colorCode == 4)
    {
      Color = color(0,155,155);
    }
    Asteroid1 = ast1;
    Asteroid2 = ast2;
    Asteroid3 = ast3;
    Asteroid4 = ast4;
    Asteroid5 = ast5;
    size = 108;
    pos[0] = new PVector(size/2, size/2);
    for (int i = 1; i < numButtons; i++)
    {
      pos[i] = new PVector(i*size+size/2, 0);
    }
  }
  
  void Draw()
  {
    for (int i = 0; i < numButtons; i++)
    {
      ellipse(pos[i].x, pos[i].y, size, size);
    }
  }
}  