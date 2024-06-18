extends CanvasLayer

@onready var time_label = %TimeLabel
@onready var gold_label = %GoldLabel
@onready var Neet_label = %MeetLabel

var time_elapsed: float= 0.0

func _process(delta:float):
	time_elapsed +=delta
	#floor arredonda para baixo
	#round arredonda ou para baixo ou para cima
	#ceil arredonda para cima
	var time_elapsed_in_second: int = floori(time_elapsed)
	var second: int = time_elapsed_in_second % 60
	var minutes: int = time_elapsed_in_second /60
	
	# - % formatar algo - d digito - 02 2 digitos e : da hora ex: 03:20 
	
	time_label.text = "%02d:%02d"  % [minutes, second]
