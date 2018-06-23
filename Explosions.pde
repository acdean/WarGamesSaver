// these are very similar to paths (and bases)

class Explosions {
  ArrayList<Explosion> explosions = new ArrayList<Explosion>();
  
  void add(PVector p) {
    explosions.add(new Explosion(p));
  }
  
  void draw() {
    for (int i = explosions.size() - 1 ; i >= 0 ; i--) {
      if (explosions.get(i).draw() == true) {
        // finished, so delete
        debug("deleting Explosion...");
        explosions.remove(i);
      }
    }
  }
}

class Explosion {
  static final int MIN_RADIUS = 200;
  static final int MAX_RADIUS = 350;
  static final float SPEED = .05;

  PVector p;
  float count;
  float delta = SPEED;
  float radius;
  
  Explosion(PVector p) {
    this(p.x, p.y);
  }
  Explosion(float x, float y) {
    p = new PVector(x, y);
    radius   = random(MIN_RADIUS, MAX_RADIUS);
    debug("Explosion", p);
  }
  
  // white filled circle of given size
  // returns true if finished
  boolean draw() {
    //println("Draw Explosion", count);
    count += delta;
    if (count >= HALF_PI) {
      return true; // finished
    }
    stroke(255);
    fill(255);
    ellipse(p.x, p.y, radius * sin(count), radius * sin(count));
    return false; // not finished
  }
}

