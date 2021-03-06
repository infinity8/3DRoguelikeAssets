#ifdef GL_ES
	precision mediump float;

#endif

uniform sampler2D u_diffuse_texture;

varying vec2 v_texCoords;
varying vec3 v_diffuse;
void main()
{		
	gl_FragColor.rgb = v_diffuse * texture2D(u_diffuse_texture, v_texCoords).rgb;

	gl_FragColor.a = 1.0;

}