//CHOOSE
//AN INTERACTIVE COLOR INSTALLATION BY SAMSON KLITSNER
//UPDATED FEBRUARY 15 2015
/*
 * Choose is an interactive installation that considers the relationship between decision and context
 * A projection of a 4 x 4 grid of colored dots is mapped to an all-white 16 button MIDI controller so that each button is colorized to a different hue.
 * Each button pressed changes the background to the button's corresponding color, altering the contrast relationship for remaining buttons
 */

// If there is no controller, use keys as specified in char array 'keys'

import ddf.minim.*;
import java.util.Random;
import java.util.Arrays;

Minim minim;

//darkMode initializes the pallette on a black background
boolean darkMode = true;
boolean firstKey = false;

/////////////////////////////////////////////////////////////////////
//////////////////FOR HD PROJECTOR: PROJECTOR == TRUE////////////////
/////////////////////////////////////////////////////////////////////
boolean projector = false;

AudioPlayer[] samples = new AudioPlayer[16];

float growthVariable = .0;
int scene = 1;
color[] colors = new color[16];
color[] endcolors = new color[16];
int[] binary = new int [16];
int[] binary2 = new int [16];
char[] keys = {
  'q', 'a', 'z', 't', 'w', 's', 'x', 'y', 'e', 'd', 'c', 'u', 'r', 'f', 'v', 'i'
};
color backgroundColor;
color newColor = color(255, 255, 255);
int k;
int L = 0;
int t = 0;
int exit = 0;
int waiting = 0;
int ampVariable;

void setup() {
  colorMode(HSB, 16, 100, 100);
  size(displayWidth, displayHeight);
  background(0, 0, 100);

  minim = new Minim(this);
  samples[0] = minim.loadFile("Bass.wav");
  samples[1] = minim.loadFile("Bells.wav");
  samples[2] = minim.loadFile("Chords.wav");
  samples[3] = minim.loadFile("Clanks.wav");
  samples[4] = minim.loadFile("crunch.wav");
  samples[5] = minim.loadFile("future.wav");
  samples[6] = minim.loadFile("morse.wav");
  samples[7] = minim.loadFile("ploop.wav");
  samples[8] = minim.loadFile("scrape.wav");
  samples[9] = minim.loadFile("Shake.wav");
  samples[10] = minim.loadFile("shutter.wav");
  samples[11] = minim.loadFile("Spray.wav");
  samples[12] = minim.loadFile("Texture.wav");
  samples[13] = minim.loadFile("Tick.wav");
  samples[14] = minim.loadFile("toaster.wav");
  samples[15] = minim.loadFile("wood.wav");

  //create array for colors that have been clicked
  for (L=0; L<16; L++) {
    binary[L] = 0;
  }

  //create (and then shuffle) array of colors that are evenly spaced in hue
  for (k=0; k<16; k++) {
    colors[k] = color(k+1, 100, 100);
  }

  shuffleSound(samples);
  //shuffle colors
  shuffleArray(colors);
  noLoop();
}

boolean sketchFullScreen() {
  return true;
}

void draw() {
  if (firstKey==true) {
    background(newColor);
  } else {
    background(0);
  }

  int k= 0;
  int tot= 0;
  for (float i = displayWidth/2-239; i < displayWidth/2+240; i = i+155) {
    for (float j = displayHeight/2-239; j < displayHeight/2+240; j = j+155) {
      noStroke(); 
      fill(colors[k]);
      ellipse(i, j, 80, 80);
      k++;
    }
  }
  for (int n = 0; n<16; n++) {
    tot = binary[n]+tot;
    if (tot==16) {
      exit = 1;

      waiting++;
      if (waiting>30) {

        if (growthVariable<1) {
          growthVariable+= .02;
          if (growthVariable>.5) {
            ampVariable+=(600/(25));
          }
        }
        ampVariable=600;
      }

      background(endcolors[15]);
      for (int r=0; r<16; r++) {
        fill(endcolors[r]);

        ellipse(width/2, height/2+5, growthVariable*(height-((height/8)+r*height/16))+ampVariable*samples[r].mix.level(), growthVariable*(height-((height/8)+r*height/16))+ampVariable*samples[r].mix.level());
      }
    }
  }
  fill(0);

  if (projector==true) {
    rect(0, 0, width, 50);
    rect(0, 0, 472, height);
    rect(0, height-55, width, 80);
    rect(width-480, 0, 500, height);
  }
}

void shuffleArray(int[] array) {

  //  Fisher–Yates shuffle 
  Random rng = new Random();
  println(rng);

  // i is the number of  remaining to be shuffled. 
  for (int i = array.length; i > 1; i--) {

    // Pick a random element to swap with the i-th element.
    int j = rng.nextInt(i);  // 0 <= j <= i-1 (0-based array)

    // Swap array elements.
    int tmp = array[j];
    array[j] = array[i-1];
    array[i-1] = tmp;
  }
}

void shuffleSound(AudioPlayer[] array) {

  //  Fisher–Yates shuffle 
  Random rng = new Random();

  // i is the number of items remaining to be shuffled. 
  for (int i = array.length; i > 1; i--) {

    // Pick a random element to swap with the i-th element.
    int j = rng.nextInt(i);  // 0 <= j <= i-1 (0-based array)

    // Swap array elements.
    AudioPlayer tmp = array[j];
    array[j] = array[i-1];
    array[i-1] = tmp;
  }
}

// click to re-shuffle...
void keyPressed() {
  firstKey = true;
  if (exit==1) {
    reset();
  } else {
    boolean triggered = false; // This is a boolean value that determines whether a key has been triggered or not
    for (int i = 0; i<16; i++) {
      if (key==keys[i]) {
        if (binary[i]==0) {
          binary[i]=1;
          triggered = true;
        }
      }
    }

    if (triggered == true) {
      arrayCopy(binary, binary2);
      int r;
      int p = 0;

      for (int i = 0; i<16; i++) {
        if (key==keys[i]) {
          samples[i].loop();
          newColor = (colors[i]);
          backgroundColor = newColor;
        }
      }

      for (r=0; r<16; r++) {
        if (binary[r]==1) {
          colors[r]=newColor;
        }
      }

      for (int n = 0; n<16; n++) {
        p = binary[n]+p;
      }
      if (p==16) {
        endcolors[15]=newColor;
        if (exit==1) {
          exit ();
        }
      } else
        endcolors[t]=newColor;
      t = (t + 1);
      loop();
    }
  }

  if (projector==true) {
    fill(0);
    rect(0, 0, width, 50);
    rect(0, 0, 472, height);
    rect(0, height-55, width, 80);
    rect(width-480, 0, 500, height);
  }
}

void reset() {
  ///Switches to new sound pallette after completion
  ///resets variables and randomizes sound arrays
  newColor = color(255, 255, 255);
  growthVariable=.0;
  ampVariable=0;
  waiting=0;
  L = 0;
  t = 0;
  exit = 0;
  firstKey=false;
  k= 0;

  for (L=0; L<16; L++) {
    binary[L] = 0;
    binary2[L] = 0;
    samples[L].pause();
  }
  for (k=0; k<16; k++) {
    colors[k] = color(k+1, 100, 100);
  }

  shuffleArray(colors);

  scene ++;
  if (scene==4) {
    scene=1;
  }

  for (k=0; k<16; k++) {
    samples[k].close();
  }
  if (scene==3) {
    samples[0] = minim.loadFile("11.wav");
    samples[1] = minim.loadFile("12.wav");
    samples[2] = minim.loadFile("13.wav");
    samples[3] = minim.loadFile("27.wav");
    samples[4] = minim.loadFile("15.wav");
    samples[5] = minim.loadFile("16.wav");
    samples[6] = minim.loadFile("17.wav");
    samples[7] = minim.loadFile("18.wav");
    samples[8] = minim.loadFile("19.wav");
    samples[9] = minim.loadFile("20.wav");
    samples[10] = minim.loadFile("21.wav");
    samples[11] = minim.loadFile("22.wav");
    samples[12] = minim.loadFile("23.wav");
    samples[13] = minim.loadFile("24.wav");
    samples[14] = minim.loadFile("25.wav");
    samples[15] = minim.loadFile("26.wav");
    shuffleSound(samples);
  }
  if (scene==2) {
    samples[0] = minim.loadFile("a.wav");
    samples[1] = minim.loadFile("s.wav");
    samples[2] = minim.loadFile("d.wav");
    samples[3] = minim.loadFile("f.wav");
    samples[4] = minim.loadFile("q.wav");
    samples[5] = minim.loadFile("w.wav");
    samples[6] = minim.loadFile("e.wav");
    samples[7] = minim.loadFile("r.wav");
    samples[8] = minim.loadFile("z.wav");
    samples[9] = minim.loadFile("x.wav");
    samples[10] = minim.loadFile("c.wav");
    samples[11] = minim.loadFile("v.wav");
    samples[12] = minim.loadFile("t.wav");
    samples[13] = minim.loadFile("y.wav");
    samples[14] = minim.loadFile("u.wav");
    samples[15] = minim.loadFile("i.wav");
    shuffleSound(samples);
  }
  if (scene==1) {
    samples[0] = minim.loadFile("Bass.wav");
    samples[1] = minim.loadFile("Bells.wav");
    samples[2] = minim.loadFile("Chords.wav");
    samples[3] = minim.loadFile("Clanks.wav");
    samples[4] = minim.loadFile("crunch.wav");
    samples[5] = minim.loadFile("future.wav");
    samples[6] = minim.loadFile("morse.wav");
    samples[7] = minim.loadFile("ploop.wav");
    samples[8] = minim.loadFile("scrape.wav");
    samples[9] = minim.loadFile("Shake.wav");
    samples[10] = minim.loadFile("shutter.wav");
    samples[11] = minim.loadFile("Spray.wav");
    samples[12] = minim.loadFile("Texture.wav");
    samples[13] = minim.loadFile("Tick.wav");
    samples[14] = minim.loadFile("toaster.wav");
    samples[15] = minim.loadFile("wood.wav");
    shuffleSound(samples);
  }
  if (darkMode==true) {
    background(0, 100, 0);
  } else {
    background(0, 0, 100);
  }
}
