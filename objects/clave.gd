extends KinematicBody2D

var player_pos : Vector2 # player pos
var target_pos : Vector2 # target pos
var height : int # how high
var speed : float # how fast

enum states {IDA, VOLTA, CHAO}
var state = states.IDA

var rot_speed : int = 10
var rot_dir : int = 1

var startpoint : Vector2
var midpoint : Vector2
var endpoint : Vector2

func _ready():
	startpoint = player_pos
	endpoint = target_pos
	midpoint = lerp(player_pos, target_pos, 0.5) + Vector2(0, -height)
	$lifetime.wait_time = speed
	$lifetime.start()

func _physics_process(delta):
	var time = ($lifetime.wait_time - $lifetime.time_left) / $lifetime.wait_time
	if state == states.IDA or state == states.VOLTA:
		var next_position = quadratic_bezier(startpoint, midpoint, endpoint, time)
		var collision = move_and_collide(next_position - position)
		print(collision)
	
	rotation += rot_speed * rot_dir * delta

func quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
    var q0 = p0.linear_interpolate(p1, t)
    var q1 = p1.linear_interpolate(p2, t)

    var r = q0.linear_interpolate(q1, t)
    return r


func _on_lifetime_timeout():
	if state == states.IDA:
		state = states.VOLTA
		rot_dir = -1
		startpoint = position
		endpoint = player_pos
		$lifetime.start()
	elif state == states.VOLTA:
		state = states.CHAO
		rot_dir = 0
		$lifetime.wait_time = $lifetime.wait_time * 2
		$lifetime.start()
	else:
		self.queue_free()
