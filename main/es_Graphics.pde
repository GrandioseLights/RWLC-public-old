public static final int GT_TYPE = 0;

class Graphics extends EditorComponent{
  private float t_scroll_y = 0;
  private float scroll_y = 0;
  void displayMenu(){
    if(scroll_y!=t_scroll_y) scroll_y = lerp(scroll_y,t_scroll_y,0.5);
    if(menu_delta>0.01){
      float w = 1120;
      float h = 300;
      float y = height-(h-40)*menu_delta+1;
      float x = width/2-w/2;
      uiBox(x,y,w,h,0,255);
      if(coordInBounds(x,y,w,h,mouseX,mouseY)){
        editing_allowed=false;
        editor_canZoom=false;
        if(mouse_wheel!=null) t_scroll_y+=mouse_wheel.getCount()*20;
      }
      /*
      int k = 0;
      for(int i: graphic_table.getIntColumn("id")){
        PImage icn = array_graphicTiles.get(i).editor_image;
        image(icn, x+(k%w), scroll_y+y+floor(k/w)*60+65);
        k+=icn.width+10;
      }*/
      for(Button b: graphic_editor_buttons){
        b.update(x+60, y, 255);
        if(clicked_button == b){
          graphic_table.sort(b.text);
          log("debug","Sorting by "+b.text);
        }
      }
    }
  }

  void edit(){
    GraphicTile gt = array_graphicTiles.get(graphic_type);
    if(mousePressed){
      posArray = bresenham(mouse_px, mouse_py, mouse_x, mouse_y); 
      for(int[] pos: posArray){project.graphics.getGTPos(new int[]{pos[X], pos[Y], current_layer});}
      switch(mouseButton){
        case LEFT:
          for(int[] pos: posArray){project.graphics.add(new int[]{pos[X], pos[Y], current_layer}, new int[]{graphic_type});}
        break;
        case RIGHT:
          for(int[] pos: posArray){project.graphics.remove(new int[]{pos[X], pos[Y], current_layer});}
        break;
      }
    }
    translate(editor_ox,editor_oy);
    scale(ez_us);
    imageMode(CORNER);tint(255);
    image(gt.editor_image,mouse_x-gt.padding,mouse_y-gt.padding,gt.editor_image.width/UNIT_SIZE,gt.editor_image.height/UNIT_SIZE); // Draw tile ghost.
    resetMatrix();
  }

  void add(int[] pos, int[] info){
    GraphicTile gt = array_graphicTiles.get(info[GT_TYPE]); // Grab the GT data.
    ArrayList<int[]> pos_rq = fillArea(pos[X],pos[Y],pos[X]+gt.w-1,pos[Y]+gt.h-1); // Get positions used by the GT.
    for(int i = 0; i < pos_rq.size(); i++){
      // If a tile exists, has a true binding flag, and the position of the tile exists in the requires position list, then the GT cannot be placed.
      try{if(project.tiles.get(new int[]{pos_rq.get(i)[X],pos_rq.get(i)[Y], pos[Z]})[BIND_FLAG]==BINDED){return;}}
      catch(NullPointerException e){} // Sometimes a position will have no info.
    }
    for(int i=0; i < pos_rq.size(); i++){ // Iterate through the GT's tile and place tiles.
      project.tiles.add(new int[]{pos_rq.get(i)[X],pos_rq.get(i)[Y], pos[Z]}, new int[]{gt.geo_1[i], BINDED});
    }
    data.put(intArrToList(pos), info);
  }

  void remove(int[] pos){
    List<Integer> gt_pos = getGTPos(pos);
    if(gt_pos!=null){
      GraphicTile gt = array_graphicTiles.get(data.get(gt_pos)[GT_TYPE]);
      for(int[] p : fillArea(gt_pos.get(X), gt_pos.get(Y), gt_pos.get(X)+gt.w-1, gt_pos.get(Y)+gt.h-1)){
        project.tiles.remove(new int[]{p[X],p[Y],pos[Z]}, true);
      }
      data.remove(gt_pos);
    }
  }

  List<Integer> getGTPos(int[] pos){ // GetTile is a unique case as GT components take up multiple positions instead of just one.
    fill(0);
    for (List<Integer> gt_pos: data.keySet()) {
      if (gt_pos.get(Z) == pos[Z]){  // Z layer must be the same.
        GraphicTile gt = array_graphicTiles.get(data.get(gt_pos)[GT_TYPE]);
        if(coordInBounds(gt_pos.get(X), gt_pos.get(Y), gt.w, gt.h, pos[X], pos[Y])){
          //rect((float) gt_pos.get(X), (float) gt_pos.get(Y), (float) gt.w, (float) gt.h); // debug
          return gt_pos;
        }
      }
    }
    return null;
  }

  void drawLayer(int layer, color c){
    imageMode(CORNER);//tint(c);
    for (List<Integer> pos: data.keySet()) {
      if(pos.get(Z)==layer){
        GraphicTile gt = array_graphicTiles.get(data.get(pos)[GT_TYPE]);
        if(gt!=null){
          PImage img = gt.editor_image;
          image(img,pos.get(X)-gt.padding,pos.get(Y)-gt.padding,img.width/UNIT_SIZE,img.height/UNIT_SIZE);
        }
      }
    }
  }

  PImage renderLayer(int l){
    imageMode(CORNER);tint(255);
    PGraphics layer_img = createGraphics(1400, 800);
    layer_img.beginDraw();
    for (List<Integer> pos: data.keySet()) {
      GraphicTile gt = array_graphicTiles.get(data.get(pos)[GT_TYPE]);
      if (l<=pos.get(Z)+gt.slices.length) {
        int dw = (gt.w+gt.padding*2)*UNIT_SIZE;
        int dh = (gt.h+gt.padding*2)*UNIT_SIZE;
        PGraphics slice = createGraphics(dw, dh);
        slice.beginDraw();
        try{
          int s = (gt.slices[l]-1)*dh+1;
          slice.image(gt.sheet_image, 0, 0, dw, dh, 1, s, dw, dh+s);
        }catch(Exception e){}
        slice.endDraw();
        layer_img.image(slice, (pos.get(X)-gt.padding)*UNIT_SIZE-1+render_buffer_x, (pos.get(Y)-gt.padding)*UNIT_SIZE+render_buffer_y);
      }
    }
    layer_img.endDraw();
    return layer_img;
  }
}

/* 
 -1 = occupied air
 0 = unoccupied air
 1 = solid
 2 = slope qII
 3 = slope qI
 4 = slope qIII
 5 = slope qIV
 
 "Medium Shelter N"
 1,1,1,1,1,1,1,
 0,0,0,0,0,0,1,
 0,0,0,0,0,0,1,
 0,0,0,0,0,0,1,
 0,0,0,0,0,0,1,
 0,0,0,0,0,0,1,
 1,1,1,1,1,1,1
 
 "big ball"
 3,1,5,
 1,1,1,
 2,1,4
*/


