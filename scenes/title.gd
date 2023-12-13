extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ready.connect(Global._on_ready_room.bind(self))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("switch_milk"):
		Global.shake_screen(1, 1)
		Audio.moo.play()
		#Global.change_room(test, 1)
