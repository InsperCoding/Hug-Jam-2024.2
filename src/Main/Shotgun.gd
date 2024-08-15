extends Sprite2D

var muzzleflash : GPUParticles2D
var phandler : ParticleHandler

# Called when the node enters the scene tree for the first time.
func _ready():
	phandler = get_node("../ParticleHandler")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Mouse position
	var mousepos = get_global_mouse_position()
	
	# if mouse is bdsefore the player
	if mousepos.x - global_position.x < 0:
		# since the sprite's inverted, it has to look to the opposite direction of the mouse
		look_at(global_position + (global_position - mousepos))
		scale.x = -0.7
	else:
		# looks at the mouse
		look_at(mousepos)
		scale.x = 0.7


func _on_player_shoot():

	# instance of the particle emitter
	muzzleflash = phandler.instance()
	
	# change position to the muzzle
	muzzleflash.global_position = $Muzzle.global_position
	
	# vector of direction is the velocity, pointing to the mouse
	var direction : Vector2 = get_global_mouse_position() - global_position
	var dir3 : Vector3 = Vector3(direction.x, direction.y, 0)
	
	muzzleflash.process_material.direction = dir3
	
	# emit particle
	muzzleflash.emitting = true
	
