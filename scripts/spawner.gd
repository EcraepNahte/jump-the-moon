extends Node3D


const MELEE_ENEMY = preload("res://scenes/melee_enemy.tscn")
const RANGED_ENEMY = preload("res://scenes/ranged_enemy.tscn")

@export_enum("melee", "ranged") var type = "melee"
@export_range(1, 4, 1) var index = 1

var player_in_range = false

func _ready() -> void:
	GameManager.spawn_melee_1.connect(_on_spawn_melee_1)
	GameManager.spawn_melee_2.connect(_on_spawn_melee_2)
	GameManager.spawn_melee_3.connect(_on_spawn_melee_3)
	GameManager.spawn_melee_4.connect(_on_spawn_melee_4)
	GameManager.spawn_ranged_1.connect(_on_spawn_ranged_1)
	GameManager.spawn_ranged_2.connect(_on_spawn_ranged_2)


func _on_spawn_melee_1():
	if type == "melee" and index == 1 and player_in_range:
		var instance = MELEE_ENEMY.instantiate()
		get_parent().add_child(instance)
		instance.global_position = global_position


func _on_spawn_melee_2():
	if type == "melee" and index == 2 and player_in_range:
		var instance = MELEE_ENEMY.instantiate()
		get_parent().add_child(instance)
		instance.global_position = global_position


func _on_spawn_melee_3():
	if type == "melee" and index == 3 and player_in_range:
		var instance = MELEE_ENEMY.instantiate()
		get_parent().add_child(instance)
		instance.global_position = global_position


func _on_spawn_melee_4():
	if type == "melee" and index == 4 and player_in_range:
		var instance = MELEE_ENEMY.instantiate()
		get_parent().add_child(instance)
		instance.global_position = global_position


func _on_spawn_ranged_1():
	if type == "ranged" and index == 1 and player_in_range:
		var instance = RANGED_ENEMY.instantiate()
		get_parent().add_child(instance)
		instance.global_position = global_position


func _on_spawn_ranged_2():
	if type == "ranged" and index == 2 and player_in_range:
		var instance = RANGED_ENEMY.instantiate()
		get_parent().add_child(instance)
		instance.global_position = global_position


func _on_player_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true



func _on_player_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
