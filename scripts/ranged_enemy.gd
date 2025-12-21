extends CharacterBody3D


const ENEMY_BULLET = preload("res://scenes/enemy_bullet.tscn")

const DAMAGE = 10
const DAMAGE_TIME = 0.3

@onready var shoot_position: Node3D = $ShootPosition

var health = 10.0
var shoot_timer: Timer
var target = null
var in_damage_range = false
var can_deal_damage = true

func _ready() -> void:
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	GameManager.enemy_shoot.connect(_on_enemy_shoot)


func _physics_process(delta: float) -> void:
	if target:
		look_at(target.position)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if in_damage_range:
		if can_deal_damage:
			GameManager.deal_damage(DAMAGE)
			shoot_timer.start(DAMAGE_TIME)
			can_deal_damage = false
	move_and_slide()


func take_damage(damage):
	health -= damage
	if health <= 0:
		die()


func die():
	queue_free()


func shoot():
	if can_deal_damage:
		var instance = ENEMY_BULLET.instantiate()
		get_parent().add_child(instance)
		instance.global_position = shoot_position.global_position
		instance.global_rotation = shoot_position.global_rotation
		instance.speed = 15.0
		can_deal_damage = false
		shoot_timer.start()


func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = body


func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = null


func _on_enemy_shoot():
	if target and can_deal_damage:
		shoot()


func _on_shoot_timer_timeout():
	can_deal_damage = true
