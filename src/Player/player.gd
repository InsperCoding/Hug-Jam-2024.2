extends CharacterBody2D

@onready var globals = get_node("/root/Globals")
const NORMAL_SPEED : int = 300
const SLOW_DOWN_DURATION : float = 10.0 
var SPEED : int = NORMAL_SPEED
signal shoot()
signal pickup(body : StaticBody2D)
signal isPolite
signal hit

@onready var slow_down_timer : Timer = $SlowDownTimer
@onready var key_swap_timer : Timer = $KeySwapTimer

@export var penalidades = [] 

var regras = [
	"Fonte", #Jogar sujeira no rio/fonte ao invés de limpar
	"Árvore", #Jogar gasolina no lugar de regar a árvore
	"Personagem" #Matar uma personagem ao invés de interagir positivamente
]

func _ready() -> void:
	if slow_down_timer:
		slow_down_timer.connect("timeout", Callable(self, "_on_slow_down_timeout"))
	else:
		print("Erro: SlowDownTimer não encontrado!")
	if key_swap_timer:
		key_swap_timer.connect("timeout", Callable(self, "_on_key_swap_timeout"))
	else:
		print("Erro: KeySwapTimer não encontrado!")

func handle_inventory() -> void:
	for i in range($Inventory.get_child_count()):
		if i == globals.inventory_idx:
			$Inventory.get_child(i).visible = true
		else:
			$Inventory.get_child(i).visible = false

func get_input():
	var input_direction : Vector2
	if "trocar_teclas" in penalidades:
		input_direction = Input.get_vector("right", "left", "down", "up")
	else:
		input_direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = input_direction * SPEED

	if Input.is_action_just_pressed("mouseleft"):
		emit_signal("shoot")

func _physics_process(delta):
	handle_inventory()
	get_input()
	move_and_slide() 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for body in $InteractionArea.get_overlapping_bodies():
			if body in get_children():
				continue
			if "Item" in body.name:
				emit_signal("pickup", body)
				break
	
	if Input.is_action_just_pressed("penalty1"):
		aplicar_lentidao()
	elif Input.is_action_just_pressed("penalty2"):
		alterar_teclas()
	elif Input.is_action_just_pressed("penalty3"):
		aplicar_spawn_policia()

# PENALIDADE 1 (TECLA U)
func aplicar_lentidao():
	if "lentidao" not in penalidades:
		penalidades.append("lentidao")
		SPEED = SPEED * 0.7
		if slow_down_timer:
			slow_down_timer.start(SLOW_DOWN_DURATION)

func _on_slow_down_timeout() -> void:
	if "lentidao" in penalidades:
		penalidades.erase("lentidao")
		SPEED = NORMAL_SPEED

# PENALIDADE 2 (TECLA I)
func alterar_teclas():
	if "trocar_teclas" not in penalidades:
		penalidades.append("trocar_teclas")
		if key_swap_timer:
			key_swap_timer.start(SLOW_DOWN_DURATION)

func _on_key_swap_timeout() -> void:
	if "trocar_teclas" in penalidades:
		penalidades.erase("trocar_teclas")

# PENALIDADE 3
func aplicar_spawn_policia():
	if "spawn_policia" not in penalidades:
		penalidades.append("spawn_policia")
		#var new_police = Policia.instantiate()
		var posx = randf_range(0,1152)
		var posy = randf_range(0,648)
		#new_police.position = 
		#add_child(new_police)
		print("Spawn de polícia aplicado!")
		

func is_polite():
	pass


func _on_hitbox_randomize_punishment():
	var rng = randf_range(1,3)
	if rng == 1:
		aplicar_lentidao()
		_on_slow_down_timeout()
	elif rng == 2:
		alterar_teclas()
		_on_key_swap_timeout()
	else:
		aplicar_spawn_policia()
