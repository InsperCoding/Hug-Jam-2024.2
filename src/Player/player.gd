extends CharacterBody2D

@onready var globals = get_node("/root/Globals")
const NORMAL_SPEED : int = 300
const SLOW_SPEED : int = 150
const SLOW_DOWN_DURATION : float = 5.0 # Duração da lentidão em segundos
var SPEED : int = NORMAL_SPEED
signal shoot()
signal pickup(body : StaticBody2D)

@onready var slow_down_timer : Timer = $SlowDownTimer

var penalidades = [] # Lista de penalidades aplicadas

func _ready() -> void:
	slow_down_timer = $SlowDownTimer
	if slow_down_timer:
		slow_down_timer.connect("timeout", Callable(self, "_on_slow_down_timeout"))
	else:
		print("Erro: SlowDownTimer não encontrado!")

func handle_inventory() -> void:
	for i in range($Inventory.get_child_count()):
		if i == globals.inventory_idx:
			$Inventory.get_child(i).visible = true
		else:
			$Inventory.get_child(i).visible = false

func get_input():
	var input_direction : Vector2 = Input.get_vector("left", "right", "up", "down")
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
		trocar_teclas_temporariamente()
	elif Input.is_action_just_pressed("penalty3"):
		aplicar_spawn_policia()

# PENALIDADE 1 (TECLA U)
func aplicar_lentidao():
	if "lentidao" not in penalidades:
		penalidades.append("lentidao")
		SPEED = SLOW_SPEED
		if slow_down_timer:
			slow_down_timer.start(SLOW_DOWN_DURATION)
		else:
			print("Erro: SlowDownTimer não encontrado!")
		print("Lentidão aplicada!")

func _on_slow_down_timeout() -> void:
	if "lentidao" in penalidades:
		penalidades.erase("lentidao")
		SPEED = NORMAL_SPEED
		print("Lentidão removida!")

# PENALIDADE 2
func trocar_teclas_temporariamente():
	if "trocar_teclas" not in penalidades:
		penalidades.append("trocar_teclas")
		print("Teclas trocadas temporariamente!")

# PENALIDADE 3
func aplicar_spawn_policia():
	if "spawn_policia" not in penalidades:
		penalidades.append("spawn_policia")
		print("Spawn de polícia aplicado!")
