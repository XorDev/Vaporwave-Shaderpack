#version 120

#define Ambience .3 //Ambient lighting brightness [.0 .1 .2 .3 .4 .5]
#define Brightness 1. //Overall brightness [.6 .8 1. 1.2]

uniform sampler2D texture;
uniform sampler2D lightmap;

uniform vec4 entityColor;
uniform float blindness;
uniform int isEyeInWater;

varying vec4 color;
varying vec2 coord0;
varying vec2 coord1;
varying vec3 vert;
varying vec3 norm;

void main()
{
    vec3 light = (1.-blindness) * texture2D(lightmap,coord1).rgb;
    vec4 tex = texture2D(texture,coord0);
    vec4 col = color * tex;
    // * vec4(light,1);
    col.rgb = mix(col.rgb,entityColor.rgb,entityColor.a);

    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);

    float fade = exp(-gl_FogFragCoord/100.);
    vec3 vapor = mix(exp(light-8.*abs(fract(vert+.5)*2.-1.)*fade*fade),light,Ambience)*Brightness;
    vapor = col.rgb/sqrt(dot(col,vec4(.288,.587,.114,0)))
    *dot(vapor,1.-(norm*norm));
    col.rgb = vapor*fade*fade*fade;

    col.rgb = mix(col.rgb, vec3(.2,.1,.3), fog);

    gl_FragData[0] = col;
}
