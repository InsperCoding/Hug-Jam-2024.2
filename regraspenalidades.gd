extends Node

# Regras
var regras = [
	"Fonte", #Jogar sujeira no rio/fonte ao invés de limpar
	"Árvore", #Jogar gasolina no lugar de regar a árvore
	"Personagem" #Matar uma personagem ao invés de interagir positivamente
]

# Penalidades
var penalidades = [
	"Spawn de Polícia",
	"Lentidão",
	"Maior tempo de recarga",
	"Inversão de teclas"
]

# Penalidades ativas
var penalidade_ativa = null

func quebrar_regra(index):
	print("Regra quebrada: " + regras[index])
	aplicar_penalidade()

func aplicar_penalidade():
	var penalidade_possivel = []
	
	for penalidade in penalidades:
		if penalidade != penalidade_ativa:
			penalidade_possivel.append(penalidade)
	
	var nova_penalidade = penalidade_possivel[randi() % penalidade_possivel.size()]
	
	penalidade_ativa = nova_penalidade
	print("Nova penalidade aplicada: " + penalidade_ativa)
	
	match penalidade_ativa:
		"Spawn de Polícia":
			spawn_policia()
		"Lentidão":
			aplicar_lentidao()
		"Maior tempo de recarga":
			aumentar_tempo_recarga()
		"Inversão de teclas":
			inversao_teclas()

func spawn_policia():
	# Não tem a polícia ainda
	pass

var original_speed = 200  
var penalized_speed = 100

func aplicar_lentidao():
	if $Player.speed != penalized_speed:
		$Player.speed = penalized_speed
		print("Lentidão aplicada: velocidade reduzida para ", penalized_speed)

var original_reload_time = 1.0  
var penalized_reload_time = 2.0

func aumentar_tempo_recarga():
	if $Player.weapon.reload_time != penalized_reload_time:
		$Player.weapon.reload_time = penalized_reload_time
		print("Tempo de recarga aumentado para ", penalized_reload_time, " segundos")

var key_swap_duration = 30.0 

func inversao_teclas() -> void:
	
	# Aplicar Inversão
	InputMap.action_erase_events("move_up")
	InputMap.action_erase_events("move_down")
	InputMap.action_erase_events("move_left")
	InputMap.action_erase_events("move_right")

	var up_event = InputEventKey.new()
	up_event.physical_scancode = KEY_S

	var down_event = InputEventKey.new()
	down_event.physical_scancode = KEY_W

	var left_event = InputEventKey.new()
	left_event.physical_scancode = KEY_D

	var right_event = InputEventKey.new()
	right_event.physical_scancode = KEY_A

	InputMap.action_add_event("move_up", up_event)
	InputMap.action_add_event("move_down", down_event)
	InputMap.action_add_event("move_left", left_event)
	InputMap.action_add_event("move_right", right_event)

	await get_tree().create_timer(key_swap_duration).timeout
	
	# Restaurar teclas
	InputMap.action_erase_events("move_up")
	InputMap.action_erase_events("move_down")
	InputMap.action_erase_events("move_left")
	InputMap.action_erase_events("move_right")

	var original_up_event = InputEventKey.new()
	original_up_event.physical_scancode = KEY_W

	var original_down_event = InputEventKey.new()
	original_down_event.physical_scancode = KEY_S

	var original_left_event = InputEventKey.new()
	original_left_event.physical_scancode = KEY_A

	var original_right_event = InputEventKey.new()
	original_right_event.physical_scancode = KEY_D

	InputMap.action_add_event("move_up", original_up_event)
	InputMap.action_add_event("move_down", original_down_event)
	InputMap.action_add_event("move_left", original_left_event)
	InputMap.action_add_event("move_right", original_right_event)
