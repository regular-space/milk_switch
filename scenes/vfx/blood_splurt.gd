extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_finished():
	queue_free()


func _on_tree_entered():
	emitting = true
