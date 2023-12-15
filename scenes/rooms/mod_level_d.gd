extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	ready.connect(Global._on_ready_room.bind(self))
	#print(name)

func _on_stairs_body_entered(body):
	if body.is_in_group("Player"):
		var next_level = load("res://scenes/rooms/end_screen.tscn")
		Global.change_room(next_level, 1)
