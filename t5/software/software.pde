PImage img;
int w = 120;


float[][] matrix = { { 0, 0, 0 },
                     { 0,  1, 0 },
                     { 0, 0, 0 } }; 

void setup() {
  size(720, 720);
  img = loadImage("brayan.jpg"); 
}

void draw() {
  image(img, 0, 0);
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++ ) {
      color c = convolution(x, y, matrix, img);
      int pixel = x + y*img.width;
      pixels[pixel] = c;
    }
  }
  updatePixels();
}

color convolution(int x, int y, float[][] matrix, PImage img)
{
  float r = 0.0;
  float g = 0.0;
  float b = 0.0;
  for (int i = 0; i < 3; i++){
    for (int j= 0; j < 3; j++){
      int pixel = x + i + (y + j) * img.width;
      if(pixel < img.pixels.length-1){
        r += (red(img.pixels[pixel]) * matrix[i][j]);
        g += (green(img.pixels[pixel]) * matrix[i][j]);
        b += (blue(img.pixels[pixel]) * matrix[i][j]);
      } 
    }
  }
  return color(r, g, b);
}

void keyPressed() {
  if (key == '0') {  //Sharpness
     matrix = new float[][]{ { -1, -1, -1 },
                     { -1,  9, -1 },
                     { -1, -1, -1 } }; 
  }else if(key == '1'){ //Edge detection 1
    matrix = new float[][]{ { 1, 0, -1 },
                     { 0,  0, 0 },
                     { -1, 0, 1 } }; 
  }else if(key == '2'){ //Edge detection 2
    matrix = new float[][]{ { 0, 1, 0 },
                     { 1,  -4,  1},
                     { 0, 1, 0 } }; 
  }else if(key == '3'){ //Edge detection 3
    matrix = new float[][]{ { -1, -1, -1 },
                     { -1,  8, -1},
                     { -1, -1, -1} }; 
  }else if(key == '4'){ //Emboss
    matrix = new float[][]{ { 2, 0,  0},
                     { 0,  -1, 0},
                     { 0, 0, -1} }; 
  }else if(key == '5'){ //Repujado
    matrix = new float[][]{ { -2, -1,  0},
                     { -1,  1, 1},
                     { 0, 1, 2} }; 
  }else{ //Normal
    matrix = new float[][]{ { 0, 0,  0},
                     { 0,  1, 0},
                     { 0, 0, 0} }; 
  }
}
