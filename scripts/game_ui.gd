extends CanvasLayer

const UI_NOTE = preload("res://scenes/ui_note.tscn")

@onready var health_bar: ProgressBar = $HealthBar
@onready var measure: Control = $Measure

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.pause.connect(_on_pause)
	GameManager.resume.connect(_on_resume)
	GameManager.damage_player.connect(_on_damage_player)
	GameManager.spawn_ui_note.connect(_on_spawn_ui_note)
	health_bar.value = GameManager.player_health


func _on_pause():
	hide()


func _on_resume():
	show()


func _on_damage_player(player_health):
	health_bar.value = player_health


func _on_spawn_ui_note():
	var instance = UI_NOTE.instantiate()
	measure.add_child(instance)
