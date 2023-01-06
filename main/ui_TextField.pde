class TextField{
  String prompt_text;
  String default_text;
  float x, y;
  String text = "";
  boolean focused = false;
  TextField(String _prompt, String _default, float _x, float _y){
    prompt_text = _prompt;
    default_text = _default;
    x = _x;
    y = _y;
  }

  void update(float ox, float oy, float alpha){
    float px = x+ox;
    float py = y+oy;
    rectMode(CORNER);
    uiBox(px-10, py-10, 180, 30, color(0,alpha), color(255,alpha));
    fill(alpha); textFont(font_small); textAlign(LEFT, TOP);
    text(prompt_text+((text!="")?text:default_text),px,py); // Display the text, use the default text if there is no user text in the feild.
  }

  String get(){
    return text;
  }
}