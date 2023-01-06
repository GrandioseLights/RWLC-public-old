// Props are GT components that can be rotated and be placed freely on specific layers. They do not have tiles.
public static final int ROTATION = 1;
class Props extends EditorComponent{
  int last_x=0;
  int last_y=0;
  float r=0;
  void displayMenu(){}
  void edit(){
    pushMatrix();
    resetMatrix();
    for (List<Integer> pos: data.keySet()) {
      if(pos.get(Z)==current_layer){
        GraphicTile gt = array_graphicTiles.get(data.get(pos)[GT_TYPE]);
        float theta=data.get(pos)[ROTATION]/100f;
        float c=cos(theta);
        float s=sin(theta);
        float w=gt.w*10*editor_zoom;
        float h=gt.h*10*editor_zoom;
        float x=editor_ox+pos.get(X)*editor_zoom;
        float y=editor_oy+pos.get(Y)*editor_zoom;
        if(inPolygon( // User hovers over an existing prop // Account for the rotation of the prop.
        new float[][]{{w*c-h*s+x,w*s+h*c+y},{-w*c-h*s+x,-w*s+h*c+y},{-w*c+h*s+x,-w*s-h*c+y},{w*c+h*s+x,w*s-h*c+y}},
        new int[]{mouseX,mouseY})){ // if the user right clicks, delete the prop being hovered over
          if(mouse_released&&mouseButton==RIGHT){
            data.remove(pos);
            popMatrix();
            return;
          }
        }
      }
    }
    if(mousePressed){ // Create rotation for a new prop  
      r = -atan2(mouseX - last_x, mouseY - last_y);
    }else{
      if(!mouse_released){
        last_x = mouseX;
        last_y = mouseY;
        r = 0;
      }
    }
    int x = floor((last_x-editor_ox)/editor_zoom);
    int y = floor((last_y-editor_oy)/editor_zoom);
    if(graphic_type>array_graphicTiles.size()-1)graphic_type=0;else if(graphic_type<0)graphic_type=array_graphicTiles.size()-1;
    GraphicTile gt = array_graphicTiles.get(graphic_type);
    imageMode(CENTER);tint(255,100);
    translate(last_x,last_y);
    rotate(r);
    image(gt.editor_image,0,0,(gt.w+gt.padding*2)*ez_us,(gt.h+gt.padding*2)*ez_us); // Draw tile ghost.
    if(mouse_released||mouse_clicked){
      switch(mouseButton){
        case LEFT:
          add(new int[]{x, y, current_layer}, new int[]{graphic_type, floor(r*100)});
        break;
        case RIGHT:
          //add but in a line instead, the curve thing.
        break;
      }
    }
    popMatrix();
  }
  
  void add(int[] pos, int[] info){
    data.put(intArrToList(pos), info);
  }

  void remove(int[] p){
  }

  void drawLayer(int layer, color c){
    imageMode(CENTER);tint(255);
    for (List<Integer> pos: data.keySet()) {
      if(pos.get(Z)==layer){
        GraphicTile gt = array_graphicTiles.get(data.get(pos)[GT_TYPE]);
        if(gt!=null){
          pushMatrix();
          resetMatrix();
          float x = editor_ox+pos.get(X)*editor_zoom;
          float y = editor_oy+pos.get(Y)*editor_zoom;
          translate(x, y);
          scale(editor_zoom);
          rotate(data.get(pos)[ROTATION]/100f);
          PImage img = gt.editor_image;
          image(img,0,0,(gt.w+gt.padding*2)*UNIT_SIZE,(gt.h+gt.padding*2)*UNIT_SIZE);
          popMatrix();
        }
      }
    }
  }
}