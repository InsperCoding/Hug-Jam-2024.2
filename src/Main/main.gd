extends Node2D

# Dicionário com frases
var frases = {
	0: "Regue a árvore.",
	1: "Ajude a idosa.",
	2: "Limpar uma parede.",
	3: "Dê uma flor para o ornitorrinco.",
	4: "Dê a arma para o policial."
}

# Label para exibir a frase
@onready var frase_label = $UI/GridContainer/Panel2/Label

func _ready():
	# Chama a função para atualizar a frase quando a cena for iniciada
	atualiza_frase()

# Função para gerar um índice aleatório e atualizar o Label
func atualiza_frase():
	var indice_aleatorio = randi() % frases.size()
	frase_label.text = frases[indice_aleatorio]

# Exemplo de função que seria chamada quando o jogador cumprir um objetivo
func objetivo_cumprido():
	atualiza_frase()
