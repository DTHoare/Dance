//Daniel Hoare 2017
//Dance - a beat based animation, using standing waves to represent a dance waveform

/*-----------------------------------------------
globals
-----------------------------------------------*/
int fps = 90;
float revs = 2*PI/fps;
color pink = color(255, 80, 165);
color white = color(255);
color black = color(0);
int nBars = 64;

ArrayList<Bar> bars;

/*-----------------------------------------------
Setup
-----------------------------------------------*/
void setup() {
  size(1340,740);
  frameRate(fps);
  bars = new ArrayList<Bar>();
  
  //generate set of bars:
  for(int i = 0; i < nBars; i++) {
    //center bars symmetrically for even or odd
    float x = width/2 - (i- (nBars-1)/2.0) * width/(nBars);
    float w = width/(nBars) * 0.8;
    float h = 95;
    Bar b = new Bar(x, height/2, w, h, black);
    bars.add(b);
  }
}

/*-----------------------------------------------
draw
-----------------------------------------------*/
void draw() {
  background(white);
  //alternate between pink and black bars on the beat
  if(frameCount %fps < fps/2) {
    fill(pink);
    for(Bar b : bars) {
      b.col = black;
    }
  } else {
    fill(black);
    for(Bar b : bars) {
      b.col = pink;
    }
  }
  rectMode(CENTER);
  noStroke();
  rect(width/2,height/2, width, height*0.4);
  
  //animation the bars with standing waves
  for(int i = 0; i < nBars; i++) {
    
    float h = 150*sawtoothStanding(float(i));
    h+=  150*triangleStanding(float(i));
    
    //size of waves is a small constant plus an attack-sustain-decay envelope
    float a = envelope(0.2, 0.05, 0.05, frameCount, fps/2 );
    bars.get(i).size.y = h*(0.3+0.5*a);
  }
  
  for(Bar b : bars) {
    b.display();
  }
  
  if(frameCount <= fps && frameCount % 3 ==0) {
    //saveFrame("image-##.png");
  }
}

/*-----------------------------------------------
Math functions
-----------------------------------------------*/
//exponential decay sin wave
float wiggle(int T, float A, float a, float s) {
  float t = (frameCount) % (T);
  return( A * exp(-t*a) * sin(frameCount * 2*PI/(T/s)));
}

//attack-sustain-decay waveform, periodic in T, using time variable t
//first 3 variables normalised such that 1 = T
float envelope(float attack, float sustain, float decay, float t, float T) {
  float time = ((t+attack*T)%T)/T;
  if(time <= attack) {
    //linear ramp up
    return time/attack;
  } else if(time <= (attack + sustain)) {
    //flat
    return 1;
  } else if(time <= (attack + sustain + decay)) {
    //linear ramp down
    return 1 - ((time-attack-sustain)/decay);
  } else {
    //off
    return 0;
  }
}

//waveform forms taken from wikipedia waveforms https://en.wikipedia.org/wiki/Waveform
float sawtoothStanding(float i) {
  float a = atan(tan( i*2*PI/(nBars-1.0) + revs * frameCount));
    a += atan(tan( i*2*PI/(nBars-1.0) - revs * frameCount));
    return a;
}

float triangleStanding(float i) {
  float a = asin(sin( 2*PI/(nBars-1.0)*i + revs * frameCount));
    a += asin(sin( 2*PI/(nBars-1.0)*i - revs * frameCount));
    return a;
}