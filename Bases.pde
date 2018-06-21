class Bases {
  public static final int BASES = 20;
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
  
  Base() {
    // random for now, later they should be spaced
    p = new PVector((int)random(width), (int)random(height));
    type = (int)random(SHAPES);
  }
  
  // just a cross for now
  void draw() {
    pushMatrix();
    translate(p.x, p.y);
    strokeWeight(3);
    noFill();
    if (enabled) {
      stroke(0, 255, 0);
    } else {
      stroke(255, 0, 0);
    }
    switch(type) {
      case TRIANGLE:
        beginShape(POLYGON);
        for (int i = 0 ; i < 3 ; i++) {
          float angle = TWO_PI * i / 3.0;
          vertex(SIZE * sin(angle), SIZE * -cos(angle));  // transposse to rotate 90
        }
        endShape(CLOSE);
        break;
      case MISSILES:
        // 4 missiles !!!! 17.5 + 10 + 17.5 + 10 + 17.5 + 10 + 17.5
        float w = .175 * SIZE * 2;
        float spacing = .10 * SIZE * 2;
        float a = w / 2;
        float b = SIZE * .6;
        translate(-((w / 2) + spacing + w + (spacing / 2)), 0);
        for (int i = 0 ; i < 4 ; i++) {
          beginShape(POLYGON);
          vertex(0, -SIZE);  // top
          vertex(a, -b);  // right top
          vertex(a, SIZE);  // right bottom
          vertex(-a, SIZE);  // left bottom
          vertex(-a, -b);  // left top
          endShape(CLOSE);
          translate(w + spacing, 0);
        }
        break;
      case STAR:
        beginShape(POLYGON);
        for (int i = 0 ; i < 5 ; i++) {
          float angle = TWO_PI * 2 * i / 5.0;
          vertex(SIZE * sin(angle), SIZE * -cos(angle));
        }
        endShape(CLOSE);
        break;
      case CIRCLE:
        beginShape(POLYGON);
        for (int i = 0 ; i < 8 ; i++) {
          float angle = TWO_PI * i / 8.0;
          vertex(SIZE * cos(angle), SIZE * sin(angle));
        }
        endShape(CLOSE);
        break;
    }
    popMatrix();
  }
  
  PVector get() {
    return p;
  }
}