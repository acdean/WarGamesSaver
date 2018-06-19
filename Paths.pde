class Paths {
  ArrayList<Path> paths = new ArrayList<Path>();
  
  void add() {
    paths.add(new Path());
  }
  
  void draw() {
    for (int i = paths.size() - 1 ; i >= 0 ; i--) {
      if (paths.get(i).draw() == true) {
        // finished, so delete
        println("deleting...");
        paths.remove(i);
      }
    }
  }
}

class Path {
  Base start, end;
  PVector p1, p2;
  float count;
  float delta = .001;
  
  Path() {
    // TODO should be different sides
    start = bases.get((int)random(Bases.BASES));
    do {
      end = bases.get((int)random(Bases.BASES));
    } while (start == end);
    p1 = start.get().copy().sub(0, 200);
    p2 = end.get().copy().sub(0, 200);
    println(p1, p2);
    count = 0;
  }
  
  boolean draw() {
    //println("path:", count);
    count += delta;
    if (count >= 1) {
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