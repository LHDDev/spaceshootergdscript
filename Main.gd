extends Node2D

const files_sfx = {
	"Theme_1":preload("res://sounds/music/Intergalactic Odyssey.ogg"),
	"Theme_2":preload("res://sounds/music/Interstellar Odyssey.ogg")
}
const GAME_OVER_SCREEN = preload("res://HUD/GameOver.tscn")
var window_size

func _ready():
	randomize()
	window_size  = get_viewport_rect().size
	window_size = Vector2(window_size.x,window_size.y-40)
	var theme_rand = randi()%10+1
	var theme
	match theme_rand:
		1,8,10 :
			theme = files_sfx["Theme_2"]
		_:
			theme = files_sfx["Theme_1"]
	$Music.stream = theme
	$Music.play()
	
	
func gameOver():
	var gameOverScreen = GAME_OVER_SCREEN.instance()
	gameOverScreen.score = $HUD.score
	gameOverScreen.connect("retryGame",self,"reload_scene")
	add_child(gameOverScreen)
	$HUD.queue_free()

func shake_camera(magnitude,lifetime):
	$Camera.shake(magnitude,lifetime)

func reload_scene():
	print("reloaded")
	get_tree().paused = false
	get_tree().reload_current_scene()
