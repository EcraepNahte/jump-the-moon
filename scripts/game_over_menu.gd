extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameManager.game_over.connect(_on_game_over)


func _on_game_over():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$MainMenu/Restart.grab_focus()
	if GameManager.collected_gifts == 5:
		$MainMenu/Label.text = 'YOU WIN!'
	show()


func _on_restart_pressed() -> void:
	GameManager.restart_scene()


func _on_main_menu_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	GameManager.exit_game()
