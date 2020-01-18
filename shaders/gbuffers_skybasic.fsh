#version 120

uniform mat4 gbufferModelViewInverse;
uniform vec3 sunPosition;
uniform float blindness;
uniform int isEyeInWater;

varying vec4 color;
varying vec3 position;

float star(vec3 p)
{
    vec3 f = floor(p+.5);
    float n = sin(f.x/.23+f.y/.26+f.z/.24)+cos(f.x/.33+f.y/.36+f.z/.34);
    return smoothstep(.01,.0,fract(n/.1857));
}

void main()
{
    vec4 col = color;

    //float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    //clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);

    vec3 p = normalize(position);
    vec3 u = abs(p); float m = max(u.x,max(u.y,u.z));
    vec3 d = p/m;

    vec3 sun = normalize((gbufferModelViewInverse * vec4(sunPosition,0)).xyz);
    vec3 ray = mat3(sun.x,sun.y,0,sun.y,-sun.x,0,0,0,1)*p;
    vec2 l = floor(abs(ray.yz/ray.x)*64.)/64.;
    float moon = step(ray.x,0.);
    float sq = smoothstep(.2,.1,max(l.x,l.y)+.05*moon);
    float stars = .5*star(d*128.)*max(-sun.y,0.);

    col.rgb = vec3(.2,.2+.1*sun.y,.5+.2*sun.y)-.3*d.y*d.y+stars;
    col.rgb += (vec3(2-1.4*moon,.8,.5+.6*moon)*2.-col.rgb)*sq;

    //col.rgb = mix(col.rgb, gl_Fog.color.rgb, fog);

    gl_FragData[0] = col * vec4(vec3(1.-blindness),1);
}
