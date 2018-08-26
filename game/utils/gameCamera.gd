extends Camera2D

var status = "none"
var startPos = Vector2()
var m_offset = Vector2()
 

func _ready():
	set_process_input(true)
	set_process(true)
	set_camera_limits()
	pass

func set_camera_limits():
	var ground = get_parent().get_node("Ground")
	var map_limits = ground.get_used_rect()
	var map_cellsize = ground.cell_size
	self.limit_left = map_limits.position.x * map_cellsize.x * ground.scale.x
	self.limit_right = map_limits.end.x * map_cellsize.x * ground.scale.x
	self.limit_top = map_limits.position.y * map_cellsize.y * ground.scale.y
	self.limit_bottom = map_limits.end.y * map_cellsize.y * ground.scale.y

func _process(delta):
	var current = self.offset
	var x = lerp(current.x, m_offset.x, 0.1) 
	var y = lerp(current.y, m_offset.y, 0.1) 
	self.set_offset(Vector2(x, y))
	

func _input(ev):
	if ev is InputEventMouseMotion:
		if status == "pressed":
			startPos = get_global_mouse_position()
			m_offset = Vector2()
			status = "dragging"
			
	if ev is InputEventMouseButton:
		if ev.is_pressed():
			status = "pressed"
		else:
			status = "released"

	if status == "dragging":
		var of = get_global_mouse_position() - startPos
		m_offset = self.get_offset() - of
		
	
	var maxTop = self.get_limit(MARGIN_TOP)
	if offset.y < maxTop:
		offset.y = maxTop

	var maxL = self.get_limit(MARGIN_LEFT)
	if offset.x < maxL:
		offset.x = maxL

	var s = get_tree().get_root().get_visible_rect().size
	var maxBottom = self.get_limit(MARGIN_BOTTOM)
	if (s.y + offset.y) > maxBottom:
		offset.y = maxBottom - s.y

	var maxR = self.get_limit(MARGIN_RIGHT)
	if (s.x + offset.x) > maxR:
		offset.x = maxR - s.x