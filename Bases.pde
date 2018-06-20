class Bases {
  public static final int BASES = 10;
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
  PVector p; // pos
  boolean enabled = true;
  
  Base() {
    // random for now, later they should be spaced
    p = new PVector((int)random(width), (int)random(height));
  }
  
  // just a cross for now
  void draw() {
    strokeWeight(3);
    if (enabled) {
      stroke(0, 255, 0);
    } else {
      stroke(255, 0, 0);
    }
    line(p.x - 10, p.y - 10, p.x + 10, p.y + 10);
    line(p.x + 10, p.y - 10, p.x - 10, p.y + 10);
  }
  
  PVector get() {
    return p;
  }
}