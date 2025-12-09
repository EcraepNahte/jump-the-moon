extends CanvasLayer


func _ready():
	# Hide the menu when the game starts
	visible = false
	# Ensure the menu processes input even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Connect to the pause signal from the game manager
	GameManager.pause.connect(_on_pause)
	GameManager.resume.connect(_on_resume)


func _on_pause():
	# Toggle the visibility of the menu root node (CanvasLayer)
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_resume():
	if get_tree().paused:
		GameManager.resume_game()
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_settings_clicked():
	pass


func _on_exit_clicked():
	GameManager.exit_game()
