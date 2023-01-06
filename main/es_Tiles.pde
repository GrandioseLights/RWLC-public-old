public static final int BLOCK_GRAPHIC = -1;
public static final int AIR = 0;
public static final int SOLID = 1;
public static final int SLOPE_1 = 2;
public static final int SLOPE_2 = 3;
public static final int SLOPE_3 = 4;
public static final int SLOPE_4 = 5;
public static final int PIPE_END = 6;
public static final int PLATFORM = 7;
//---
public static final int POLE_V = 8;
public static final int POLE_H = 9;
public static final int GLASS = 10;
public static final int PIPE_PIP = 11;
public static final int ROOM_EXIT = 12;
public static final int LIZ_DEN = 13;
public static final int LIZ_END = 14;
public static final int SCAV_DEN = 15;
public static final int DEAD_END = 16;
public static final int GARBAGE_HOLE = 17;
public static final int WORM_GRASS = 18;
public static final int HIVE = 19;
public static final int WATERFALL = 20;
//--

public static final int BIND_FLAG = 0;
public static final int TILE_TYPE = 1;

public static final int NO_BIND = 0;
public static final int BINDED = 1;
 
// WORMGRASS
// WORM_DEN(?)

String[] tile_names = { // When getting data from this, add 1 to the index because of the -1 tile type ID.
  "Graphic Blocker","Air","Solid","Slope 1","Slope 2","Slope 3","Slope 4",
  "Vertical Pole","Horizontal Pole","Platform"
};

class Tiles extends EditorComponent{
  private int edit = 0; // 0 = geometry, 1 = pipes, 2 = materials
  private int r = 0;  // rotation mode
  private int mp = 0; // Menu pick
  private float pick_box_x = 0;
  void displayMenu(){
    if(key_pressed){switch(key){
      case 'q': r+=1;if(r>3)r=0; break; case 'e': r-=1;if(r<0)r=3; break; // Rotation
      case 'd': mp+=1;if(mp>3)mp=0; break; case 'a': mp-=1;if(mp<0)mp=3; break; // Selection
      case '1': mp=0; break; 
      case '2': if(mp!=1){mp=1;}else{r+=1;} break; 
      case '3': if(mp!=2){mp=2;}else{r+=1;} break; 
      case '4': mp=3; break;
    }}
    int[] tile_picker_arr = new int[]{SOLID,new int[]{SLOPE_1,SLOPE_2,SLOPE_4,SLOPE_3}[r%4],new int[]{POLE_V,POLE_H}[r%2],PLATFORM};
    if(menu_delta>0.01){
      float w = 400;
      float h = 150;
      float y = height-(h-10)*menu_delta+1;
      float x = width/2-w/2;
      float y2 = y+h/4;
      float[] xArr = new float[]{x+(w/5)-40,x+(2*w/5)-35,x+(3*w/5)-25,x+(4*w/5)-20};
      if(coordInBounds(x, y, w, h, mouseX, mouseY)){editing_allowed = false;}
      rectMode(CORNER);
      uiBox(x,y,w,h,0,255);
      noStroke();
      fill(100);
      drawSingle(xArr[0],y2,tile_picker_arr[0],60);
      drawSingle(xArr[1],y2,tile_picker_arr[1],60);
      drawSingle(xArr[2],y2,tile_picker_arr[2],60);
      drawSingle(xArr[3],y2,tile_picker_arr[3],60);
      if(coordInBounds(xArr[0]-20,y2-20,w+40,h+40,mouseX,mouseY)&&mouse_pressed)mp = 0;
      if(coordInBounds(xArr[1]-20,y2-20,w+40,h+40,mouseX,mouseY)&&mouse_pressed)mp = 1;
      if(coordInBounds(xArr[2]-20,y2-20,w+40,h+40,mouseX,mouseY)&&mouse_pressed)mp = 2;
      if(coordInBounds(xArr[3]-20,y2-20,w+40,h+40,mouseX,mouseY)&&mouse_pressed)mp = 3;
      pick_box_x = lerp(pick_box_x,xArr[mp]-10,0.3);
      uiBox(pick_box_x,y2-10,80,80,color(200,0),color(255));
    }
    r%=4;
    tile_type = tile_picker_arr[mp];
  }

  void edit(){
    noStroke();
    rectMode(CORNER);
    fill(140,140,100,100);
    posArray = bresenham(mouse_px, mouse_py, mouse_x, mouse_y);
    if(keyCode==SHIFT&&keyPressed) {posArray = fillArea(fill_x, fill_y, mouse_x, mouse_y);} else {fill_x = mouse_px;fill_y = mouse_py;}
    if(mouse_pressed){
      switch(mouseButton){
        case LEFT:
          for(int[] pos: posArray){
            add(new int[]{pos[X], pos[Y], current_layer}, new int[]{NO_BIND, tile_type});
          }
        break;
        case RIGHT:
          for(int[] pos: posArray) remove(new int[]{pos[X], pos[Y], current_layer}, false);
        break;
      }
    }
    translate(editor_ox,editor_oy);
    scale(ez_us);
    for(int[] pos: posArray){project.tiles.drawSingle(pos[0], pos[1], tile_type);} // Placement ghost
    resetMatrix();
  }

  int[] getTile(int x, int y, int z){
    int[] tile = data.get(intArrToList(new int[]{x, y, z}));
    if(tile == null){
      tile = new int[]{AIR, NO_BIND};
    }
    return tile;
  }

  void add(int[] p, int[] new_tile){
    List<Integer> pos = intArrToList(p);
    int type = new_tile[TILE_TYPE];
    if(type==AIR)new_tile[BIND_FLAG]=NO_BIND;
    int[] tile = data.get(pos);
    if(tile==null){tile=new int[]{AIR, NO_BIND};}
    if(tile[BIND_FLAG]==NO_BIND){
      data.remove(pos);
      if(type>7){
        if(!contains(tile,type)){
          tile = addToArray(tile,type);
        }
      }else{
        tile = new_tile;
      }
      data.put(pos, tile);
    }
  }

  void remove(int[] p){remove(p, false);}
  void remove(int[] p, boolean remove_binding){
    List<Integer> pos = intArrToList(p);
    int[] tile = data.get(pos);
    if(tile==null){return;}
    if(tile[BIND_FLAG]==NO_BIND ^ remove_binding){ // Has no bind flag XOR remove binded tiles
      data.remove(pos);
    }
  }

  void drawLayer(int layer, color c){
    noStroke();
    //shader(ps_test); // WIP
    for (List<Integer> pos: data.keySet()) {
      int[] tile = data.get(pos);
      if(pos.get(Z)==layer){
        fill(c);
        float x = pos.get(X);
        float y = pos.get(Y);
        rectMode(CORNER);
        drawSingle(x,y,tile[TILE_TYPE]);
        for(int i = 2; i < tile.length; i++){
          fill(c);
          drawSingle(x,y,tile[i]); // Secondary tiles, like pipes and other things.
        }
      }
    }
  }
  void drawSingle(float x, float y, int TYPE){drawSingle(x,y,TYPE,1);}
  void drawSingle(float x, float y, int TYPE, float s){
    translate(x,y);
    switch(TYPE) {
      case BLOCK_GRAPHIC:
        break;
      case AIR:
        break;
      case SOLID:
        square(0, 0, s);break;
      case SLOPE_1:
        triangle(0, 0, 0, s, s, s);break;
      case SLOPE_2:
        triangle(0, s, s, 0, s, s);break;
      case SLOPE_3:
        triangle(0, 0, s, 0, 0, s);break;
      case SLOPE_4:
        triangle(0, 0, s, 0, s, s);break;
      case PIPE_END:
        rectMode(CENTER); fill(0);
        quad(s/2, 0, s, s/2, s/2, s, 0, s/2);break;
      case PLATFORM:
        rect(0, 0, s, s/2);break;
      // Secondaries:
      case POLE_H:
        rect(0, s/3, s, s/3);break;
      case POLE_V:
        rect(s/3, 0, s/3, s);break;
      case GLASS:
        break;
      case PIPE_PIP:
        rectMode(CENTER); fill(0);
        quad(s/2, s/4, s*.75, s/2, s/2, s*.75, s/4, s/2);break;
      case ROOM_EXIT:
        rectMode(CENTER); fill(#ff00ff);
        quad(s/2, 0, s, s/2, s/2, s, 0, s/2);break;
      case LIZ_DEN:
        rectMode(CENTER); fill(#00ee00);
        quad(s/2, 0, s, s/2, s/2, s, 0, s/2);break;
      case LIZ_END:
        rectMode(CENTER); fill(#009900);
        quad(s/2, 0, s, s/2, s/2, s, 0, s/2);break;
      case SCAV_DEN:
        rectMode(CENTER); fill(#aa7777);
        quad(s/2, 0, s, s/2, s/2, s, 0, s/2);break;
      case DEAD_END:
        rectMode(CENTER); fill(#bbbbbb);
        quad(s/2, 0, s, s/2, s/2, s, 0, s/2);break;
      case WATERFALL:
        break;
      case GARBAGE_HOLE:
        break;
      case WORM_GRASS:
        break;
      case HIVE:
        break;
    }
    translate(-x,-y);
  }
}
