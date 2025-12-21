extends CanvasLayer

const UI_NOTE = preload("res://scenes/ui_note.tscn")

@onready var health_bar: ProgressBar = $HealthBar
@onready var measure: Control = $Measure
@onready var gifts_count: Label = $GiftsCount
@onready var count_down: Label = $CountDown
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.pause.connect(_on_pause)
	GameManager.pause_for_intro.connect(_on_pause)
	GameManager.resume.connect(_on_resume)
	GameManager.damage_player.connect(_on_damage_player)
	GameManager.spawn_ui_note.connect(_on_spawn_ui_note)
	GameManager.gift_collected.connect(_on_gift_collected)
	health_bar.value = GameManager.player_health
	timer.wait_time = GameManager.LOOP_TIME * GameManager.LOOPS
	timer.start()


func _process(delta: float) -> void:
	count_down.text = seconds_to_mm_ss(timer.time_left)


func seconds_to_mm_ss(total_seconds: float) -> String:
	var minutes: int = int(total_seconds / 60.0)
	var seconds: int = int(total_seconds) % 60
	# Use "%02d" to zero-pad integers to a width of 2 digits
	var time_string: String = "%02d:%02d" % [minutes, seconds]
	return time_string


func _on_pause():
	hide()


func _on_resume():
	show()


func _on_damage_player(player_health):
	health_bar.value = player_health


func _on_spawn_ui_note():
	var instance = UI_NOTE.instantiate()
	measure.add_child(instance)


func _on_gift_collected():
	gifts_count.text = str(GameManager.collected_gifts)
