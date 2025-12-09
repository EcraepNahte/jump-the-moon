extends Node

signal pause
signal resume

const MIN_SENSITIVITY = 0.1
const MAX_SENSITIVITY = 1.0

static var toggle_sprint = true
static var toggle_crouch = true
static var look_sensitivity = 0.4
static var joy_deadzone = 0.2
static var controller_sensitivity_modifier = 10.0
static var invert_x = false
static var invert_y = false

func pause_game():
	get_tree().paused = true
	pause.emit()


func resume_game():
	get_tree().paused = false
	resume.emit()


func exit_game():
	get_tree().quit()
