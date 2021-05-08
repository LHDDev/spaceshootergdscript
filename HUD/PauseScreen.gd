extends Node2D

const MAX_EXPANSION = 1.25
const MIN_EXPANSION = 1

var expansion = 1
var expanding = true
var timer
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
	
	$lbl_pause.rect_scale = Vector2(expansion ,expansion)

func _on_retry_pressed() :
	print("reloading...")
	emit_signal("retryGame")

func _on_quit_pressed():
	pass
