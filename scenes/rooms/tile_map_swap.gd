extends TileMap

@export var map_to_replace: TileMap
var has_swapped := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed(id: int):
	if not has_swapped:
		if id == 1:
			global_position = map_to_replace.global_position
			map_to_replace.queue_free()
			has_swapped = true
