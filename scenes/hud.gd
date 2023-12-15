extends CanvasLayer

@onready var animate_black_screen = $AnimateBlackScreen
@onready var black_screen = $BlackScreen
@onready var restart_txt = $RestartText

var controller_using := false

var restart_txt_rotation_limit := deg_to_rad(10.0)
# False is left and true is right
var restart_txt_dir := false

# False = white, True = black
var is_black = false
signal palette_switched

@export var palette: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO,Vector3.ZERO];

# Called when the node enters the scene tree for the first time.
func _ready():
	$PaletteSwitcher.material.set_shader_parameter("color1", palette[0])
	$PaletteSwitcher.material.set_shader_parameter("color2", palette[1])
	$PaletteSwitcher.material.set_shader_parameter("color3", palette[2])
	
	#black_screen.color = Color(0, 0, 0, 0)
	black_screen.hide()
	
	
func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		controller_using = true
	elif event is InputEventKey:
		controller_using = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Global.all_actors_disabled and not Global.is_changing_scene:
		restart_txt.visible = true
		
		if controller_using:
			$RestartText/RestartTextKeyboard.visible = false
			$RestartText/RestartTextController.visible = true
		else:
			$RestartText/RestartTextController.visible = false
			$RestartText/RestartTextKeyboard.visible = true
		
		# Tweening code
		var tween = create_tween()
		tween.set_speed_scale(1)
		
		# Changing direction code
		if restart_txt.rotation > 0.16:
			restart_txt_dir = false
		elif restart_txt.rotation < -0.16:
			restart_txt_dir = true
		# Changing tween to change direction here
		if restart_txt_dir:
			tween.tween_property(restart_txt,"rotation",restart_txt_rotation_limit,0.055).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE  )
		else:
			tween.tween_property(restart_txt,"rotation",-restart_txt_rotation_limit,0.055).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE  )

	else:
		restart_txt.visible = false

func _on_switch_milk_pressed() -> void:
	$PaletteSwitcher.material.set_shader_parameter("on", is_black)
	is_black = not is_black
	palette_switched.emit()
	
func fade_out(length):
	#black_screen.color = Color(0, 0, 0, 0)
	black_screen.show()
	animate_black_screen.play("fade_out", -1, length)
	await animate_black_screen.animation_finished
	black_screen.hide()
	
func fade_in(length):
	#black_screen.color = Color(0, 0, 0, 255)
	black_screen.show()
	animate_black_screen.play("fade_in", -1, length)
	await animate_black_screen.animation_finished
	black_screen.hide()
