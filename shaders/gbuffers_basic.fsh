/*
    XorDev's "Default Shaderpack"

    This was put together by @XorDev to make it easier for anyone to make their own shaderpacks in Minecraft (Optifine).
    You can do whatever you want with this code! Credit is not necessary, but always appreciated!

    You can find more information about shaders in Optfine here:
    https://github.com/sp614x/optifine/blob/master/OptiFineDoc/doc/shaders.txt

*/
//Declare GL version.
#version 120

//0-1 amount of blindness.
uniform float blindness;
//0 = default, 1 = water, 2 = lava.
uniform int isEyeInWater;

//Vertex color.
varying vec4 color;
varying vec3 position;

float star(vec3 p)
{
    vec3 f = floor(p+.5);
    return smoothstep(.01,.0,fract(cos(f.x*67.3+f.y*76.6-f.z*81.4)*396.5));
}

void main()
{
    vec4 col = color;

    //Calculate fog intensity in or out of water.
    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);

    //Apply the fog.
    vec3 d = normalize(position);
    vec3 u = abs(d); float m = max(u.x,max(u.y,u.z));
    d /= m;

    col.rgb = vec3(.2,.1,.3)-.2*d.y*d.y+.5*star(d*128.);

    //col.rgb = mix(col.rgb, gl_Fog.color.rgb, fog);

    //Output the result.
    gl_FragData[0] = col * vec4(vec3(1.-blindness),1);
}
