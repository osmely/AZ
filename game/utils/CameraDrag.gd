extends Node2D

var camera = null
var status = "none"
var startPos = Vector2()
var offset = Vector2()

export var zoom = Vector2(1,1) setget set_zoom, get_zoom

func _ready():
	camera = get_node("Camera")

	set_zoom(self.zoom)
	
	set_process_input(true)
	set_process(true)

func get_camera_offset():
	return camera.get_offset()

func get_camera_zoom():
	return camera.get_zoom()
	
func get_zoom():
	if camera != null:
		return camera.zoom
	return Vector2()
	
func set_zoom(z):
	if camera != null:
		camera.set_zoom(z)
	

func _process(delta):
	var current = camera.offset
	var x = lerp(current.x, offset.x, 0.1) 
	var y = lerp(current.y, offset.y, 0.1) 
	camera.set_offset(Vector2(x, y))
		

func _input(ev):
	if ev is InputEventMouseMotion:
		if status == "pressed":
			startPos = get_global_mouse_position()
			offset = Vector2()
			status = "dragging"
			
	if ev is InputEventMouseButton:
		if ev.is_pressed():
			status = "pressed"
		else:
			status = "released"

	if status == "dragging":
		var of = get_global_mouse_position() - startPos
		offset = camera.get_offset() - of
		
		var maxTop = camera.get_limit(MARGIN_TOP)
		if offset.y < maxTop:
			offset.y = maxTop

		var maxL = camera.get_limit(MARGIN_LEFT)
		if offset.x < maxL:
			offset.x = maxL

		var s = get_tree().get_root().get_visible_rect().size
		var maxBottom = camera.get_limit(MARGIN_BOTTOM)
		if (s.y + offset.y) > maxBottom:
			offset.y = maxBottom - s.y

		var maxR = camera.get_limit(MARGIN_RIGHT)
		if (s.x + offset.x) > maxR:
			offset.x = maxR - s.x
			
			

