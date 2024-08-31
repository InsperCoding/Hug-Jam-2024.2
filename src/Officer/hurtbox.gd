class_name hurtbox
extends Area2D

func _init()-> void:
	collision_layer = 0
	collision_mask = 2
	
func _ready()-> void:
	connect("area_entered", self._on_area_entered)
	
func _on_area_entered(hiitbox: hitbox) -> void:
	if hiitbox == null:
		return
	
	# No matter the type of the node, as long it has the function, we can call the function that we want to use
	if owner.has_method("_on_hitbox_randomize_punishment"):
		owner._on_hitbox_randomize_punishment()
