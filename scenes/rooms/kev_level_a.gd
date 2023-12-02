extends Node2D

@onready var room = preload("res://scenes/rooms/kev_level_a.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	ready.connect(Global._on_ready_room.bind(self))

