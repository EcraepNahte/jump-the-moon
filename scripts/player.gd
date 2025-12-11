extends CharacterBody3D


@onready var standing_collision_shape = $StandingCollisionShape
@onready var crouching_collision_shape = $CrouchingCollisionShape
@onready var head = $Head
@onready var hand = $Head/Hand
@onready var camera_3d = $Head/Camera3D
@onready var crouch_raycast = $CrouchRaycast
@onready var front_face = $LedgeRaycasts/FrontFace
@onready var top_of_ledge = $LedgeRaycasts/TopOfLedge
@onready var high_ledge: RayCast3D = $LedgeRaycasts/HighLedge
@onready var gun_anim: AnimationPlayer = $"Head/Hand/blaster-h3/AnimationPlayer"

const JUMP_VELOCITY = 4.5
const LEDGE_JUMP_VELOCITY = 6.0
const BASE_MOVE_SPEED = 5.0
const SPRINT_MULTIPLIER = 2.0
const CROUCH_MULTIPLIER = 0.5
const LEDGE_GRAB_MULTIPLIER = 0.3
const STANDING_HEAD_HEIGHT = 0.75
const CROUCHING_HEAD_HEIGHT = 0.0
const LERP_SPEED = 5.0
const JUMPS = 1
const HAND_START_POS = Vector3(0.3, -0.2, -0.5)
const HAND_AIM_POS = Vector3(0.0, -0.15, -0.5)
const NORMAL_FOV = 75.0
const AIM_FOV = 55.0
const SPRINT_FOV = 90.0

var move_speed = 5.0
var sprinting = false
var crouching = false
var aiming = false
var trying_to_stand = false
var grabbing_ledge = false
var jump_count = 0
var joystick_v_event = null
var joystick_h_event = null


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * GameManager.look_sensitivity) * (1 if GameManager.invert_x else -1))
		head.rotate_x(deg_to_rad(event.relative.y * GameManager.look_sensitivity) * (1 if GameManager.invert_y else -1))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-98), deg_to_rad(98))
	elif event is InputEventJoypadMotion:
		if event.axis == 2:
			joystick_v_event = event
		elif event.axis == 3:
			joystick_h_event = event


func _physics_process(delta):
	_handle_controller_look()
	_check_mantle()
	_control_loop(delta)
	move_and_slide()


func _handle_controller_look():
	if joystick_v_event:
		if abs(joystick_v_event.get_axis_value()) > GameManager.joy_deadzone:
			rotate_y(deg_to_rad(joystick_v_event.get_axis_value() * GameManager.look_sensitivity) * GameManager.controller_sensitivity_modifier * (1 if GameManager.invert_x else -1))
	
	if joystick_h_event:
		if abs(joystick_h_event.get_axis_value()) > GameManager.joy_deadzone:
			head.rotate_x(deg_to_rad(joystick_h_event.get_axis_value() * GameManager.look_sensitivity) * GameManager.controller_sensitivity_modifier * (1 if GameManager.invert_y else -1))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-98), deg_to_rad(98))


func _control_loop(delta):
	# Handle Pause
	if Input.is_action_just_pressed("pause"):
		GameManager.pause_game()
		
	# Add the gravity.
	if not is_on_floor() and not grabbing_ledge:
		velocity += get_gravity() * delta
	else:
		jump_count = 0

	# Handle jump
	if Input.is_action_just_pressed("jump") and jump_count < JUMPS:
		if grabbing_ledge:
			velocity.y = LEDGE_JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY
		jump_count = jump_count + 1
	
	# Handle Crouch
	if GameManager.toggle_crouch:
		if Input.is_action_just_pressed("crouch"):
			if crouching:
				trying_to_stand = true
			else:
				crouching = true
				trying_to_stand = false
			sprinting = false
	else:
		trying_to_stand = !Input.is_action_pressed("crouch")
	
	# Handle Sprint
	if GameManager.toggle_sprint:
		if Input.is_action_just_pressed("sprint"):
			sprinting = !sprinting
			trying_to_stand = true
	else:
		sprinting = Input.is_action_pressed("sprint")
	
	# Control Character
	if trying_to_stand or !crouching:
		_try_standing_up(delta)
	elif crouching:
		_crouch(delta)
	
	# Handle Shoot
	if Input.is_action_pressed("shoot"):
		if not gun_anim.is_playing():
			gun_anim.play("shoot")
	
	# Handle Aim
	aiming = Input.is_action_pressed("aim")
	
	if grabbing_ledge:
		move_speed = BASE_MOVE_SPEED * LEDGE_GRAB_MULTIPLIER
		aiming = false
		if velocity.y < 0.0:
			velocity.y = 0.0
	elif crouching or aiming:
		move_speed = BASE_MOVE_SPEED * CROUCH_MULTIPLIER
	elif sprinting:
		move_speed = BASE_MOVE_SPEED * SPRINT_MULTIPLIER
		aiming = false
	else:
		move_speed = BASE_MOVE_SPEED
	
	if aiming:
		hand.position = lerp(hand.position, HAND_AIM_POS, delta * LERP_SPEED)
	else:
		hand.position = lerp(hand.position, HAND_START_POS, delta * LERP_SPEED)
	
	
	if aiming:
		camera_3d.fov = lerp(camera_3d.fov, AIM_FOV, delta * LERP_SPEED)
	elif sprinting:
		camera_3d.fov = lerp(camera_3d.fov, SPRINT_FOV, delta * LERP_SPEED)
	else:
		camera_3d.fov = lerp(camera_3d.fov, NORMAL_FOV, delta * LERP_SPEED)
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * move_speed, delta * LERP_SPEED)
		velocity.z = lerp(velocity.z, direction.z * move_speed, delta * LERP_SPEED)
	else: 
		sprinting = false
		velocity.x = lerp(velocity.x, 0.0, delta * LERP_SPEED)
		velocity.z = lerp(velocity.z, 0.0, delta * LERP_SPEED)


func _check_mantle():
	grabbing_ledge = (front_face.is_colliding() or high_ledge.is_colliding()) and !top_of_ledge.is_colliding() 


func _try_standing_up(delta):
	if crouch_raycast.is_colliding():
		return
	standing_collision_shape.disabled = false
	crouching_collision_shape.disabled = true
	head.position.y = lerp(head.position.y, STANDING_HEAD_HEIGHT, delta * LERP_SPEED)
	crouching = false
	trying_to_stand = false


func _crouch(delta):
	standing_collision_shape.disabled = true
	crouching_collision_shape.disabled = false
	head.position.y = lerp(head.position.y, CROUCHING_HEAD_HEIGHT, delta * LERP_SPEED)
