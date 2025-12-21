extends Node

signal pause
signal pause_for_intro
signal resume
signal game_over

signal player_shoot
signal enemy_shoot
signal spawn_melee_1
signal spawn_melee_2
signal spawn_melee_3
signal spawn_melee_4
signal spawn_ranged_1
signal spawn_ranged_2
signal spawn_ui_note
signal gift_collected

signal damage_player(damage: int)

const MIN_SENSITIVITY = 0.1
const MAX_SENSITIVITY = 1.0
const BASE_HEALTH = 100.0
const LOOP_TIME = 59.0
const LOOPS = 3

static var toggle_sprint = true
static var toggle_crouch = true
static var look_sensitivity = 0.4
static var joy_deadzone = 0.1
static var controller_sensitivity_modifier = 10.0
static var invert_x = false
static var invert_y = false
static var note_preview_time = 3.0
static var use_free_shoot = false

static var player_health = 100

var collected_gifts = 0
var wait_time = 0


func _ready() -> void:
	gift_collected.connect(_on_gift_collected)


func pause_game_for_intro():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pause_for_intro.emit()


func pause_game():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pause.emit()


func resume_game():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	resume.emit()


func end_game():
	game_over.emit()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true


func restart_scene():
	get_tree().paused =  false
	get_tree().reload_current_scene()
	reset_scene()


func exit_game():
	get_tree().quit()


func deal_damage(damage):
	player_health -= damage
	player_health = clamp(player_health, 0, BASE_HEALTH)
	damage_player.emit(player_health)
	if player_health <= 0:
		end_game()


func reset_scene():
	collected_gifts = 0
	player_health = BASE_HEALTH


func _on_gift_collected():
	collected_gifts += 1
	if collected_gifts >= 5:
		end_game()
