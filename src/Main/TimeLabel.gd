extends CanvasLayer

@export var timer : Timer
@onready var timelabel : Label = $Control/TimerContainer/Timer

# translate timer to a string of minutes and seconds
func translate_time() -> String:
	var minutes : int = int(timer.time_left / 60)
	var seconds : int = fmod(timer.time_left, 60)
	
	var output : String 
	if seconds < 10:
		output = "%d:0%d" % [minutes, seconds]
	else:
		output = "%d:%d" % [minutes, seconds]
	return output
	
# capped at 60fps
func _physics_process(delta):
	timelabel.text = translate_time()

# not capped, so I used this one to draw fps
func _process(delta: float) -> void:
	$Control/FPSContainer/FPS.text = str(int(1/delta))
