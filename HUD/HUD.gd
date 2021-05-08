extends CanvasLayer


const PAUSE_SCREEN_SCENE = preload("res://HUD/PauseScreen.tscn")

var pauseScreen
var score = 0
onready var score_node = find_node("Score")

func _ready():
	update_score(score)

func update_score(point):
	score += point
	score_node.text = str(score)
	score_node.update()

func _process(delta):
	var paused 
	if Input.is_action_just_pressed("ui_cancel") :
		paused = not get_tree().paused
		if paused :
			pauseScreen = PAUSE_SCREEN_SCENE.instance()
			var screen_pos = -offset/2 - pauseScreen.get_node("BackGround").get_rect().size /2
			pauseScreen.position = Vector2(0,screen_pos.y)
			pauseScreen.connect("retryGame",get_parent(),"reload_scene")
			add_child(pauseScreen)
		else :
			pauseScreen.queue_free()
		get_tree().paused = paused
