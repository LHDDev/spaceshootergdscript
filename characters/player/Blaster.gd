extends Area2D

const EXPLOSION = preload("res://effects/Explosion.tscn")
export var velocity = Vector2()
export(float) var magnitudeExplosion
export(float) var lifetimeExplosion

signal shakeCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("shakeCamera",get_tree().get_root().get_node("Game"),"shake_camera")
	
	$SFX.play()
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(velocity * delta)
	yield($vis_notifier,"screen_exited")
	queue_free()

func create_explosion():
	var explo = EXPLOSION.instance()
	explo.position = position
	get_parent().add_child(explo)
	
