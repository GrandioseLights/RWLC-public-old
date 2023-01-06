Button button_openSketchFolder;
Button button_credits;
Button button_github;
Button button_extras_back;

void load_s_extras(){
  button_extras_back = new Button("Back", 100, height-30, 150, 36);
}

void screen_extras(){
  background(10);
  button_extras_back.update(0,0,255);
  if(clicked_button == button_extras_back)setScreen("title");
}