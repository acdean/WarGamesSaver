// War Games

import processing.opengl.*;
import com.jogamp.opengl.*;  // new jogl - 3.0b7

PGraphics screen;
PImage fuzzy;
static final int MAPSIZE = 1 << 8; // must be a power of two
float map[][] = new float[MAPSIZE + 1][MAPSIZE + 1]; // 0 to MAPSIZE (inclusive)
int threshold;

Bases bases = new Bases();
Paths paths = new Paths();

void setup() {
  size(1000, 800, P2D);
  screen = createGraphics(width, height);
  generate();
  bases.init();
  // add a path
  paths.add();
}

// generates a terrain using diamond-square
void generate() {
// all corners random
//  map[0][0] = random(256);
//  map[0][MAPSIZE] = random(256);
//  map[MAPSIZE][0] = random(256);
//  map[MAPSIZE][MAPSIZE] = random(256);
  // island generation - high in the middle, sea at the edges
  map[0][0] = 0;
  map[0][MAPSIZE] = 0;
  map[MAPSIZE][0] = 0;
  map[MAPSIZE][MAPSIZE] = 0;
  map[MAPSIZE / 2][MAPSIZE / 2] = random(128, 256);
  // generate map, start with large square, half size every time
  // (can't recurse because the smaller squares depend on the larger)
  for (int s = MAPSIZE / 2 ; s > 1 ; s /= 2) {
    for (int y = 0 ; y < MAPSIZE ; y += s) {
      for (int x = 0 ; x < MAPSIZE ; x += s) {
        diamond(x, y, s);
      }
    }
    for (int y = 0 ; y < MAPSIZE ; y += s) {
      for (int x = 0 ; x < MAPSIZE ; x += s) {
        square(x, y, s);
      }
    }
  }
  // calculate threshold so that n% of the screen is water
  int[] count = new int[500];
  for (int y = 0 ; y < MAPSIZE ; y++) {
    for (int x = 0 ; x < MAPSIZE ; x++) {
      if (map[x][y] > 0) {
        count[(int)(map[x][y])]++;
      }
    }
  }
  int sum = 0;
  for (int i = 0 ; i < 500 ; i++) {
    //println(i, count[i]);
    sum += count[i];
    if (sum > MAPSIZE * MAPSIZE * .5) {
      threshold = i;
      //println("threshold: ", threshold);
      break;
    }
  }
}

void draw() {
  background(0);
  bases.draw();
  paths.draw();
  if (random(100) < 1) {
    paths.add();
  }
}

void drawLandscape() {
  for (int y = 0 ; y < MAPSIZE ; y++) {
    for (int x = 0 ; x < MAPSIZE ; x++) {
      if (map[x][y] < threshold) {
        stroke(0);
        fill(0);
      } else {
        stroke(map[x][y]);
        fill(map[x][y]);
      }
      rect(x * 2, y * 2, 2, 2);
    }
  }
  saveFrame("landscape_####.png");
}

// attempt at 80s fuzzy vector graphics
// generally draw the scene, take a copy, blur it, additive blend with original
// need to play with blur.
// shader?
void draw2() {
  background(0);

  screen.beginDraw(); 
  screen.clear();
  //screen.translate(width / 2, height / 2);
  for (int s = 0 ; s < 20 ; s++) {
    screen.beginShape();
    screen.noFill();
    screen.strokeWeight(3);
    float radius = random(50, 100);
    float x = random(width);
    float y = random(height);
    float d = random(TWO_PI);
    screen.stroke(random(256), random(256), random(256));
    for (int i = 0 ; i < 10 ; i++) {
      float a = d + (TWO_PI * i / 10.0);
      if ((i & 1) == 0) {
        screen.vertex(x + radius * .5 * sin(a), y + radius * .5 * cos(a));
      } else {
        screen.vertex(x + radius * sin(a), y + radius * cos(a));
      }
    }
    screen.endShape(CLOSE);
  }
  screen.endDraw();

  // for the glow
  // copy screen to fuzzy and blur
  try {
    fuzzy = (PImage)screen.clone();
  } catch (Exception e) {
    e.printStackTrace();
  }
  image(fuzzy, 0, 0);
  filter(BLUR, 8);
  updatePixels(); // this is needed for the blending
  
  // additive blending
  GL gl = ((PJOGL)beginPGL()).gl.getGL();
  gl.glEnable(GL.GL_BLEND);
  gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
  gl.glDisable(GL.GL_DEPTH_TEST);

  // copy to screen
  image(screen, 0, 0);
  noLoop();
}

void mousePressed() {
  generate();
  redraw();
}

// diamond-square terrain code
// map is a 2^n + 1 square array
// A . 1 . B
// . . . . .
// 2 . m . 3
// . . . . .
// C . 4 . D
void diamond(int x, int y, int size) {

  //println(x, y, size);
  
  int FACTOR = size / 4;
  int xa = x;
  int ya = y;
  int xb = x + size;
  int yb = y;
  int xc = x;
  int yc = y + size;
  int xd = x + size;
  int yd = y + size;
  int xm = x + size / 2;
  int ym = y + size / 2;
  // diamond (m)
  map[xm][ym] = (map[xa][ya] + map[xb][yb] + map[xc][yc] + map[xd][yd]) / 4 + random(-FACTOR, FACTOR);
}

void square(int x, int y, int size) {

  int FACTOR = size / 4;
  int xa = x;
  int ya = y;
  int xb = x + size;
  int yb = y;
  int xc = x;
  int yc = y + size;
  int xd = x + size;
  int yd = y + size;
  int xm = x + size / 2;
  int ym = y + size / 2;
  // square (1, 2, 3, 4)
  // these can wrap
  int ydown = (y + (size / 2)) % MAPSIZE;
  int xright = (x + (size / 2)) % MAPSIZE;
  int yup = ((y - (size / 2)) + MAPSIZE) % MAPSIZE;
  int xleft = ((x - (size / 2)) + MAPSIZE) % MAPSIZE;
  int x1 = xm;
  int y1 = y;
  int x2 = x;
  int y2 = ym;
  int x3 = x + size;
  int y3 = ym;
  int x4 = xm;
  int y4 = y + size;
  // 1 is average of A B m up 
  map[x1][y1] = (map[xa][ya] + map[xb][yb] + map[xm][ym] + map[xm][yup]) / 4 + random(-FACTOR, FACTOR); // 1
  // 2 is the average of A C m and left
  map[x2][y2] = (map[xa][ya] + map[xc][yc] + map[xm][ym] + map[xleft][ym]) / 4 + random(-FACTOR, FACTOR); // 2
  // 3 is the average of B D m and right
  map[x3][y3] = (map[xb][yb] + map[xd][yd] + map[xm][ym] + map[xright][ym]) / 4 + random(-FACTOR, FACTOR); // 3
  // 4 is the average of C D m and down
  map[x4][y4] = (map[xc][yc] + map[xd][yd] + map[xm][ym] + map[xm][ydown]) / 4 + random(-FACTOR, FACTOR); // 4
}