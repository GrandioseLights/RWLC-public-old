// main.pde
// This file holds all the essential functions used behind the scenes.

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors; // Converting String to List<Integer>.
import java.util.Base64;            // Image decoding.
import java.util.stream.Stream;
import java.io.ByteArrayInputStream;
import javax.imageio.ImageIO;

boolean mouse_released;
boolean mouse_clicked;
boolean mouse_pressed;
boolean mouse_moved;
boolean mouse_dragged;
MouseEvent mouse_wheel;
boolean mouse_exited;
boolean mouse_entered;

boolean key_pressed;
boolean key_released;

String screen = "startup";

PFont font_large;
PFont font_small;
PFont font_text;

PShader ps_test;
//Map<String,Object> creator_data = new ObjectMapper().readValue(loadJSONObject("creator_data.json"), HashMap.class);

// main functions //
void setup() {
  background(255);size(1400, 800, P2D);//noStroke();noSmooth();
  hint(ENABLE_KEY_REPEAT);

  ps_test = loadShader("test.glsl");
  ps_test.set("seed", 3425);

  font_large = createFont("Assets/Rodondo.ttf", 120);
  font_small = createFont("Assets/Rodondo.ttf", 18);
  font_text = createFont("Assets/CaviarDreams_Bold.ttf", 18);
  load_s_assetBrowser();
  load_s_extras();
  load_s_options();
  load_s_title();
  load_s_startUp();
  load_s_levelEditor();
}

void draw() {
  ps_test.set("u_time", millis()/1000.0); // WIP
  
  rectMode(CORNER);
  switch(screen){ // Update and swap screens
    case "startup":
    screen_startUp();
    break;
    case "title":
    screen_title();
    break;
    case "editor":
    screen_levelEditor();
    break;
    case "browser":
    screen_assetBrowser();
    break;
    case "options":
    screen_options();
    break;
    case "extras":
    screen_extras();
    break;
  }

  // Debug stuff
  mouse_released = false;
  mouse_clicked = false;
  mouse_pressed = false;
  mouse_moved = false;
  mouse_dragged = false;
  mouse_wheel = null;
  mouse_exited = false;
  mouse_entered = false;
  
  key_pressed = false;
  key_released = false;

  // Clear other variabls
  clicked_button = null;
}

// Mouse events //

void mouseReleased(MouseEvent e) {mouse_released = true;}
void mouseClicked(MouseEvent e) {mouse_clicked = true;}
void mousePressed(MouseEvent e) {mouse_pressed = true;}
void mouseMoved(MouseEvent e) {mouse_moved = true;}
void mouseDragged(MouseEvent e) {mouse_dragged = true; mouse_pressed = true;}
void mouseWheel(MouseEvent  e) {mouse_wheel = e;}
void mouseExited(MouseEvent e) {mouse_exited = true;}
void mouseEntered(MouseEvent e) {mouse_entered = true;}
// Key events //

void keyPressed(KeyEvent e) {key_pressed = true; if(key == ESC)key = 0;}
void keyReleased(KeyEvent e) {key_released = true;}
