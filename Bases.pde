class Bases {
  // teams
  public static final int RED = 0;
  public static final int BLUE = 1;

  public static final int BASES = 70;
  public int[] array = new int[2];
  public ArrayList<Base>[] bases = new ArrayList[2];

  void init() {
    bases[RED] = new ArrayList<Base>();
    bases[BLUE] = new ArrayList<Base>();
    for (int i = 0 ; i < BASES ; i++) {
      Base base = new Base();
      if (onland(base)) { // move to Base class? would avoid setType()
        base.setType(RED);
        bases[RED].add(base);
      } else {
        base.setType(BLUE);
        bases[BLUE].add(base);
      }
    }
    println("RED", bases[RED].size(), "BLUE", bases[BLUE].size());
  }
  
  // is the new base on land?
  // circular island for now
  boolean onland(Base base) {
    return dist(base.p.x, base.p.y, width / 2, height / 2) < height * .5;
  }

  // draw all bases for both teams
  void draw() {
    for (int a = RED ; a <= BLUE ; a++) { // nasty!
      for (int i = 0 ; i < bases[a].size() ; i++) {
        bases[a].get(i).draw();
      }
    }
  }
  
  public Base get(int a, int index) {
    return bases[a].get(index);
  }

  // random base from the given team
  public Base getRandom(int a) {
    debug("getRandom", a, bases[a].size());
    return bases[a].get((int)random(bases[a].size()));
  }
}

PShape triangleShape;
PShape missileShape;
PShape starShape;
PShape circleShape;
PShape subShape;

class Base {
  static final int TRIANGLE = 0;
  static final int MISSILES = 1;
  static final int STAR = 2;
  static final int CIRCLE = 3;
  static final int SHAPES = 4; // chose from the above 4 shapes only
  static final int SUBMARINE = -1; // blue team is all subs
  static final float SIZE = 20;
  
  PVector p; // pos
  boolean enabled = true;
  int type;
  color colour;
  PShape s;
  int team;
  
  Base() {
    // random for now, later they should be spaced
    p = new PVector((int)random(width), (int)random(height));
    
    // initialise shapes
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
    if (subShape == null) {
      // TODO
      subShape = polygon(7, 3.5);
    }
  }

  void setType(int team) {
    this.team = team;
    if (team == Bases.RED) {
      type = (int)random(SHAPES);
    } else {
      type = SUBMARINE;
    }
    switch (type) {
      case SUBMARINE:
        s = subShape;
        break;
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
    if (enabled) { // don't draw if dead (covered by cloud)
      pushMatrix();
      if (team == Bases.RED) {
        colour = color(0, 255, 0); // RED team is green
      } else {
        colour = color(255, 0, 0); // BLUE team is red...
      }
      s.setStroke(colour);
      shape(s, p.x, p.y);
      popMatrix();
    }
  }
  
  PVector get() {
    return p;
  }
}

