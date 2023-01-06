Slider slider_haptics;
Slider slider_sounds;
Slider slider_music;
Button button_options_back;

void load_s_options(){
  slider_haptics = new Slider(100,400,400,0,100);
  slider_sounds = new Slider(100,470,400,0,100);
  slider_music = new Slider(100,540,400,0,100);
  button_options_back = new Button("Back", 100, height-30, 150, 36);
}

void screen_options(){
  background(10);
  slider_haptics.update(0,0,255);
  slider_sounds.update(0,0,255);
  slider_music.update(0,0,255);
  button_options_back.update(0,0,255);

  if(clicked_button == button_options_back)setScreen("title");
}
