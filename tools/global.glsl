// https://www.opengl.org/sdk/docs/reference_card/opengl45-reference-card.pdf
// https://github.com/processing/processing/blob/master/core/src/processing/opengl/PShader.java#L1146
// https://github.com/codeanticode/pshader-tutorials/blob/master/intro/Ex_09_1_allshaders/data/lachoy.jpg

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform vec3 c_sun   = vec3(0,0,1); // Blue
uniform vec3 c_front = vec3(0,1,0); // Green
uniform vec3 c_dark  = vec3(1,0,0); // Red

uniform vec3 c_deco1  = vec3(0,1,1); // Cyan
uniform vec3 c_deco2  = vec3(1,0,1); // Magenta
uniform vec3 c_mirror = vec3(1,1,0); // Yellow

uniform int seed1;
varying float seed2 = 342.15215;

float map(float v, float i1, float i2, float o1, float o2) {return (v-i1)*(o2-o1)/(i2-min1)+o1;}
float random(){return random(0,1);}
float random(max){return random(0,max);}
float random(float min, float max){
  seed2=(seed2*seed2%493021.235)/493021.235;
  return map(fract(sin(dot(vec2(seed1,seed2),vec2(29.4586,46.2635)))*45154.4352),0,1,min,max);
}

void main(){
  vec4 pixel = vertTexCoord;
  vec3 colour = vertColor.rgb;

  gl_FragColor = vec4(colour,1);
}