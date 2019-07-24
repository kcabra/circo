extends Node2D

var vp : Viewport
var player : Node2D
var screen_size : Vector2
var scalling_factor : int

func _ready():
	vp = get_viewport()
	player = get_parent()
	screen_size = Vector2(190, 95)
	scalling_factor = 2
# warning-ignore:return_value_discarded
	vp.connect("size_changed", self, "on_vp_size_changed")

func on_vp_size_changed():
	var ratio = OS.window_size / screen_size
# warning-ignore:narrowing_conversion
	scalling_factor = floor(min(ratio.x, ratio.y))
	refresh_scale()

func _process(_delta):
	var canvas_transform = Transform2D()
	canvas_transform.origin.x = -player.position.x + vp.size.x / (2 * scalling_factor)
	canvas_transform = canvas_transform.scaled(Vector2.ONE * scalling_factor)
	vp.canvas_transform = canvas_transform

	if Input.is_action_just_pressed("ui_page_up"):
		scalling_factor += 1
	elif Input.is_action_just_pressed("ui_page_down"):
		scalling_factor -= 1
	refresh_scale()

func refresh_scale():
	if scalling_factor < 1: scalling_factor = 1
	OS.window_size = screen_size * scalling_factor
