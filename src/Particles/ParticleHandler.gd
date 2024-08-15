extends Node2D
class_name ParticleHandler

@export var particle : PackedScene

func instance() -> GPUParticles2D:
	
	# instance particle emmiter
	var particle_instance : GPUParticles2D = particle.instantiate()
	
	# add as a child of self
	add_child(particle_instance)
	
	# connect to signal "finished" of the particle
	particle_instance.finished.connect(_particle_finished)
	return particle_instance
	
# called when the lifetime of the particle ends
func _particle_finished():
	# removes the first child in the list
	remove_child(get_child(0))
	
