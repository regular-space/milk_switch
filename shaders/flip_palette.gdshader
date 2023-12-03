shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform bool on = true;
// Color values are all divided by 255 to scale them to the 0-1 scale shaders use
uniform vec3 color1 = vec3(56.0,23.0,36.0);
uniform vec3 color2 = vec3(110.0,64.0,52.0);
uniform vec3 color3 = vec3(158.0,82.0,61.0);

const vec3 white = vec3(1.0,1.0,1.0);
const vec3 grey = vec3(170,170,170)/255.0;
const vec3 black = vec3(0.0,0.0,0.0);

// Changes colour
void fragment() {
    vec3 col = texture(screen_texture, SCREEN_UV).rgb;
	// all() here just checks all boolean values in the bvec3 returned from equal are true
    if (on)
	{
		// white
		if(all(equal(col,white)))
		{
			col.rgb = color3 / 255.0;
		}
		// grey
		else if(all(equal(col,grey)))
		{
			col.rgb = color2 / 255.0;
		}
		// black
		else if(all(equal(col,black)))
		{
			col.rgb = color1 / 255.0;
		}
	}
	else
	{
		if(all(equal(col,white)))
		{
			col.rgb = color1 / 255.0;
		}
		else if(all(equal(col,grey)))
		{
			col.rgb = color2 / 255.0;
		}
		else if(all(equal(col,black)))
		{
			col.rgb = color3 / 255.0;
		}
	}
	COLOR.rgb = col;
}