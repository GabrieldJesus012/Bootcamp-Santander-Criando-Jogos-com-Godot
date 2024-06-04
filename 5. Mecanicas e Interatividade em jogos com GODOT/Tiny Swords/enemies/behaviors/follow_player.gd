extends CharacterBody2D

@export var speed= 1.0

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta:float) -> void:
	#calcular direção
	var player_position = GameManager.player_position
	var difference = (player_position - position)
	var input_vector = difference.normalized()
	
	#movimento
	velocity= input_vector * speed * 100.0
	move_and_slide()
	
	#Girar Sprite
	if input_vector.x>0:
		sprite.flip_h= false
		#desmarcar flip H
	elif input_vector.x<0:
		sprite.flip_h= true
		#marcar flip H
