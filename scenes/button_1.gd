extends Sprite2D

## MUST BE UNIQUE WITHIN A SCENE
@export var unique_id: int =  1

var is_pressed := false
signal button_pressed(id:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_pressed:
		button_pressed.emit(unique_id)


func _on_button_trigger_area_entered(body):
	is_pressed = true


func _on_button_trigger_area_exited(body):
	is_pressed = false
