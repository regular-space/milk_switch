# Put all global functions and scripts here
extends Node2D

@onready var bullet = preload("res://scenes/objects/bullet.tscn")

@export var shake_screen_timer: Timer
var can_shake_screen = false
var shake_screen_intensity: float

var current_camera: Camera2D
var current_room: Node2D
var current_room_pack

var player_position: Vector2
var disable_actor = false

var is_changing_scene = false

func _process(delta):
	if can_shake_screen:
		current_camera.offset = Vector2(randi_range(-shake_screen_intensity, shake_screen_intensity), \
		randi_range(-shake_screen_intensity, shake_screen_intensity)) + current_camera.default_offset

func change_room(destination_room, fade_speed) -> void:
	disable_actor = true
	current_room.set_process(false)
	current_room.set_physics_process(false)
	var new_scene = destination_room.instantiate()
	Hud.fade_out(fade_speed)
	
	await Hud.animate_black_screen.animation_finished
	current_room.queue_free()
	disable_actor = false
	get_tree().root.add_child(new_scene)
	Hud.fade_in(fade_speed)

func _on_ready_camera(camera) -> void:
	current_camera = camera
	
func _on_ready_room(room) -> void:
	current_room = room
	match current_room.name:
		"KevLevelA":
			current_room_pack = preload("res://scenes/rooms/kev_level_a.tscn")
		"KevLevelB":
			current_room_pack = preload("res://scenes/rooms/kev_level_b.tscn")
		"KevLevelC":
			current_room_pack = preload("res://scenes/rooms/kev_level_c.tscn")
		"KevLevelD":
			current_room_pack = preload("res://scenes/rooms/kev_level_d.tscn")
	

func shake_screen(intensity: float, length: float) -> void:
	shake_screen_intensity = intensity
	shake_screen_timer.set_wait_time(length)
	shake_screen_timer.start()
	can_shake_screen = true

func _on_shake_screen_timer_timeout():
	can_shake_screen = false
	if current_camera != null:
		current_camera.reset()
