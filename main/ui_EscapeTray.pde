// This overlays the current screen. It will dim and cover the top and bottom of the screen with black rectangles.
class EscapeTray{
  float d = 0; // Value to control things in the escape tray.
  boolean active = false;
  EscapeTray() {
  }
  void toggle(){
    active=!active;
  }
  void update(){
    if(active){
      editing_allowed = false;
      editor_focused = false;
      editor_canZoom = false;
      d = lerp(d, 100, 0.1);
      if(d>99.99)d=100;
    }else{
      d = lerp(d, 0, 0.2);
      if(d<.01)d=0;
    }
    if (d!=0) {
      rectMode(CORNER);
      noStroke();
      fill(0, 0, 0, 255);
      rect(0,-100+d, width, 100);
      rect(0,height+40-d, width, 150);
      fill(0, 0, 0, d);
      rect(0,0,width,height);
    }
  }
}