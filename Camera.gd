extends Camera2D

var magnitude = 0.0
var timeLeft = 0
var is_shaking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func shake(new_magnitude, lifetime):
	
	if magnitude > new_magnitude :
		return
	
	magnitude = new_magnitude
	timeLeft = lifetime
	
	if is_shaking :
		return
		
	is_shaking = true
	
	while timeLeft > 0 :
		var pos = Vector2()
		pos.x = rand_range(-magnitude, magnitude)
		pos.y = rand_range(-magnitude, magnitude)
		position = pos
		
		timeLeft -= get_process_delta_time()
		yield(get_tree(),"idle_frame")
	
	is_shaking = false
	magnitude = 0
	position = Vector2(0,0)
