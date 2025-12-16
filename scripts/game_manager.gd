extends Node

signal pause
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

signal damage_player(damage: int)

const MIN_SENSITIVITY = 0.1
const MAX_SENSITIVITY = 1.0
const BASE_HEALTH = 100.0

static var toggle_sprint = true
static var toggle_crouch = true
static var look_sensitivity = 0.4
static var joy_deadzone = 0.2
static var controller_sensitivity_modifier = 10.0
static var invert_x = false
static var invert_y = false
static var note_preview_time = 3.0

static var player_health = 100


func pause_game():
	get_tree().paused = true
	pause.emit()


func resume_game():
	get_tree().paused = false
	resume.emit()


func end_game():
	game_over.emit()
	get_tree().paused = true


func restart_scene():
	get_tree().paused =  false
	get_tree().reload_current_scene()
	player_health = BASE_HEALTH


func exit_game():
	get_tree().quit()


func deal_damage(damage):
	player_health -= damage
	damage_player.emit(player_health)
	if player_health <= 0:
		end_game()
	
