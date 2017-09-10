class Bar {
  PVector pos;
  PVector size;
  color col;
  
  /*-----------------------------------------------
  Constructors
  -----------------------------------------------*/
  Bar(float x, float y) {
    pos = new PVector(x, y);
    col = color(255);
    size = new PVector(5, 5);
  }
  
  Bar(float x, float y, color col_) {
    pos = new PVector(x, y);
    col = col_;
    size = new PVector(5, 5);
  }
  
  Bar(float x, float y, float w, float h, color col_) {
    pos = new PVector(x, y);
    size = new PVector(w, h);
    col = col_;
  }
  
  /*-----------------------------------------------
  Display
  -----------------------------------------------*/
  void display() {
    //the size and position of the bars are 'wiggled' to create a bang effect
    PVector sizeT = size.copy();
    sizeT.x *= (0.3 + 0.7*envelope(0.2, 0.05, 0.05, frameCount, fps/2 ));
    PVector posT = pos.copy();
    float lambda = width/(nBars);
    //posT.x += wiggle(fps/2, 0.3*(width/2-pos.x), 0.3, 2);
    posT.x += wiggle(fps/2, 50*sin(pos.x * 2*PI/lambda), 0.3, 2);
    // posT.y += wiggle(fps/2, 0.3*(sizeT.y+10), 0.6, 3);
    posT.y += wiggle(fps/2, 50*sin(pos.x * 2*PI/lambda), 0.1, 4);
    float angle = wiggle(fps/2, PI/16, 0.4, 4);
    
    noStroke();
    rectMode(CENTER);
    pushMatrix();
    translate(posT.x, posT.y);
    rotate(angle);
      fill(col);
      //rounded rect made from rect and ellipses
      //ensure that the rect doesn't become too small such that the effect is ruined
      float y  = max(0,(abs(sizeT.y) - (2 * sizeT.x)));
      rect(0,0,sizeT.x, y);
      ellipse(0,-y/2, sizeT.x, sizeT.x);
      ellipse(0,y/2, sizeT.x, sizeT.x);
    popMatrix();
  }
}