extends CanvasLayer

@export var timer : Timer
@onready var timelabel : Label = $Control/Panel/Label

func translate_time() -> String:
	var minutes : int = int(timer.time_left / 60)
	var seconds : int = fmod(timer.time_left, 60)
	
	var output : String 
	if seconds < 10:
		output = "%d:0%d" % [minutes, seconds]
	else:
		output = "%d:%d" % [minutes, seconds]
	return output
	
func _physics_process(delta):

	timelabel.text = translate_time()
