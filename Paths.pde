class Paths {
  ArrayList<Path> paths = new ArrayList<Path>();
  
  void add() {
    Path path = new Path();
    // only add valid paths
    if (path != null && path.start != null) {
      paths.add(new Path());
    }
  }
  
  void draw() {
    for (int i = paths.size() - 1 ; i >= 0 ; i--) {
      if (paths.get(i).draw() == true) {
        // finished, so delete
        debug("deleting...");
        // disable the target
        paths.get(i).end.enabled = false;
        // remove the path
        paths.remove(i);
      }
    }
  }
}

class Path {
  static final float SPEED = .01;
  static final int NUMBER_ATTEMPTS = 10;

  Base start, end;
  PVector p1, p2;
  float count;
  float delta = SPEED;
  
  Path() {
    start = null;
    // try several times to find a still live source
    int team = Bases.RED;
    for (int i = 0 ; i < NUMBER_ATTEMPTS ; i++) {
      team = (int)random(2);
      start = bases.getRandom(team);
      if (start.enabled == true) {
        break;
      } else {
        start = null;
      }
    }
    if (start == null) {
      // didn't find one
      return;
    }
    // pick an end point on the other team (dead or not)
    end = bases.getRandom(team ^ 1);
    // control points for the bezier curve
    p1 = start.get().copy().sub(0, 200);
    p2 = end.get().copy().sub(0, 200);
    debug(p1, p2);
    count = 0;
  }
  
  boolean draw() {
    //println("path:", count);
    count += delta;
    if (count >= 1) {
      // done, explode
      explosions.add(end.get());
      return true;
    }
    int dash = 0;
    stroke(255);
    strokeWeight(5);
    for (float i = 0 ; i < count ; i += delta) {
      if ((dash % 30) < 23) {
        float x = bezierPoint(start.get().x, p1.x, p2.x, end.get().x, i);
        float y = bezierPoint(start.get().y, p1.y, p2.y, end.get().y, i);
        point(x, y);
      }
      dash++;
    }
    return false;
  }
}

