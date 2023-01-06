File[] default_Graphics;
File[] default_Effects;
int graphics_inc;

Table graphic_table = new Table();
String[] graphic_table_sort_types = new String[]{"id","Category","Colour","Name","Width","Height","Padding","Variants","Pack"};

void load_s_startUp(){
  default_Graphics = new File(dataPath("Assets/Default Components/Graphics")).listFiles(); // All the built in graphic tile files.
  graphics_inc = 15; //default_Graphics.length-1;
  for(String st: graphic_table_sort_types){
    graphic_table.addColumn(st);
  }
}

// Actions needing to happen before other screens appear will happen here. (Long loading tasks that only need to happen once).
void screen_startUp(){
  background(255);
  fill(0);
  textFont(font_small);
  textAlign(CENTER);

  if(graphics_inc > 0){
    text("Loading Graphics...", width/2, 300);
    text(new GraphicTile(default_Graphics[graphics_inc]).name, width/2, 340);
    graphics_inc-=1;
    return;
  }
  log("Startup finished.");
  saveTable(graphic_table, "data/graphic_table.csv");
  setScreen("title");
}