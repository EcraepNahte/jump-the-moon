extends Control

@onready var note: Label = $Note

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(note, "position", Vector2.ZERO, GameManager.note_preview_time)
	tween.tween_callback(queue_free)
