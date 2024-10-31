precision mediump float;

uniform vec3 uDepthColor;
uniform vec3 uSurfaceColor;

varying vec2 vUv;
varying float vElevation;

void main(){
  vec3 color = mix(uDepthColor, uSurfaceColor, vElevation + 0.02 * 10.0);
  gl_FragColor = vec4(color ,1.0);
}