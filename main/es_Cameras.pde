final int CAMERA_W = 70; // The black camera box size in world units.
final int CAMERA_H = 40;

// The camera on position 0, 0 cannot be removed.

class Cameras extends EditorComponent{
  void displayMenu(){
    if(menu_delta>0.01){
      float w = 500;
      float h = 150;
      float y = height-(h-10)*menu_delta+1;
      float x = width/2-w/2;
      rectMode(CORNERS);
      uiBox(x,y,w,h,0,255);
    }
  }
  
  void edit(){
  }

  void add(int[] p, int[] new_camera){
    List<Integer> pos = intArrToList(p);
    data.put(pos, new_camera);
  }

  void remove(int[] p){
    List<Integer> pos = intArrToList(p);
    data.remove(pos);
  }

  void drawLayer(int layer, color c){
    resetShader();
    for (List<Integer> pos: data.keySet()) {
      strokeWeight(0.5);fill(0,0);stroke(50,50);
      rect(pos.get(X),pos.get(Y), CAMERA_W, CAMERA_H); // Draws the camera's bounds.
    }
  }

  int[] getMinMax(){ // returns min and max camera bounds
    int min_x=0; int max_x=0;
    int min_y=0; int max_y=0;
    for (List<Integer> pos: data.keySet()){
      int x = pos.get(X);
      int y = pos.get(Y);
      if(x>min_x) min_x=x; else if(x<max_x) max_x=x;
      if(y>min_y) min_y=y; else if(y<max_y) max_y=y;
    }
    return new int[]{min_x,min_y, max_x+CAMERA_W,max_y+CAMERA_H};
  }
}