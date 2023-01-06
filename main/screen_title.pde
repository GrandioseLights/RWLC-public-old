Button button_title_newProject;
Button button_title_loadProject;
Button button_title_assetBrowser;
Button button_title_options;
Button button_title_extras;

Drop[] drops = new Drop[250];

Project project;

void load_s_title(){
  button_title_newProject =   new Button("New Project",   width/2, 340, 150, 36);
  button_title_loadProject =  new Button("Load Project",  width/2, 390, 150, 36);
  button_title_assetBrowser = new Button("Asset Browser", width/2, 440, 150, 36);
  button_title_options =      new Button("Options",       width/2, 490, 150, 36);
  button_title_extras =       new Button("Extras",        width/2, 540, 150, 36);
  for(int i=0; i<drops.length; i++) drops[i] = new Drop();
}

void screen_title(){
  background(10);
  fill(70, 155);
  for(int i=0; i<drops.length; i++) {drops[i].show();drops[i].fall();}
  if(drop_alpha<255) drop_alpha+=1;
  
  fill(255);
  textAlign(CENTER, TOP);
  textFont(font_large);
  text("L e v e l", width/2, 60);
  text("c r e a t o r", width/2, 180);

  button_title_newProject.update();
  button_title_loadProject.update();
  button_title_assetBrowser.update();
  button_title_options.update();
  button_title_extras.update();

  // Button actions
  if(clicked_button == button_title_newProject){
    String save_path = sketchPath("data"+File.separator+"Level Creator Projects"+File.separator); 
    project = new Project(save_path, "unnnamed_room"); // Create a new project
    log("debug","New project @ "+project.file);
    now_editing = -1; // initialize editor values
    setScreen("editor");
  }
  if(clicked_button == button_title_loadProject){ // Load project that the user selects from a window.
    selectInput("Open Level Creator Project file", "setProjectFile", dataFile("Level Creator Projects/ ")); 
    now_editing = -1; // initialize editor values
  }
  if(clicked_button == button_title_assetBrowser) setScreen("browser");
  if(clicked_button == button_title_options)      setScreen("options");
  if(clicked_button == button_title_extras)       setScreen("extras");
}

void setProjectFile(File selected) {
  if(selected==null)log("No file selected");else{
    project = new Project(selected.getAbsolutePath(), false);
    setScreen("editor");
  }
}