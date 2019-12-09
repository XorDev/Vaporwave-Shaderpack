/*
    XorDev's "Default Shaderpack"

    This was put together by @XorDev to make it easier for anyone to make their own shaderpacks in Minecraft (Optifine).
    You can do whatever you want with this code! Credit is not necessary, but always appreciated!

    You can find more information about shaders in Optfine here:
    https://github.com/sp614x/optifine/blob/master/OptiFineDoc/doc/shaders.txt

*/
//Declare GL version.
#version 120

//Get Entity id.
attribute float mc_Entity;

//Model * view matrix and it's inverse.
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform vec3 sunPosition;
uniform float frameTimeCounter;

//Pass vertex information to fragment shader.
varying vec4 color;
varying vec2 coord0;
varying vec2 coord1;
varying vec3 position;

void main()
{
    //Calculate world space position.
    vec3 pos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    pos = (gbufferModelViewInverse * vec4(pos,1)).xyz;

    vec3 co = pos+cameraPosition;
    vec3 off = pos;
    off.y += .5*(cos(co.x*.24+.15*co.z+.5*frameTimeCounter)-
    cos(cameraPosition.x*.24+.15*cameraPosition.z+.5*frameTimeCounter));

    //Output position and fog to fragment shader.
    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(off,1);
    gl_FogFragCoord = length(pos);

    //Calculate view space normal.
    vec3 normal = gl_NormalMatrix * gl_Normal;
    //Use flat for flat "blocks" or world space normal for solid blocks.
    normal = (mc_Entity==1.) ? vec3(0,1,0) : normal;

    vec3 sun = normalize(sunPosition);
    float light = .7+.3*dot(normal,sun);

    //Output color with lighting to fragment shader.
    color = vec4(gl_Color.rgb * (1.-(1.-light)*vec3(1.,.7,.5)), gl_Color.a);
    //Output diffuse and lightmap texture coordinates to fragment shader.
    coord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    coord1 = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    position = pos+cameraPosition+gl_Normal*.2;
}
