extends Node

const ENNEMY_ASTEROID_SMALL = preload("res://characters/enemies/AsteroidSmall.tscn")
const ENNEMY_ASTEROID_MED_1 = preload("res://characters/enemies/AsteroidMed1.tscn")
const ENNEMY_ASTEROID_MED_2 = preload("res://characters/enemies/AsteroidMed2.tscn")
const ENNEMY_ASTEROID_LARGE = preload("res://characters/enemies/AsteroidLarge.tscn")
const ENNEMY_SHOOTING_ENEMY = preload("res://characters/enemies/ShootEnemy.tscn")

enum TYPE{ASTEROID,WAVE_ENNEMY,BLASTER_ENNEMY}

var timer
var score
onready var maxCooldownSpawner = 1.4

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"spawn")
	add_child(timer)
	
	randomize()
	
	spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().find_node("Score"):
		score = int(get_parent().find_node("Score").text)
		if score > 10000 :
			maxCooldownSpawner = 0.4
		elif score > 5000 :
			maxCooldownSpawner = 0.7
		elif score > 2500 :
			maxCooldownSpawner = 1.0

func spawn():
	var ennemy_random = randi()%10+1
	var ennemy_type
	match ennemy_random :
		2,8 :
			ennemy_type = TYPE.BLASTER_ENNEMY
		_ :
			ennemy_type = TYPE.ASTEROID
	var ennemy = choose_spawn_ennemy(ennemy_type)
	var ennemy_size = ennemy.get_node("Sprite").get_rect().size
	var spawning_pos = Vector2()
	spawning_pos.x = rand_range(0 + ennemy_size.x / 2, get_viewport().get_visible_rect().size.x - ennemy_size.x / 2) 
	spawning_pos.y =  -ennemy_size.y /2
	
	ennemy.position = spawning_pos
	$Container.add_child(ennemy)
	if get_parent().find_node("HUD") :
		ennemy.	connect("score_updated",get_parent().find_node("HUD"),"update_score")
	
	timer.set_wait_time(rand_range(0.3,maxCooldownSpawner))
	timer.start()
	
func choose_spawn_ennemy(type):
	match type:
		TYPE.ASTEROID:
			var type_asteroid = randi()%10+1
			match type_asteroid:
				1,2:
					return ENNEMY_ASTEROID_SMALL.instance()
				3,4,5 :
					return ENNEMY_ASTEROID_MED_1.instance()
				6,7,8 :
					return ENNEMY_ASTEROID_MED_2.instance()
				9,10:
					return ENNEMY_ASTEROID_SMALL.instance() 
		TYPE.BLASTER_ENNEMY :
			return ENNEMY_SHOOTING_ENEMY.instance()

