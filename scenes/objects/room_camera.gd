extends Camera2D

var default_offset = Vector2(0,4)

# Called when the node enters the scene tree for the first time.
func _ready():
	ready.connect(Global._on_ready_camera.bind(self))

func reset() -> void:
	offset = default_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
