extends Area3D


const DAMAGE = 10.0

@export var speed = 25.0

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D


func _physics_process(delta: float) -> void:
	position = position - transform.basis.z * speed * delta


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
	mesh_instance_3d.hide()
	gpu_particles_3d.emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
