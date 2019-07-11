extends KinematicBody2D

var player_pos : Vector2 # player pos
var height : int # how high
var distance : int # how far
var speed : float # how fast

enum states {THROW, FALL, CHAO}
var state = states.THROW
var move_vec : Vector2
var time : float = 0

const rot_speed : int = 10
var rot_dir : int = 1

var startpoint : Vector2
var midpoint : Vector2
var endpoint : Vector2

func _ready():
	startpoint = player_pos
	endpoint = player_pos + Vector2(distance, 0)
	midpoint = lerp(startpoint, endpoint, 0.5) + Vector2(0, -height)

func _physics_process(delta):
	if state == states.THROW:
		time += delta * (1 / speed)
		var next_position = lerp(lerp(startpoint, midpoint, time),
				lerp(midpoint, endpoint, time), time) # quadratic bezier
		move_vec = next_position - position
	elif state == states.FALL:
		var gravity = 0.25
		move_vec.y += gravity
	elif state == states.CHAO:
		time += delta
		if time > 2.0:
			self.queue_free()

	var collision = move_and_collide(move_vec)
	
	if collision and collision.normal != Vector2.UP:
		state = states.FALL
		rot_dir = -0.6
		move_vec = move_vec.bounce(collision.normal).normalized()
	elif collision:
		state = states.CHAO
		move_vec = Vector2.ZERO
		rot_dir = 0
		collision_mask = 0
		z_index = -1
		randomize()
		position += Vector2(0, rand_range(0, 10))
		time = 0
	
	rotation += rot_speed * rot_dir * delta


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
