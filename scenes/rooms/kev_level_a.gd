extends Node2D

#var added_test_vfx = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ready.connect(Global._on_ready_room.bind(self))
	#print(name)

#func _physics_process(delta):
	#if not added_test_vfx:
		#Vfx.play_vfx(Vector2(12, 12), "blood_splurt")
		#added_test_vfx = true


func _on_stairs_body_entered(body):
	if body.is_in_group("Player"):
		var next_level = load("res://scenes/rooms/mod_level_d.tscn")
		Global.change_room(next_level, 1)
