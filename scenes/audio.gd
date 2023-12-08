extends Node2D

var gunshot = preload("res://scenes/sound_nodes/gunshot.tscn")
var bullet_hit_wall = preload("res://scenes/sound_nodes/bullet_hit_wall.tscn")

@onready var moo = $Moo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_moo_finished():
	moo.stop()
	
func play_sound(sound: String):
	var sound_name = sound
	
	match sound_name:
		"gunshot": 
			add_sound(gunshot)
		"bullet_hit_wall":
			add_sound(bullet_hit_wall)
			

func add_sound(sound):
	var new_sound = sound.instantiate()
	add_child(new_sound)
