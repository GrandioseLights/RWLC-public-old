// The Project class holds all the important editor data and settings, everythng here gets saved to the save file.

float render_buffer_x = 0; //(graphic_tile.Width+graphic_tile.padding*2)*WORLD_UNIT;
float render_buffer_y = 0;

class Project{
  File file;
  ArrayList<EditorComponent> ec_list = new ArrayList<EditorComponent>(); // All the Components. Used by the Editor.

  Tiles tiles; // Geometry and materials
  Graphics graphics;
  // Pipes pipes;
  Props props;
  // Effects effects;
  Cameras cameras;
  // Lighting lighting;
  
  Project(String path, String name){this(path+name, true);}
  Project(String path_name, boolean is_new){ // If we are loading a file, the path should have ".lcrp" at the end.
    if(is_new){
      file = new File(path_name+".lcrp");
      int i = 0;  // Make sure a new file is created instead of overwriting an old one.
      while(file.exists()&&file.length()!=0){file=new File(sketchPath(path_name+"_"+i+".lcrp"));i++;};
      createWriter(file.getAbsolutePath());
    }else{file = new File(path_name);}

    tiles = new Tiles();
    graphics = new Graphics();
    //pipes =  new Pipes();
    props = new Props();
    //effects = new Effects();
    cameras = new Cameras();
    //lighting = new Lighting();

    ec_list.add(tiles);
    ec_list.add(graphics);
    //ec_list.add(pipes);
    ec_list.add(props);
    //ec_list.add(effects);
    ec_list.add(cameras);
    //ec_list.add(lighting);
    
    cameras.setData("0,0:0,0","Cameras"); // Projects must have at least one camera, set first camera down just in case there isn't one loaded from file.

    String[] lines = loadStrings(file.getAbsolutePath());
    try{
      tiles.setData(lines[0],"Tiles");
      graphics.setData(lines[1],"Graphics");
      //pipes.setData(lines[2],"Pipes");
      props.setData(lines[3],"Props");
      //effects.setData(lines[4],"Effects");
      cameras.setData(lines[5],"Cameras");
      //lighting.setData(lines[6],"Lighting");
    }catch(ArrayIndexOutOfBoundsException e){
      log("Warn","Some components could not be loaded: "+e.toString());
    }
  }
  void saveProject(){
    int start_time = millis();
    saveStrings(file.getAbsolutePath(),
      new String[]{
        tiles.getData(),
        graphics.getData(),
        "",//pipes.getData(),
        props.getData(),
        "",//effects.getData(),
        cameras.getData(),
        ""//lighting.getData()
      }
    );
    log("debug","Saved: " + (millis()-start_time) + " ms.");
  }

  void saveOutput(){
    int[] mm = cameras.getMinMax();
    int area = (abs(mm[0])-mm[2])*(abs(mm[1])-mm[3]);
    String camera_positions = "";
    boolean cams = false;
    for (List<Integer> pos: cameras.data.keySet()) { // One camera will be at 0,0
      if(cams)camera_positions+="|"; // Add a line between the camera cordinates if more than one exists.
      camera_positions+=(pos.get(X))*20+","+(pos.get(Y))*20;
      cams = true;
    }
    String border_type = "Border: "+"Passable";
    String[] lines = {
      file.getName(),         // Room name
      area+"|0|0",            // Room area|Water level|Water infront of terrain
      "0.0000*1.0000|0|0",    // Light angle1*Light angle2|0|0
      camera_positions,       // x,y|...
      border_type,            // Border: Passable/Solid
      "",                     // (ROCK/SPEAR),x,y|...
      "",                     // (Unused)
      "",                     // (Unused)
      "",                     // (Unused)
      "0",                    // (Unused) Room nodes
      "",                     // (Unused) AI map
      getGeoString()          // Tile data
    };
    saveStrings("tests/test_output.txt", lines);
  }

  void render(){
    int start_time = millis();
    ArrayList<PImage>
    layer_images = new ArrayList<PImage>();
    for(int l=0; l<30; l++){            // Loop through all render layers (29+1).
      PGraphics                         // Gather all the renderable components on a layer into one image.
      collector = createGraphics(1400, 800);
      collector.beginDraw();
      collector.image(graphics.renderLayer(l),0,0);
      collector.endDraw();
      PImage                            // Convert pure RGB into red render colours, otherwise keep the original colours.
      render_colour = replaceColour(collector.get(),#0000ff, color(151+l, 0, 0));
      render_colour = replaceColour(render_colour,  #00ff00, color(121+l, 0, 0));
      render_colour = replaceColour(render_colour,  #ff0000, color(91+l, 0, 0));
      layer_images.add(render_colour);  // Add this render coloured layer to the array.
    }
    log("debug","Rendered: " + (millis()-start_time) + " ms.");

    // Debugging stuff:
    int a=0;
    PGraphics
    debug_stacker = createGraphics(1400, 800);
    debug_stacker.beginDraw();
    for(PImage img: layer_images){
      debug_stacker.image(layer_images.get(29-a),0,0);
      a++;
    }
    debug_stacker.endDraw();
    debug_stacker.save("tests/test_render.png");
  }

  String getGeoString(){
    String str = "";
    int[] mm = cameras.getMinMax();
    for(int y=mm[1]; y < mm[3]; y++){
      for(int x=mm[0]; x < mm[2]; x++){
        int[] tile = tiles.getTile(x, y, 1);
        switch(tile[TILE_TYPE]){
          case SOLID: str+="1"; break;
          case SLOPE_1:
          case SLOPE_2:
          case SLOPE_3:
          case SLOPE_4: str+="2"; break;
          case PLATFORM: str+="3"; break;
          case PIPE_END: str+="4,3"; break;
          default: str+="0"; break; // AIR
        }
        for(int i = 2; i<tile.length; i++) {
          switch(tile[i]){
            case POLE_V:str+=",1"; break;
            case POLE_H:str+=",2"; break;
            case PIPE_PIP:str+=",3"; break;
            case ROOM_EXIT:str+=",4"; break;
            case LIZ_DEN:str+=",5"; break;

            case HIVE:str+=",7"; break;
            case WATERFALL:str+=",8"; break;
            case LIZ_END:str+=",9"; break;
            case GARBAGE_HOLE:str+=",10"; break;
            case WORM_GRASS:str+=",11"; break;
            case SCAV_DEN:str+=",12"; break;
          }
        }
        if(tile[TILE_TYPE]!=SOLID && tiles.getTile(x, y, 2)[TILE_TYPE]==SOLID){
          str+=",6";
        }
        str+="|";
      }
    }
    return str;
  }
}
/*
repeat with q = 1 + gLOprops.extratiles[1] to gLOprops.size.loch - gLOprops.extratiles[3] then
  repeat with c = 1 + gLOprops.extratiles[2] to gLOprops.size.locv - gLOprops.extratiles[4] then    
    case mtrx[q][c][1][1] of
      1: --wall
        txt = txt & "1"
      2, 3, 4, 5:--slopes
        txt = txt & "2"
      6: --floor
        txt = txt & "3"
      7: --shortcut entrance
        txt = txt & "4,3"
      otherwise: --air
        txt = txt & "0"
    end case
    
    repeat with e = 1 to mtrx[q][c][1][2].count then
      case mtrx[q][c][1][2][e] of
        2: --vertical beam
          if(mtrx[q][c][1][1] <> 1)then
            txt = txt & ",1"
          end if
        1: -- horizontal beam
          if(mtrx[q][c][1][1] <> 1)then
            txt = txt & ",2"
          end if
        5: --shortcut
          txt = txt & ",3"
        6: --room exit
          txt = txt & ",4"
        7: --hiding hole
          txt = txt & ",5"
        19: -- WHAM
          txt = txt & ",9"
        21: -- scavenger hole
          txt = txt & ",12"
        3: -- hive!
          if(afaMvLvlEdit(point(q,c), 1) = 0)and(afaMvLvlEdit(point(q,c+1), 1) = 1)then
            txt = txt & ",7"
          end if
        18: -- waterfall!
          txt = txt & ",8"
        13: --garbage hole
          txt = txt & ",10"
        20: --worm grass
          txt = txt & ",11"
          
      end case
    end repeat
    
    if(mtrx[q][c][1][1] <> 1) and (mtrx[q][c][2][1] = 1)then -- wall behind
      txt = txt & ",6"
    end if
    
    txt = txt & "|"
  end repeat
end repeat

on afaMvLvlEdit(pos, layer)
  global gLEProps, gLOprops
  if pos.inside(rect(1,1,gLOprops.size.loch+1,gLOprops.size.locv+1)) then
    return gLEProps.matrix[pos.locH][pos.locV][layer][1]
  else
    return 1
  end if
end

gLEProps = [#matrix:[] , #levelEditors:[] , #toolMatrix:[], #camPos:point(0,0)]
gLOprops = [#mouse:0, 
  #lastMouse:0, 
  #mouseClick:0, 
  #pal:1, pals:[[#detCol:color(255, 0, 0)]], 
  #eCol1:1, 
  #eCol2:2, 
  #totEcols:5, 
  #tileSeed:random(400), 
  #colGlows:[0,0], 
  #size:point(cols, rows), 
  #extraTiles:[12,3,12,5],
  #light:1
]
*/
//
