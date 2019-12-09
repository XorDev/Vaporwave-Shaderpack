/*
    XorDev's "Default Shaderpack"

    This was put together by @XorDev to make it easier for anyone to make their own shaderpacks in Minecraft (Optifine).
    You can do whatever you want with this code! Credit is not necessary, but always appreciated!

    You can find more information about shaders in Optfine here:
    https://github.com/sp614x/optifine/blob/master/OptiFineDoc/doc/shaders.txt

*/
//Declare GL version.
#version 120

//Diffuse (color) texture.
uniform sampler2D texture;
//Lighting from day/night + shadows + light sources.
uniform sampler2D lightmap;

//RGB/intensity for hurt entities and flashing creepers.
uniform vec4 entityColor;
//0-1 amount of blindness.
uniform float blindness;
//0 = default, 1 = water, 2 = lava.
uniform int isEyeInWater;

//Vertex color.
varying vec4 color;
//Diffuse and lightmap texture coordinates.
varying vec2 coord0;
varying vec2 coord1;
varying vec3 position;

void main()
{
    //Combine lightmap with blindness.
    vec3 light = (1.-blindness) * texture2D(lightmap,coord1).rgb;
    //Sample texture times lighting.
    vec4 col = color * texture2D(texture,coord0);// * vec4(light,1);
    //Apply entity flashes.
    col.rgb = mix(col.rgb,entityColor.rgb,entityColor.a);

    //Calculate fog intensity in or out of water.
    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);

    //Apply the fog.
    float fade = exp(-gl_FogFragCoord/100.);
    vec3 vapor = exp(-8.*abs(fract(position+.5)*2.-1.)*fade);
    vapor = col.rgb/dot(col,vec4(.288,.587,.114,0))
    *(vapor.xxx+vapor.y+vapor.z);
    col.rgb = vapor*fade*fade;

    //pow(vapor.xxx+vapor.y+vapor.z,vec3(1.2,3,1));
    //col.rgb = mix(vapor, gl_Fog.color.rgb, fog);

    //Output the result.
    gl_FragData[0] = col;
}
