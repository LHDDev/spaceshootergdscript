extends CanvasLayer

const MAX_EXPANSION = 1.25
const MIN_EXPANSION = 1

var score = 0 setget set_score
var expansion = 1
var expanding = true

signal retryGame

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	expand()

func expand():
	if expanding :
		expansion += 0.015
	else :
		expansion -= 0.015
	
	if expansion >= MAX_EXPANSION :
		expanding = false
	elif expansion	<= MIN_EXPANSION :
		expanding = true
		
	$ColorRect/lblGameOver.rect_scale = Vector2(expansion ,expansion)

func set_score(new_score):
	score = new_score
	$Score/ScorePlayer.text = str(score)


func _on_RetryButton_button_up():
	emit_signal("retryGame")
