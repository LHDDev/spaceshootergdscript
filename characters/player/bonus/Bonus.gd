extends Node2D


enum TYPE{HEALTH,SHIELD}
export(Vector2) var velocity


var type
# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = randi()%100+1
	if rng in range(1,25):
		type = TYPE.SHIELD
	else :
		type = TYPE.HEALTH
	set_sprite()

func _process(delta):
	translate(velocity * delta)

func set_sprite() :
	match type :
		TYPE.HEALTH :
			$Sprite.texture = load("res://characters/player/bonus/sprites/Powerup_Health_png_processed.png")
			add_to_group("health_bonus")
		TYPE.SHIELD :
			$Sprite.texture = load("res://characters/player/bonus/sprites/Powerup_Shields_png_processed.png")
			add_to_group("shield_bonus")
