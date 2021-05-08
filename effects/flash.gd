extends ColorRect



# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fadeout")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
