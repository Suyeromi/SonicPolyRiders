class_name Character
extends CharacterBody3D

@export_category("Stats")
@export var current_speed = 0
@export var turning_speed = 2
@export var top_speed = 1600
@export var acceleration = 200
@export var deceleration = 5

var imaginary_wheel: int = 6.0


func _physics_process(delta: float) -> void:
	movement(delta)
	move_and_slide()
	
	pass

func movement(delta):
	
	var forward = 0
	
	if Input.is_action_pressed("ui_up"):
		forward = 1
		
	else:
		forward = 0
		pass
	
	var turning = 0
	
	if Input.is_action_pressed("ui_left"):
		turning = 1
	if Input.is_action_pressed("ui_right"):
		turning = -1
	
	
	current_speed = (forward * acceleration) * delta
	
	current_speed = clamp(current_speed, -top_speed, top_speed)
	
	
	rotation += Vector3(0, turning * turning_speed * delta, 0)
	
	
	
	velocity = transform.basis.z * current_speed
	
	pass
