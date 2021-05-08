extends KinematicBody2D

const BLASTER = preload("res://characters/player/player_blaster.tscn")
const EXPLOSION = preload("res://effects/Explosion.tscn")
const FLASH = preload("res://effects/flash.tscn")

const LIFE_MAX = 5
const SPEED = 200
const ACCELERATION = 25
const SHIELD_MAX = 4

enum{IDLE,MOVE,SHOOT,HIT,DIE}

var life = 0 setget set_life
var motion = Vector2.ZERO
var state
var dir_inputs = Vector2.ZERO
var can_shoot = true
var friction = 0.02
var shield = 0

export(float) var magnitudeExplosion
export(float) var lifetimeExplosion

onready var sprite_size = $Sprite.get_rect().size 
onready var main_game = get_owner()
onready var cooldown  = $Cooldown
onready var buster_left = $BusterLeft
onready var buster_right = $BusterRight


signal shakeCamera
signal updateHUDLife
signal stopSpawn
signal stopGame
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_loop("SETUP")
	
	connect("updateHUDLife",get_parent().find_node("PlayerLife"),"updateLife")
	connect("stopSpawn",get_parent().find_node("Spawner"),"stopSpawn")
	connect("stopGame",get_parent(),"gameOver")
	connect("shakeCamera",get_parent(),"shake_camera")
	
	add_to_group("player")
	life = 3
	state = IDLE
	position = Vector2(get_viewport_rect().size.x / 2,get_viewport_rect().size.y - sprite_size.y-20)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stateLoop()
	move()
	move_and_slide(motion)
	
func move():
	dir_inputs.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir_inputs.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if (position.y +(sprite_size.y/2)) >= main_game.window_size.y && dir_inputs.y >= 0 :
		dir_inputs.y = 0
		position.y = main_game.window_size.y - sprite_size.y/2
	elif (position.y -(sprite_size.y/2)) <= 0 && dir_inputs.y <= 0 :
		dir_inputs.y = 0
		position.y = sprite_size.y/2
	elif dir_inputs.y == 0 :
		motion.y = lerp(motion.y,0,friction)
	else :
		motion.y = dir_inputs.y * SPEED
		
	if (position.x -(sprite_size.x/2)) <= 0 && dir_inputs.x  <= 0 :
		dir_inputs.x  = 0
		position.x = sprite_size.x/2
	elif (position.x +(sprite_size.x/2)) >= main_game.window_size.x && dir_inputs.x  >= 0 :
		dir_inputs.x  = 0
		position.x = main_game.window_size.x - sprite_size.x/2
	elif dir_inputs.x  == 0 :
		motion.x = lerp(motion.x,0,friction)
	else :
		motion.x = dir_inputs.x *SPEED
	
	print(motion.x)

func stateLoop():
	if state in [IDLE,SHOOT] and dir_inputs.x != 0 :
		changeState(MOVE)
	if state in [MOVE,SHOOT] and dir_inputs.x == 0  :
		changeState(IDLE)
	if can_shoot and Input.is_action_pressed("ui_accept"):
		changeState(SHOOT)

func changeState(newState):
	state = newState
	match state :
		IDLE :
			animation_loop("idle")
			pass
		MOVE :
			$Sprite.scale.x = sign(motion.x)*-1
			animation_loop('move')
		SHOOT:
			
			can_shoot = false
			var b_left = BLASTER.instance()
			b_left.position = buster_left.global_position
			var b_right = BLASTER.instance()
			b_right.position = buster_right.global_position
			
			get_parent().add_child(b_left)
			get_parent().add_child(b_right)
			
			cooldown.set_wait_time(0.3)
			cooldown.start()
			
			yield(cooldown,"timeout")
			
			can_shoot = true

func animation_loop(animation):
	if $Animation.current_animation != animation :
		$Animation.play(animation)

func set_life(new_value):
	if new_value < life:
		get_parent().add_child(FLASH.instance())
		
	if new_value < LIFE_MAX :
		life = new_value
	
	emit_signal("updateHUDLife",life)
	if life<=0 :
		emit_signal("stopGame")
		queue_free()

func set_shield(new_value):
	if shield < SHIELD_MAX :
		shield = new_value

func _on_hitbox_entered(area):
	if area.is_in_group("enemy") or area.is_in_group("enemy_blaster") :
		area.create_explosion()
		area.queue_free()
		emit_signal("shakeCamera",magnitudeExplosion,lifetimeExplosion)
		if shield > 0 :
			set_shield(shield -1)
		else :
			set_life(life-1)
		return
		
	if area.is_in_group("health_bonus") :
		set_life(life+1)
		area.queue_free()
		return
		
	if area.is_in_group("shield_bonus") :
		set_shield(shield+1)
		area.queue_free()
		return
