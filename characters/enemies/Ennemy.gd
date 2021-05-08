extends Area2D

const EXPLOSION = preload("res://effects/Explosion.tscn")
const BONUS = preload("res://characters/player/bonus/Bonus.tscn")

export (Vector2) var velocity = Vector2.ZERO
export(bool) var rotate = false
export(int) var hp = 2 setget set_hp
export(int) var score = 100

signal score_updated
# Called when the node enters the scene tree for the first time.
func _ready():
#	connect("body_entered",self,"_on_body_entered")
	
	
	add_to_group("enemy")
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(velocity * delta)
	if rotate :
		rotation_degrees += 1
	
	if position.y - $Sprite.get_rect().size.y /2 >= get_viewport_rect().size.y :
		queue_free()

func set_hp(new_value):
	hp = new_value
	if hp<=0 :
		emit_signal("score_updated",score)
		var bonus_rand = randi()%100 + 1
		if bonus_rand in range(1,10) :
			create_bonus()
		queue_free()

func create_explosion():
	var explo = EXPLOSION.instance()
	explo.position = position
	get_parent().add_child(explo)

func create_bonus() :
	var bonus = BONUS.instance()
	bonus.position = position
	get_tree().get_root().get_node("Game").call_deferred("add_child",bonus)
