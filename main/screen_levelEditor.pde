public static final int TILES = 0; // Project components
public static final int GRAPHICS = 1;
public static final int PIPES = 2;
public static final int PROPS = 3;
public static final int EFFECTS = 4;
public static final int CAMERAS = 5;
public static final int LIGHTING = 6;

static final int UNIT_SIZE = 20;  // Pixel size of grid, 20.
float editor_ox, editor_oy;       // editor pan values.
float editor_zoom = 1;            // Zoom value of the editor, Small number = Zoomed out.
float ez_us;                      // editor_zoom * UNIT_SIZE, the display ratio, visuals in the editor affected by zoom are multiplied by this value.

float fmouse_x, fmouse_y;   // Float point position of the mouse relative to the room.
int mouse_x, mouse_y;       // Rounded position of the mouse for room object snapping.
float fmouse_px, fmouse_py; // Previous mouse position of above.
int mouse_px, mouse_py;     // Rounded previous mouse position relative to the room.
int fill_x = 0;             // Coords of the first corner when filling an area, equal to the last value of mouse_px and y before the Shift key is pressed.
int fill_y = 0;

int now_editing = 2; // The project component being edited. (-1)

boolean editing_allowed = false; // Will be false if the mouse is over a menu or button and such. False on start.
boolean editor_focused = false; // Will be false if the editor is paused or anything similar. Used in the widget menu.
boolean editor_canZoom = false; // Lets the scroll wheel control the zooom level.

boolean show_tools = false; // Controlled by pressing TAB by default. False when an escape menu is shown.

int tile_type = 1;  // Types of project component currently being used.
int material_type = 0;
int graphic_type = 0;
int effect_type = 0;

int current_layer = 1;  // The layer currenly being edited.
ArrayList<int[]> posArray = new ArrayList<int[]>(); // List of positions in the level that are going to be modified.

EscapeTray escape_tray;
Button button_exit;
Button button_save;
Button button_render;

color colour_l1;
color colour_l2;
color colour_l3;
float layer_HUD_boing = 255;

int[] draw_order = {2, 3}; // Draw order of the screen, changes depending on what is being edite.

ArrayList<Button> graphic_editor_buttons =  new ArrayList<Button>();

void load_s_levelEditor(){
  escape_tray = new EscapeTray();
  button_exit = new Button("Exit", 70, height-30, 100, 36);
  button_save = new Button("Save", width-190, height-30, 100, 36);
  button_render = new Button("Render", width-70, height-30, 100, 36);

  colour_l1 = color(90);
  colour_l2 = color(120);
  colour_l3 = color(150);

  int y = 40;
  int x = 0;
  for(String st: graphic_table_sort_types){
    graphic_editor_buttons.add(new Button(st,x,y,90,36));
    x+=95;
  }
}

void screen_levelEditor(){
  backgroundGradient(color(0xcf,0xf0,0xfc),color(0xff,0xc2,0xc2));
  // Zoom controls
  if (mouse_wheel!=null&&editor_canZoom&&key!=SHIFT){
    float delta=mouse_wheel.getCount()<0?1.1:mouse_wheel.getCount()>0?1.0/1.1:1.0;
    if(editor_zoom*delta>0.2&&editor_zoom*delta<3){
      editor_ox-=mouseX;editor_oy-=mouseY;
      editor_zoom*=delta;
      editor_ox*=delta;editor_oy*=delta;
      editor_ox+=mouseX;editor_oy+=mouseY;
    }
  }

  editor_canZoom = true; // Defualts to true.

  // Calculate the display ratio.
  ez_us = editor_zoom*UNIT_SIZE;
  // Calculate mouse position relative to the room using the display ratio.
  fmouse_x = (mouseX-editor_ox)/ez_us;     // Current relative positions.
  fmouse_y = (mouseY-editor_oy)/ez_us;
  mouse_x = floor(fmouse_x);       
  mouse_y = floor(fmouse_y);
  fmouse_px = (pmouseX-editor_ox)/ez_us;   // Last relative positions.
  fmouse_py = (pmouseY-editor_oy)/ez_us;
  mouse_px = floor(fmouse_px); 
  mouse_py = floor(fmouse_py);
  
  // Input Actions.
  if(key_pressed) {
    switch(key){
      case TAB: show_tools=!show_tools; break;
      case 'z': now_editing = TILES; break; // Number keys switch what component is being edited.
      case 'x': now_editing = GRAPHICS; break;
      case 'b': now_editing = PIPES; break;
      case 'p': now_editing = PROPS; break;
      case 'v': now_editing = EFFECTS; break;
      case 'c': now_editing = CAMERAS; break;
      case ',': now_editing = LIGHTING; break;
      case 'l': current_layer = current_layer%3+1; layer_HUD_boing = 255; break; // Switch layer.
      default: switch(keyCode){
        case 27: escape_tray.toggle(); break; // ESC
      }
    }
  }
  if(now_editing>7)now_editing=-1;

  // Draw HUD (Layer indecator)
  drawGUI();
  rectMode(CORNER);

  // Project editing stuff.
  if(editing_allowed){
    if(mousePressed && mouseButton==CENTER){
      if (mouseX!=pmouseX) editor_ox+=mouseX-pmouseX;
      if (mouseY!=pmouseY) editor_oy+=mouseY-pmouseY;
    }
  }

  switch(now_editing){
    case TILES: project.tiles.onEdit(); draw_order = new int[]{3, 1, 0}; break;
    case GRAPHICS: project.graphics.onEdit(); draw_order = new int[]{3, 0, 1}; break;
    //case PIPES: project.pipes.onEdit(); break;
    case PROPS: project.props.onEdit(); break;
    //case EFFECTS: project.effects.onEdit(); break;
    case CAMERAS: project.cameras.onEdit(); break;
    //case LIGHTING:  project.lighting.onEdit(); break;
  }
    
  // Display components of the project.
  drawWorld(draw_order);

  // Draw UI elements
  rectMode(CORNER);
  if(!focused){escape_tray.active = true;}
  editing_allowed=true;
  for(EditorComponent ec: project.ec_list) ec.showUI();
  editor_focused=true;
  fill(255);
  escape_tray.update();
  float d = escape_tray.d;
  if(d!=0){
    button_exit.update(0, 0, d/100);
    button_save.update(0, 0, d/100);
    button_render.update(0, 0, d/100);
  }
  
  // Button actions
  if(clicked_button == button_exit){
    setScreen("title");
    escape_tray.d = 0;
    escape_tray.active = false;
  }
  if(clicked_button == button_save){
    project.saveProject();
  }
  if(clicked_button == button_render){
    project.saveOutput();
    project.render();
  }
  // Make sure the level isn't edited by the click from the main menu screen.
  if(now_editing==-1&&mouse_moved) {now_editing = TILES;}

  // Debug tools.
  /*
  textAlign(LEFT);
  textFont(font_small);
  rectMode(CORNER);
  fill(0);
  noStroke();
  text("x:"+(mouse_x)+
    "\ny: "+(mouse_y)+
    "\nec: "+(new String[]{"TILES", "MATERIALS", "GRAPHICS", "PIPES", "PROPS", "EFFECTS", "CAMERAS", "LIGHTING"}[now_editing])
    , 10, 40);
  */
}

void drawWorld(int[] o){
  switch(current_layer){
    case 1:
      colour_l1 = lerpColor(colour_l1, color(50), 0.4);
      colour_l2 = lerpColor(colour_l2, color(120), 0.6);
      colour_l3 = lerpColor(colour_l3, color(150), 0.6);
    break;
    case 2:
      colour_l1 = lerpColor(colour_l1, color(90,85), 0.6);
      colour_l2 = lerpColor(colour_l2, color(50), 0.4);
      colour_l3 = lerpColor(colour_l3, color(150), 0.6);
    break;
    case 3:
      colour_l1 = lerpColor(colour_l1, color(90,85), 0.6);
      colour_l2 = lerpColor(colour_l2, color(120,85), 0.6);
      colour_l3 = lerpColor(colour_l3, color(50), 0.4);
    break;
  }

  strokeWeight(1);
  stroke(25);
  line(editor_ox, 0, editor_ox, height);
  line(0, editor_oy, width, editor_oy);
  noStroke();
  translate(editor_ox,editor_oy);
  scale(ez_us);
  
  shader(ps_test); // FLAG
  for (int ec_id: o){
    EditorComponent ec = project.ec_list.get(ec_id);
    ec.drawLayer(3, colour_l3);
    ec.drawLayer(2, colour_l2);
    ec.drawLayer(1, colour_l1);
  }
  resetShader(); // FLAG
  resetMatrix();
}

void drawGUI(){
  int x = 40;
  int y = 40;

  if(coordInBounds(40, height-120, 90, 90, mouseX, mouseY)){
    editing_allowed = false;
    if(layer_HUD_boing<150) layer_HUD_boing = 150;
    if(mouse_clicked){
      if(mouseButton == LEFT){
        current_layer = current_layer%3+1;
      }else if(mouseButton == RIGHT){
        current_layer = (current_layer+1)%3+1;
      }
      layer_HUD_boing = 255;
    }
  }
  rectMode(CENTER);
  noStroke(); 
  fill(colour_l3,layer_HUD_boing);
  rect(60,height-80,50,50);
  fill(colour_l2,layer_HUD_boing);
  rect(70,height-70,50,50);
  fill(colour_l1,layer_HUD_boing);
  rect(80,height-60,50,50);
  textAlign(CENTER,CENTER);
  textFont(font_text);
  fill(255,layer_HUD_boing);
  text(current_layer, 70, height-70);
  layer_HUD_boing = lerp(layer_HUD_boing, 50, 0.02);
}
