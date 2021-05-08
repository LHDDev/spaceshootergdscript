extends "res://characters/enemies/Ennemy.gd"


const BLASTER = preload("res://characters/enemies/enemy_blaster.tscn")

enum{IDLE,MOVE,SHOOT,HIT,DIE}

var player
var can_shoot = false
var state

onready var cannon = $Cannon
onready var cooldown = $CoolDown


# Called when the node enters the scene tree for the first time.
func _ready():
#	player = get_tree().get_root().get_node("Game").find_node("Player")
	velocity.x = choose([-velocity.x,velocity.y])
	state = IDLE
	animation_loop("SETUP")
	
	cooldown.set_wait_time(1)
	cooldown.start()
	yield(cooldown,"timeout")
	can_shoot = true
	
func _process(delta):
	
	translate(velocity*delta)
	
	if position.x + $Sprite.get_rect().size.x /2 >= get_viewport_rect().size.x :
		velocity.x = -velocity.x
	if position.x - $Sprite.get_rect().size.x /2 <= 0 :
		velocity.x = abs(velocity.x)
	
	if position.y - $Sprite.get_rect().size.y /2 >= get_viewport_rect().size.y :
		queue_free()
	
	if $RayCast.is_colliding() :
		if can_shoot :
			shoot()
		

func changeState(newState):
	state = newState
	
	match state :
		IDLE :
			animation_loop("idle")
		MOVE :
			$Sprite.scale.x = sign(velocity.x) * -1
			animation_loop('move')
		SHOOT:
			shoot()

func shoot():
	can_shoot = false
	var b_left = BLASTER.instance()
	b_left.position = cannon.global_position
	
	get_parent().add_child(b_left)
	
	cooldown.set_wait_time(0.8)
	cooldown.start()
	
	yield(cooldown,"timeout")
	
	can_shoot = true

func choose(choises):
	var rand_index = randi() % choises.size()
	return choises[rand_index]

func animation_loop(animation):
	if $Animation.current_animation != animation :
		$Animation.play(animation)
