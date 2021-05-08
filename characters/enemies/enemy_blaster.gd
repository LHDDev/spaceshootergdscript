extends "res://characters/player/Blaster.gd"



# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy_blaster")
	scale.y = -1

func _on_body_entered(other):
	if other.is_in_group("player"):
		other.hp -= 1
		create_explosion()
		queue_free()
