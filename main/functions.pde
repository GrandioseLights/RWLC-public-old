
boolean coordInBounds(float x1, float y1, float w1, float h1, float x2, float y2) {
  if (x1>x2||x1+w1<=x2||y1>y2||y1+h1<=y2) {return false;} else {return true;}
}

boolean areaInBounds(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  if (x1>x2+w2||x1+w1<=x2||y1>y2+h2||y1+h1<=y2) {return false;} else {return true;}
}

ArrayList<int[]> bresenham(int x0, int y0, int x1, int y1) {
  if (abs(y1-y0)<abs(x1-x0)){
    if(x0>x1){return bresenLow(x1,y1,x0,y0);}
    else{return bresenLow(x0,y0,x1,y1);}
  }else{
    if(y0>y1){return bresenHigh(x1,y1,x0,y0);}
    else{return bresenHigh(x0,y0,x1,y1);}
  }
}

ArrayList<int[]> bresenLow(int x0, int y0, int x1, int y1) {
  ArrayList<int[]> out=new ArrayList<int[]>();
  int dx=x1-x0;int dy=y1-y0;int yi=1;
  if(dy<0){yi=-1;dy=-dy;}
  int D=(2*dy)-dx;int y=y0;
  for(int x=x0;x<=x1;x++){
    out.add(new int[]{x,y});
    if(D>0){y+=yi;D+=(2*(dy-dx));}
    else{D+=2*dy;}
  }return out;
}

ArrayList<int[]> bresenHigh(int x0, int y0, int x1, int y1) {
  ArrayList<int[]> out=new ArrayList<int[]>();
  int dx=x1-x0;int dy=y1-y0;int xi=1;
  if(dx<0){xi=-1;dx=-dx;}
  int D=(2*dx)-dy;int x=x0;
  for(int y=y0;y<=y1;y++){
    out.add(new int[]{x,y});
    if(D>0){x+=xi;D+=(2*(dx-dy));}
    else{D+=2*dx;}
  }return out;
}

ArrayList<int[]> fillArea(int x0, int y0, int x1, int y1) {
  ArrayList<int[]> out=new ArrayList<int[]>();
  int rx=min(x0, x1);
  int tx=max(x0, x1);
  for(int y=min(y0,y1);y<=max(y0,y1);y++){
    for(int x=rx;x<=tx;x++){
      out.add(new int[]{x, y});
    }
  }
  return out;
}

PImage imageFromString(String in) {
  try{
    byte[] ba=Base64.getDecoder().decode(in.getBytes());
    try{ImageIO.write(ImageIO.read(new ByteArrayInputStream(ba)), "png", new File(dataPath("temp.png")));}
    catch(Exception e){log("error",e.toString());}
  }catch(Exception e){log("error",e.toString());}
  PImage img=loadImage("temp.png");
  return img;
}

int[] stringToIntArray(String s){
  try{return Stream.of(split(s.replaceAll("\\s+",""),',')).mapToInt(Integer::parseInt).toArray();}
  catch(NumberFormatException e){return new int[]{0};}
}

List<Integer> intArrToList(int[] array){
  return Arrays.stream(array).boxed().toList();
}

PImage replaceColour(PImage oi, color in, color out) {
  PImage ni=oi;
  loadPixels();
  for (int i=0;i<oi.pixels.length;i++) {
    if(oi.pixels[i]==in)ni.pixels[i]=out;
  }return ni;
}

String encode(String in){
  return Base64.getEncoder().encodeToString(in.getBytes());
}

String decode(String coded){
  return new String(Base64.getDecoder().decode(coded.getBytes()));
}

boolean inPolygon(float[][] s, int[] p) {
  // Retreived from https://www.algorithms-and-technologies.com/point_in_polygon/java
  // Date: 2022-09-14
  boolean r=false;
  for (int i=0, j=s.length-1; i<s.length; i++) {
    if (((s[i][1]>p[1])!=(s[j][1]>p[1]))&&(p[0]<(s[j][0]-s[i][0])*(p[1]-s[i][1])/(s[j][1]-s[i][1])+s[i][0]))r=!r;
    j=i;
  }
  return r;
} 

float _max(float x, float y){
  if(x<y){return y;}else if(x>y){return x;}else{return x;}
}

void backgroundGradient(color c1, color c2) {
  noFill();
  for (int i = 0; i <= height; i++) {
    color c = lerpColor(c1, c2, norm(i, 0, height));
    stroke(c);
    line(0, i, width, i);
  }
}

void setScreen(String s){
  //log("debug", screen+" -> "+s);
  screen = s;
}

int[] addToArray(int[] array, int i){
  int[] newArray = new int[array.length+1];
  for (int j = 0; j < array.length; j++) newArray[j] = array[j];
  newArray[array.length] = i;
  return newArray;
}

boolean contains(int[] arr, int key) {
  // Retreived from https://stackoverflow.com/a/34541755
  // Date: 2022-12-23
  return Arrays.stream(arr).anyMatch(i -> i == key);
}