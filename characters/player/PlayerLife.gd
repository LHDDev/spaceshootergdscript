extends Node2D

var spriteLife = preload("res://characters/player/sprites/Player.png")
onready var main_game = get_owner()

# Called when the node enters the scene tree for the first time.
func _ready():
	for comp in range(3):
		var life = Sprite.new()
		life.texture = spriteLife
		life.position += Vector2(comp * (spriteLife.get_width()+2) ,0)
		self.add_child(life)


func updateLife(nbOfLife):
	for s in get_children():
		remove_child(s)
	
	for comp in range(nbOfLife):
		var life = Sprite.new()
		life.texture = spriteLife
		life.position += Vector2(comp * (spriteLife.get_width()+2) ,0)
		self.add_child(life)
