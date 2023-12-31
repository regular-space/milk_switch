extends Node2D

@export var root_scene_node: Node2D
@export var enemy_scene_instance: PackedScene
@export var enemy_spawn_limit := 1
@export var enemy_target: Node2D

var enemy_node
var enemys_spawned := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed(id: int):
	if enemys_spawned != enemy_spawn_limit:
		if (id == 1 or id == 2 or id == 3):
			#PackedScene here needs to be initialized to become a node
			enemy_node = enemy_scene_instance.instantiate()

			owner.add_child(enemy_node)
			enemy_node.set_owner(owner)
			
			enemy_node.global_position = global_position
			enemys_spawned += 1
			if id == 2:
				enemy_node.speed = 65
			else:
				enemy_node.speed = 80
		elif id == 4 or id == 5:
			enemy_node = enemy_scene_instance.instantiate()
			enemy_node.global_position = global_position
			owner.add_child(enemy_node)
			enemy_node.set_owner(owner)
			enemy_node.movement_target = enemy_target
			enemys_spawned += 1
