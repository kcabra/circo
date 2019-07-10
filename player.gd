extends KinematicBody2D

var move_vec : Vector2
var speed = 200
var jump = -500
var gravity = 20

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		move_vec.x = speed
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		move_vec.x = -speed
		$Sprite.flip_h = true
	else:
		move_vec.x = 0
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		move_vec.y += jump
	if !is_on_floor():
		move_vec.y += gravity
	
	if Input.is_action_just_pressed("ui_accept"):
		spawn_clave()
	
	move_vec = move_and_slide(move_vec, Vector2.UP)

func spawn_clave():
	var clave = load("res://clave.tscn").instance()
	clave.player_pos = self.position
	clave.position = self.position
	var target = 0
	if $Sprite.flip_h:
		target = -300
	else:
		target = 300
	clave.target_pos = self.position + Vector2(target, 0)
	clave.height = 200
	clave.speed = 1.0
	$"..".add_child(clave)
