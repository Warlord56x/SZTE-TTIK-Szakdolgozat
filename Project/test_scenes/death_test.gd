extends Node2D

signal done


func _ready() -> void:
	$GPUParticles2D.emitting = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()
	done.emit()
