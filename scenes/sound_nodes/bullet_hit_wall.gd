extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(owner._on_bullet_hit_wall_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
