Button clicked_button; // This is the button that was last clicked.
final float inc_DTheta = 0.87/PI; // Used for calculations done when updating buttons.

class Button{
  String text = "";
  float x, y, w, h;
  int idle_value = 170; // Default gray value of the button. 170.

  private float dt = 0;     // Delta theta.
  private float dg = 0;     // Delta glint.
  private float glint = 0;  // The glint of the button, only non-zero when the button if first hovered over.
  private float a0 = 0;     // Inner rectangle stroke variable.
  private float a1 = 0;     // Outer rectangle stroke and size variable.
  color fill, outer, inner;

  boolean pressed = false; // Useful for draggable buttons.

  Button(String _text, float _x, float _y, float _w, float _h){
    text=_text;
    x=_x;y=_y;w=_w;h=_h;
  }
  void update(){update(0,0,1);}
  void update(float ox, float oy, float alpha){
    rectMode(CENTER);
    if(alpha>0.05){
      if(coordInBounds(x+ox-w/2, y+oy-h/2, w, h, mouseX, mouseY)){
        editing_allowed = false;
        glint=-pow(dg,2)+idle_value;
        if(dg<20)dg+=5;
        dt+=inc_DTheta;
        a1=lerp(a1, 255, 0.5);
        if(mousePressed){
          a0 = lerp(a0, 1, 0.1);    // Make the oscillating value equal to 1.
          a1 = lerp(a1, 0, 0.3);    // Shrink outer rectangle when button is pressed
          pressed = true;
        }else{a0=(1+cos(dt))*255;pressed=false;}  // Oscillate colour when the mouse is not pressed.
        if(mouse_clicked){clicked_button=this;} // Condition when the button is pressed.
      }else{
        glint=lerp(glint, 0, 0.9);    // Lerp the main glint value back to 0.
        dt=0;                         // Reset delta theta.
        dg=0;                         // Reset delta glint.
        a0=lerp(a0, idle_value, 0.2); // Lerp inner stroke variable to idle colour.
        a1=lerp(a1, 0, 0.3);          // Lerp outer stroke and rect size varable to zero.
      }
      float px = x+ox;
      float py = y+oy;
      float oc = idle_value+a1; // outer color

      fill = color(glint, 255*alpha);
      outer = color(oc, 255*alpha);
      inner = color(a0, a0*alpha);
      

      // Draw rectangles
      uiBox(px, py, w+a1/25, h+a1/25, fill, outer);
      uiBox(px, py, w, h, fill, inner);

      fill(outer); // Draw text
      stroke(fill);textFont(font_small);
      textAlign(CENTER, CENTER);
      text(text, px, py);
    }
  }
}
