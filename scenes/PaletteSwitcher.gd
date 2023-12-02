extends ColorRect

var paletteSwitch := false
signal paletteSwitched

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("switch_milk")):
		material.set_shader_parameter("on", paletteSwitch)
		paletteSwitch = not paletteSwitch
		paletteSwitched.emit()
