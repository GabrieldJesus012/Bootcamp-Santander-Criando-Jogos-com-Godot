extends CharacterBody2D

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite:Sprite2D = $Sprite2D
@onready var sword_area: Area2D =$SwordArea

@export var speed: float = 3
@export var sword_damage: int = 2

#Variaveis
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float =0.0
var input_vector: Vector2 = Vector2(0,0)

#Funcoes:

func _process(delta:float) -> void:
	GameManager.player_position = position
	
	ready_input()
	
	#Processar ataque
	uptade_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"): #A gente acabou de atacar?
		attack()
		
	#processar animação e rotação de sprite
	play_run_iddle_animation()
	if not is_attacking:
		rotate_sprite()

func _physics_process(delta:float) -> void:
	#modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp (velocity,target_velocity,0.05)
	move_and_slide()

func uptade_attack_cooldown(delta:float)->void:
	if is_attacking:
		attack_cooldown -=delta #0.6 - 0.016
		if attack_cooldown<=0.0:
			is_attacking = false
			is_running = false
			animation_player.play("Idle")

func ready_input() -> void:
	#obter o input vector
	input_vector= Input.get_vector("move_left","move_right","move_up","move_down")
	
	#Apagar deadzone do Input Vector
	var deadzone = 0.15
	if abs(input_vector.x)<0.15:
		input_vector.x = 0.0
	if abs(input_vector.y)<0.15:
		input_vector.y = 0.0
		
	#atualizar o is running
	was_running = is_running
	is_running= not input_vector.is_zero_approx() #checar se o valor é zero (se nao é 0 ta correndo)

func play_run_iddle_animation() -> void:
	#Tocar animação
	if not is_attacking:
		if was_running != is_running: 
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("Idle")

func rotate_sprite()->void:
	#girar sprite
	if input_vector.x>0:
		sprite.flip_h= false
		#desmarcar flip H
	elif input_vector.x<0:
		sprite.flip_h= true
		#marcar flip H

func attack() -> void:
	#attack_side_1 e #attack_side_2 (as animações que criamos)
	if is_attacking:
		return
		
	#tocar a animação
	animation_player.play("attack_side_1")
	attack_cooldown= 0.6
	
	# Marcar ataque
	is_attacking = true
	

func deal_damage_to_enemies() -> void:
	var bodies= sword_area.get_overlapping_bodies() #pegar todos os corpos fisicos da area
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			#calcular direção do inimigo para personagem
			var direction_to_enemy=(enemy.position-position).normalized()  #normalized= 1 de comprimento
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >=0.3:
				enemy.damage(sword_damage)
	
	






