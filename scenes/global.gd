# Put all global functions and scripts here
extends Node2D

@onready var bullet = preload("res://scenes/objects/bullet.tscn")

@export var shake_screen_timer: Timer
var can_shake_screen = false
var shake_screen_intensity: float

var current_camera: Camera2D
var current_room: Node2D

var player_position: Vector2
var player_dead = false

var is_changing_scene = false

func _process(delta):
	if can_shake_screen:
		current_camera.offset = Vector2(randf_range(-shake_screen_intensity, shake_screen_intensity), \
		randf_range(-shake_screen_intensity, shake_screen_intensity)) + current_camera.default_offset

func change_room(destination_room, fade_speed) -> void:
	current_room.queue_free()
	var new_room = destination_room.instantiate()
	get_node("/root/").add_child(new_room)

func _on_ready_camera(camera) -> void:
	current_camera = camera
	
func _on_ready_room(room) -> void:
	current_room = room

func shake_screen(intensity: float, length: float) -> void:
	shake_screen_intensity = intensity
	shake_screen_timer.set_wait_time(length)
	shake_screen_timer.start()
	can_shake_screen = true

func _on_shake_screen_timer_timeout():
	can_shake_screen = false
	if current_camera != null:
		current_camera.reset()
