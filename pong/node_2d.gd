extends Node2D

# member variables
var screen_size
var l_pad_size
var r_pad_size
var direction = Vector2(1.0, 0.0)

const INITIAL_BALL_SPEED = 80
var ball_speed = INITIAL_BALL_SPEED
const PAD_SPEED = 150
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	l_pad_size = get_node("LeftPallete").get_texture().get_size()
	r_pad_size = get_node("RightPallete").get_texture().get_size()
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ball_pos = get_node("Ball").position
	var left_rect = Rect2(get_node("LeftPallete").position - l_pad_size *0.5, l_pad_size)
	var right_rect = Rect2(get_node("RightPallete").position - r_pad_size *0.5, r_pad_size)
	
	ball_pos += direction * ball_speed * delta
	
	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
		
	if ((left_rect.has_point(ball_pos) and direction.x < 0) or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf()*2.0-1
		direction = direction.normalized()
		ball_speed *= 1.1
		
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		ball_pos = screen_size*0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
		
	get_node("Ball").position = ball_pos
	
	var left_pos = get_node("LeftPallete").position
	
	if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta
	get_node("LeftPallete").position = left_pos
	
	var right_pos = get_node("RightPallete").position
	
	if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -PAD_SPEED * delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += PAD_SPEED * delta
	get_node("RightPallete").position = right_pos
