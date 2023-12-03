extends Node2D

var title_room = preload("res://scenes/title.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	ready.connect(Global._on_ready_room.bind(self))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	Global.change_room(title_room, 1)
