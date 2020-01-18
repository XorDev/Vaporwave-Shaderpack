#version 120

uniform sampler2D texture;

uniform float blindness;
uniform int isEyeInWater;

varying vec4 color;
varying vec3 position;
varying vec2 coord0;

void main()
{
    vec3 light = vec3(1.-blindness);
    vec4 col = color * vec4(light,1);

    vec2 d = smoothstep(.3,.6,floor(abs(coord0*2.-1.)*16.)/16.);
    float a = 1.-max(d.x,d.y);
    float r = position.y;
    float s = (coord0.y-.5)*position.x+.5;
    col *= vec4(1,s,.2,a*(smoothstep(.0,.1,cos(r*128.)+sqrt( r*4.))));

    gl_FragData[0] = vec4(0);
}
