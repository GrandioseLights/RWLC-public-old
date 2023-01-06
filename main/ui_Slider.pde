class Slider{
  Button button_slider;
  int x, y, length;
  float min, max;
  float value; // Visual value of the slider across the bar, not mapped to the min/max values of the bar.
  Slider(int _x, int _y, int _length, float _min, float _max){
    x = _x;
    y = _y;
    length = _length;
    min = _min;
    max = _max;
    value = _x;
    button_slider = new Button("", x, y, 20, 30);
  }

  float update(float ox, float oy, float alpha){
    float px = x+ox-10;
    float py = y+oy;
    stroke(button_slider.outer);strokeWeight(2);
    line(px,py-2,px,py+2);
    line(px,py,px+length+20,py);
    line(px+length+20,py-2,px+length+20,py+2);
    button_slider.update(ox+value-x, oy, alpha);
    if(button_slider.pressed){
      editing_allowed = false;
      if(mouse_released)button_slider.pressed = false;else{
        value = mouseX;
        if(value<x)value=x;
        if(value>x+length)value=x+length;
      }
    }
    return map(value, x, x+length, min, max);
  }
}