extends "res://characters/player/Blaster.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered",self,"_on_body_entered")

func _on_body_entered(other):
	if other.is_in_group("enemy"):
		other.hp -= 1
		emit_signal("shakeCamera",magnitudeExplosion,lifetimeExplosion)
		create_explosion()
		queue_free()
