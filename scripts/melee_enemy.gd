extends CharacterBody3D


const SPEED = 2.5
const DAMAGE = 10
const DAMAGE_TIME = 0.5

var health = 20.0
var damage_timer: Timer
var target = null
var in_damage_range = false
var can_deal_damage = true

func _ready() -> void:
	damage_timer = Timer.new()
	add_child(damage_timer)
	damage_timer.timeout.connect(_on_damage_timer_timeout)


func _physics_process(delta: float) -> void:
	if target and not in_damage_range:
		move_toward_target(delta);
		look_at(target.position)
	else:
		velocity = Vector3.ZERO
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if in_damage_range:
		if can_deal_damage:
			GameManager.deal_damage(DAMAGE)
			damage_timer.start(DAMAGE_TIME)
			can_deal_damage = false
	move_and_slide()

func move_toward_target(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	velocity = direction * SPEED


func take_damage(damage):
	health -= damage
	if health <= 0:
		die()


func die():
	queue_free()


func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = body


func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = null


func _on_player_damage_area_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		in_damage_range = true


func _on_player_damage_area_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body and body.is_in_group("Player"):
		in_damage_range = false


func _on_damage_timer_timeout():
	can_deal_damage = true
