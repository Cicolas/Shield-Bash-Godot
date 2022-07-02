extends Spatial

signal jump_input
signal dash_input(pointing_dir)

var absolute_mouse_pos: Vector2;
var relative_mouse_pos: Vector3;

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		emit_signal("jump_input");
	if Input.is_action_just_pressed("dash"):
		emit_signal("dash_input", relative_mouse_pos);

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		absolute_mouse_pos = event.position;
		var p = (calculate_relative_mouse_pos());
		if p: relative_mouse_pos = p;

func calculate_relative_mouse_pos():
	var from = GlobalCamera.project_ray_origin(absolute_mouse_pos);
	var c_prn = GlobalCamera.project_ray_normal(absolute_mouse_pos);
	var to = from + c_prn * 1000;
	var result = get_world().get_direct_space_state().intersect_ray(from, to);
	if result: return result.position;
	return null
