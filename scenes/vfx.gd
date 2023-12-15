extends CanvasLayer

@onready var blood_splurt = preload("res://scenes/vfx/blood_splurt.tscn")
@onready var bullet_break = preload("res://scenes/vfx/bullet_break.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.room_changed.connect(self._on_changed_room)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_changed_room() -> void:
	for x in get_children():
		x.queue_free()

func play_vfx(spawn_position, vfx) -> void:
	var new_vfx
	match vfx:
		"blood_splurt":
			new_vfx = blood_splurt.instantiate()
		"bullet_break":
			new_vfx = bullet_break.instantiate()
	new_vfx.set_global_position(spawn_position)
	add_child(new_vfx)
