class_name hitbox
extends Area2D

signal randomize_punishment

func _init() -> void:
	collision_layer = 2
	collision_mask = 0
