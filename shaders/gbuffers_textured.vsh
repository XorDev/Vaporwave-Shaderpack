#version 120

#define Waviness .5 //Terrain wave intensity [.0 .2 .5 .8 1.]

attribute float mc_Entity;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform vec3 sunPosition;
uniform float frameTimeCounter;

varying vec4 color;
varying vec2 coord0;
varying vec2 coord1;
varying vec3 vert;
varying vec3 norm;

void main()
{
    vec3 pos = (gl_ModelViewMatrix * gl_Vertex).xyz;
    pos = (gbufferModelViewInverse * vec4(pos,1)).xyz;

    vec3 co = pos+cameraPosition;
    vec3 off = pos;
    off.y += .5*Waviness*(cos(co.x*.24+.15*co.z+.5*frameTimeCounter)-
    cos(cameraPosition.x*.24+.15*cameraPosition.z+.5*frameTimeCounter));

    gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(off,1);
    gl_FogFragCoord = length(pos);

    vec3 normal = gl_NormalMatrix * gl_Normal;
    normal = (mc_Entity==1.) ? vec3(0,1,0) : normal;

    color = gl_Color;
    coord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    coord1 = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

    vert = gl_Vertex.xyz;
    norm = normalize((gbufferModelViewInverse * vec4(normal,1)).xyz);
    vec3 sun = normalize(sunPosition);
}
