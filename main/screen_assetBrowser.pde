Button button_browser_back;

void load_s_assetBrowser(){
  button_browser_back = new Button("Back", 100, height-30, 150, 36);
}

void screen_assetBrowser(){
  background(10);
  button_browser_back.update(0,0,255);
  if(clicked_button == button_browser_back)setScreen("title"); 
}