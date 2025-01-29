extends Node3D

@export var base : Node3D = self

@onready var default_camera : Camera3D = $Camera3D
@export var camera : Camera3D 

@export var rotation_speed: float = 0.001

@export var upper_look_clamp_degrees: float = 95.0
@export var lower_look_clamp_degrees: float = -55.0


func _ready():
	print(default_camera)
	if not camera: camera = default_camera

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			base.rotate_y(-event.relative.x * rotation_speed)
			camera.rotate_x(-event.relative.y * rotation_speed)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(lower_look_clamp_degrees), deg_to_rad(upper_look_clamp_degrees))
