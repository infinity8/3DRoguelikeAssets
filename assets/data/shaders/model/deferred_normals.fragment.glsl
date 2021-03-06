#ifdef GL_ES
	precision highp float;
 	#extension GL_OES_standard_derivatives : enable 
#endif

uniform mat3 u_normal_matrix;

#ifdef u_normalmap_textureFlag
	uniform sampler2D u_normalmap_texture;
#endif

varying vec2 v_texCoords;
varying vec3 v_normal;
varying vec3 v_pos;
//varying vec2 v_depth;

uniform mat4 u_v;

uniform float u_linearDepth;

varying vec3 v_d;

vec2 packHalf (float depth)
{
	const vec2 bias = vec2(1.0 / 255.0,
				0.0);
							
	vec2 colour = vec2(depth, fract(depth * 255.0));
	return colour - (colour.yy * bias);
}

vec2 encode (vec3 n)
{
	float f = sqrt(8.0*n.z+8.0);
    return n.xy / f + 0.5;
}

mat3 computeTangentFrame(vec3 normal, vec3 position, vec2 texCoord)
{
    vec3 dpx = dFdx(position);
    vec3 dpy = dFdy(position);
    vec2 dtx = dFdx(texCoord);
    vec2 dty = dFdy(texCoord);
    
    vec3 tangent = normalize(dpx * dty.t - dpy * dtx.t);
	vec3 binormal = normalize(-dpx * dty.s + dpy * dtx.s);
   
    return mat3(tangent, binormal, normal);
}

void main()
{		
	#ifdef u_normalmap_textureFlag
		vec3 normal = normalize((2.0 * texture2D(u_normalmap_texture, v_texCoords).xyz - 1.0) * computeTangentFrame(u_normal_matrix * v_normal, v_pos, v_texCoords));
	#else
		vec3 normal = normalize(u_normal_matrix * v_normal);
	#endif

	normal = normalize( (u_v * vec4(normal, 0.0)).xyz );

	gl_FragColor.rg = encode( normal ); //1.0;//normal * 0.5 + 0.5;
	gl_FragColor.ba = packHalf(length(v_d)/u_linearDepth);//v_depth.x/v_depth.y);//v_d.z / 150.0; //length( v_pos - u_cam ) / 150;//v_depth.x/v_depth.y;
}