extends KinematicBody2D

var move_vec : Vector2
var speed = 100
var jump = -220
var gravity = 10
var timer_gnd = 0
var timer_but = 0

var face_dir : bool
const LEFT = true
const RIGHT = false

func _physics_process(delta):
	# move
	if Input.is_action_pressed("game_right"):
		move_vec.x = speed
		face_dir = RIGHT
	elif Input.is_action_pressed("game_left"):
		move_vec.x = -speed
		face_dir = LEFT
	else:
		move_vec.x = 0
	
	# jump
	if !is_on_floor():
		move_vec.y += gravity
	
	timer_gnd -= delta
	timer_but -= delta
	
	if is_on_floor():
		timer_gnd = 0.25
	if Input.is_action_just_pressed("game_jump"):
		timer_but = 0.25
	
	if (timer_but > 0) and (timer_gnd > 0):
		move_vec.y = jump
		timer_but = 0
		timer_gnd = 0
	
	# clave
	if Input.is_action_just_pressed("game_attack"):
		spawn_clave()
	
	# actual movement
	move_vec = move_and_slide(move_vec, Vector2.UP)


func _process(delta):
	sprite()


func sprite():
	var sprite = $char_sprite
	sprite.flip_h = face_dir
	if move_vec.x != 0:
		sprite.animation = "walk"
	else:
		sprite.animation = "still"


func spawn_clave():
	var clave = load("res://objects/clave.tscn").instance()
	clave.player_pos = self.position
	clave.position = self.position
	var distance
	var height
	if Input.is_action_pressed("game_up"):
		distance = 0
		height = 150
	else:
		height = 100
		if face_dir == LEFT:
			distance = -150
		else:
			distance = 150
	clave.distance = distance
	clave.height = height
	clave.speed = 1.0
	$"..".add_child(clave)

