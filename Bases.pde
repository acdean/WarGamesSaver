class Bases {
  public static final int BASES = 70;
  public Base[] bases = new Base[BASES];

  void init() {
    for (int i = 0 ; i < bases.length ; i++) {
      bases[i] = new Base();
    }
  }

  void draw() {
    for (int i = 0 ; i < bases.length ; i++) {
      bases[i].draw();
    }
  }
  
  public Base get(int index) {
    return bases[index];
  }
}

PShape triangleShape;
PShape missileShape;
PShape starShape;
PShape circleShape;

class Base {
  static final int TRIANGLE = 0;
  static final int MISSILES = 1;
  static final int STAR = 2;
  static final int CIRCLE = 3;
  static final int SHAPES = 4;
  static final float SIZE = 20;
  
  PVector p; // pos
  boolean enabled = true;
  int type;
  color colour;
  PShape s;
  
  Base() {
    // random for now, later they should be spaced
    p = new PVector((int)random(width), (int)random(height));
    type = (int)random(SHAPES);
    if (triangleShape == null) {
      triangleShape = polygon(3);
    }
    if (missileShape == null) {
      missileShape = createShape(GROUP);
      float w = .175 * SIZE * 2;
      float spacing = .10 * SIZE * 2;
      float a = w / 2;
      float b = SIZE * .6;
      float x = -((w / 2) + spacing + w + (spacing / 2));
      float y = 0;
      for (int i = 0 ; i < 4 ; i++) {
        PShape missile = createShape();
        missile.beginShape(POLYGON);
        missile.noFill();
        missile.strokeWeight(3);
        missile.vertex(x, y - SIZE);      // top
        missile.vertex(x + a, y - b);     // right top
        missile.vertex(x + a, y + SIZE);  // right bottom
        missile.vertex(x - a, y + SIZE);  // left bottom
        missile.vertex(x - a, y - b);     // left top
        missile.endShape(CLOSE);
        x += w + spacing;
        missileShape.addChild(missile);
      }
    }
    if (starShape == null) {
      starShape = polygon(5, 2.5);
    }
    if (circleShape == null) {
      circleShape = polygon(8);
    }
    switch (type) {
      case TRIANGLE:
        s = triangleShape;
        break;
      case MISSILES:
        s = missileShape;
        break;
      case STAR:
        s = starShape;
        break;
      case CIRCLE:
        s = circleShape;
        break;
    }
  }
  
  PShape polygon(int sides) {
    return polygon(sides, sides);
  }
  
  PShape polygon(int sides, float increment) {
    PShape shape = createShape();
    shape.beginShape();
    shape.noFill();
    shape.strokeWeight(3);
    for (int i = 0 ; i < sides ; i++) {
      float angle = TWO_PI * i / (float)increment;
      shape.vertex(SIZE * sin(angle), SIZE * -cos(angle));  // transposed to rotate 90
    }
    shape.endShape(CLOSE);
    return shape;
  }

  // now uses shapes
  void draw() {
    pushMatrix();
    if (enabled) {
      colour = color(0, 255, 0);
    } else {
      colour = color(255, 0, 0);
    }
    s.setStroke(colour);
    shape(s, p.x, p.y);
    popMatrix();
  }
  
  PVector get() {
    return p;
  }
}

