extends Node3D


const ROTATION = 2.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	rotate_y(ROTATION * delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		GameManager.deal_damage(-50)
		queue_free()
