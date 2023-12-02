shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform bool on;
// Color values are all divided by 255 to scale them to the 0-1 scale shaders use
const vec3 color1 = vec3(56.0,23.0,36.0)/255.0;
const vec3 color2 = vec3(110.0,64.0,52.0)/255.0;
const vec3 color3 = vec3(158.0,82.0,61.0)/255.0;

const vec3 white = vec3(1.0,1.0,1.0);
const vec3 grey = vec3(170,170,170)/255.0;
const vec3 black = vec3(0.0,0.0,0.0);

// Changes colour
void fragment() {
    vec3 col = texture(screen_texture, SCREEN_UV).rgb;
	// all() here just checks all boolean values in the bvec3 returned from equal are true
    if (on)
	{
		if(all(equal(col,white)))
		{
			col.rgb = color1;
		}
		else if(all(equal(col,grey)))
		{
			col.rgb = color2;
		}
		else if(all(equal(col,black)))
		{
			col.rgb = color3;
		}
		
	}
	else
	{
		// white
		if(all(equal(col,white)))
		{
			col.rgb = color3;
		}
		// grey
		else if(all(equal(col,grey)))
		{
			col.rgb = color2;
		}
		// black
		else if(all(equal(col,black)))
		{
			col.rgb = color1;
		}
	}
	COLOR.rgb = col;
}