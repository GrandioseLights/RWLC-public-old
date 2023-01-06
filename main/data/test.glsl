#ifdef GL_ES
precision mediump float;
#endif
#define PROCESSING_SHADER

#define PI 3.14159265358979323846

uniform sampler2D texture;
uniform vec2 resolution;
varying vec4 vertColor;
varying vec4 vertTexCoord;
uniform vec2 texOffset;

uniform float u_time;
uniform int seed;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Retreived from: https://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl/17479300#17479300
// Modified
uint hash(uint x){
  x+=(x<<10u);
  x^=(x>> 6u);
  x+=(x<< 3u);
  x^=(x>>11u);
  x+=(x<<15u);
  return x+seed;
}
uint hash(uvec2 v){return hash(v.x^hash(v.y));}
uint hash(uvec3 v){return hash(v.x^hash(v.y)^hash(v.z));}
uint hash(uvec4 v){return hash(v.x^hash(v.y)^hash(v.z)^hash(v.w));}
float floatConstruct(uint m){
  const uint ieeeMantissa = 0x007FFFFFu;
  const uint ieeeOne      = 0x3F800000u;  
  m &= ieeeMantissa;
  m |= ieeeOne;
  float  f = uintBitsToFloat(m);       
  return f - 1.0;                        
}
float random(float x){return floatConstruct(hash(floatBitsToUint(x)));}
float random(vec2 v){return floatConstruct(hash(floatBitsToUint(v)));}
float random(vec3 v){return floatConstruct(hash(floatBitsToUint(v)));}
float random(vec4 v){return floatConstruct(hash(floatBitsToUint(v)));}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Retreived from: https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
// Additional credits: https://github.com/ashima/webgl-noise
// Modified
float noise(vec2 p, float freq){
	vec2 ij = floor(p/freq);
	vec2 xy = mod(p,freq)/freq;
	xy = 3.*xy*xy-2.*xy*xy*xy;
	xy = .5*(1.-cos(PI*xy));
	float a = random((ij+vec2(0.,0.)));
	float b = random((ij+vec2(1.,0.)));
	float c = random((ij+vec2(0.,1.)));
	float d = random((ij+vec2(1.,1.)));
	float x1 = mix(a, b, xy.x);
	float x2 = mix(c, d, xy.x);
	return mix(x1, x2, xy.y);
}
float pNoise(vec2 p, int res){
	float persistance = .5;
	float n = 0.;//0
	float normK = 0.;
	float f = 4.;
	float amp = 1.;
	int iCount = 0;
	for (int i = 0; i<50; i++){
		n+=amp*noise(p, f);
		f*=2.;
		normK+=amp;
		amp*=persistance;
		if (iCount == res) break;
		iCount++;
	}
	float nf = n/normK;
	return nf*nf*nf*nf;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
float zNoise3D(vec3 p, float freq){
  freq=1/freq;
	vec3 fv = floor(p/freq);
	vec3 xyz = mod(p,freq)/freq;
  xyz-=xyz*xyz*xyz*xyz;
	float a = random((fv+vec3(0.,0.,0.)));
	float b = random((fv+vec3(1.,0.,0.)));
	float c = random((fv+vec3(0.,1.,0.)));
	float d = random((fv+vec3(1.,1.,0.)));
  float e = random((fv+vec3(0.,0.,1.)));
	float f = random((fv+vec3(1.,0.,1.)));
	float g = random((fv+vec3(0.,1.,1.)));
	float h = random((fv+vec3(1.,1.,1.)));
	float x1 = mix(a, b, xyz.x);
	float x2 = mix(c, d, xyz.x);
  float x3 = mix(e, f, xyz.x);
	float x4 = mix(g, h, xyz.x);
  float y1 = mix(x1, x2, xyz.y);
  float y2 = mix(x2, x3, xyz.y);
  return mix(y1, y2, xyz.z);
}

void main(){
	float time = u_time;
  vec2 pos = (gl_FragCoord.xy/resolution.xy);
  vec4 colour = texture2D(texture, pos);
  float tx = texOffset.x;
  float ty = texOffset.y;
  vec4 c = vec4(0,0,0,1); // final colour
  if(colour == vec4(0,0,0,1)){
    c.r = random(vec3(pos.x, pos.y, 1));
  }else{
    c = vec4(1,1,1,1);
  }

  gl_FragColor = c;
}