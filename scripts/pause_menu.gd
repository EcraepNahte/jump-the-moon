extends CanvasLayer

@onready var main_menu: VBoxContainer = $MainMenu
@onready var settings_menu: VBoxContainer = $SettingsMenu

func _ready():
	# Hide the menu when the game starts
	visible = false
	# Ensure the menu processes input even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Connect to the pause signal from the game manager
	GameManager.pause.connect(_on_pause)
	GameManager.resume.connect(_on_resume)


func _input(event):
	if event.is_action("ui_cancel"):
		show_main_menu()


func hide_all_menus():
	main_menu.visible = false
	settings_menu.visible = false


func show_main_menu():
	hide_all_menus()
	main_menu.visible = true
	$MainMenu/Resume.grab_focus()


func show_settings_menu():
	hide_all_menus()
	settings_menu.visible = true
	$SettingsMenu/ToggleSprint.grab_focus()


func _on_pause():
	# Toggle the visibility of the menu root node (CanvasLayer)
	visible = true
	show_main_menu()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_resume():
	if get_tree().paused:
		GameManager.resume_game()
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	show_main_menu()


func _on_settings_clicked():
	$SettingsMenu/ToggleSprint.button_pressed = GameManager.toggle_sprint
	$SettingsMenu/ToggleCrouch.button_pressed = GameManager.toggle_crouch
	$SettingsMenu/InvertAim.button_pressed = GameManager.invert_y
	$SettingsMenu/SensitivitySlider.value = GameManager.look_sensitivity
	$SettingsMenu/SensitivitySlider.min_value = GameManager.MIN_SENSITIVITY
	$SettingsMenu/SensitivitySlider.max_value = GameManager.MAX_SENSITIVITY
	show_settings_menu()


func _on_settings_save_clicked():
	GameManager.toggle_sprint = $SettingsMenu/ToggleSprint.button_pressed
	GameManager.toggle_crouch = $SettingsMenu/ToggleCrouch.button_pressed
	GameManager.invert_y = $SettingsMenu/InvertAim.button_pressed
	GameManager.look_sensitivity = $SettingsMenu/SensitivitySlider.value
	show_main_menu()


func _on_settings_cancel_clicked():
	show_main_menu()


func _on_exit_clicked():
	GameManager.exit_game()
