extends AudioStreamPlayer3D


@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

@export var shoot_times: Array[float] = []

var upcoming_shoot_times = []
var ui_note_times = []
var loop = 0

func _ready() -> void:
	animation_player.play("music_timeline")
	upcoming_shoot_times = shoot_times.duplicate()
	ui_note_times = shoot_times.duplicate()
	
	for i in ui_note_times.size():
		ui_note_times[i] -= GameManager.note_preview_time


func _process(delta: float) -> void:
	var playback = get_playback_position()
	
	if len(ui_note_times) > 0 and ui_note_times[0] <= playback:
		GameManager.spawn_ui_note.emit()
		ui_note_times.remove_at(0)
	
	if len(upcoming_shoot_times) > 0 and upcoming_shoot_times[0] <= playback:
		GameManager.player_shoot.emit()
		upcoming_shoot_times.remove_at(0)
	
	if GameManager.LOOP_TIME <= playback:
		animation_player.stop(false)
		animation_player.play("music_timeline")
		upcoming_shoot_times = shoot_times.duplicate()
		ui_note_times = shoot_times.duplicate()
		play(0.0)
		loop += 1
		if loop >= GameManager.LOOPS:
			GameManager.end_game()


func _trigger_player_shoot():
	pass
	#GameManager.player_shoot.emit()


func _trigger_spawn_melee_1():
	GameManager.spawn_melee_1.emit();


func _trigger_spawn_melee_2():
	GameManager.spawn_melee_2.emit();


func _trigger_spawn_melee_3():
	GameManager.spawn_melee_3.emit();


func _trigger_spawn_melee_4():
	GameManager.spawn_melee_4.emit();


func _trigger_spawn_ranged_1():
	GameManager.spawn_ranged_1.emit();


func _trigger_spawn_ranged_2():
	GameManager.spawn_ranged_2.emit();


func _trigger_enemy_shoot():
	GameManager.enemy_shoot.emit();
