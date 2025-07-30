class_name Character
extends CharacterBody3D

@export_category("Stats")
@export var current_speed = 0
@export var turning_speed = 0.5
@export var top_speed = 450
@export var board_top_speed = 900
@export var speed = 0
@export var acceleration = 10
@export var deceleration = 25
var forward = 0
var board
@onready var gravity =  ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var slope_raycast = %AngleRaycast
var xform : Transform3D
@onready var ground_raycast = %GroundRaycast
@onready var drift_particles = %DriftParticles

@onready var CharacterAnimation = $POLY_SONIC/AnimationPlayer
@onready var CharacterAnimationTree = $POLY_SONIC/AnimationTree


func _physics_process(delta: float) -> void:


	
	if is_on_floor():
		slope_alignment(slope_raycast.get_collision_normal())
		global_transform = global_transform.interpolate_with(xform, 0.2)
	elif not is_on_floor():
		global_transform = global_transform.interpolate_with(xform, 0.2)
		slope_alignment(Vector3.UP)
	movement(delta)
	move_and_slide()
	

	
	pass

func movement(delta):
	
	
	if Input.is_action_pressed("ui_up"):
		board = false
		speed += acceleration
		forward = 1
		speed = clamp(speed, 0 , top_speed)
		CharacterAnimation.play("no_walk")
	elif board == false and not Input.is_action_pressed("ui_up"):
		speed -= deceleration
		pass
	
		if speed < 0:
			forward = 0
			speed = 0
			
	
	if current_speed <= 0:
		CharacterAnimation.play("menu_idle")
	
	if Input.is_action_pressed("Board Mode"):
		board = true
	
	if board == true:
		forward = 1
		speed += acceleration
		speed = clamp(speed, 0 , board_top_speed)
		CharacterAnimation.play('board_fast')
	

	
	var turning = 0
	
	if Input.is_action_pressed("ui_left"):
		turning = 1
		CharacterAnimation.play('board_tilt_L')
		if Input.is_action_pressed("Drift") and board == true:
			turning_speed = 1.75
			drift_particles.emitting = true
			#CharacterAnimation.play('board_drift_L')
			CharacterAnimation.play("board_drift_L")
		else:
			turning_speed = 0.5
			drift_particles.emitting = false
			
	if Input.is_action_pressed("ui_right"):
		turning = -1
		CharacterAnimation.play('board_tilt_R')
		if Input.is_action_pressed("Drift") and board == true:
			turning_speed = 1.75
			drift_particles.emitting = true
			CharacterAnimation.play('board_drift_R')
		else:
			turning_speed = 0.5
			drift_particles.emitting = false
			
	
	current_speed = (forward * speed) * delta
	
	current_speed = clamp(current_speed, 0, top_speed)
	
	
	
	if current_speed >= top_speed:
		current_speed = top_speed
	
	
	rotation += Vector3(0, turning * turning_speed * delta, 0)
	
	
	
	velocity = transform.basis.z * current_speed
	if not is_on_floor():
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		velocity += transform.basis.y * -gravity
		CharacterAnimation.play('board_jump')
	elif is_on_floor():
		gravity = 0
	
	#if is_on_floor() and !Input.is_action_pressed("ui_up") and board == false and turning == 0:
		#CharacterAnimation.play("menu_idle")
	#pass

func slope_alignment(floor_normal):
	
	xform = transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()
	
	#if is_on_floor():
		#global_transform = xform
	
	pass

	
	pass
