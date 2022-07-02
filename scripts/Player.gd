extends KinematicBody

signal take_damage(damage)

export var vel:= 10.0;
export var blocking_vel := .75;
export var smoothness := 10;
export var jump_force := 15.0;
export var force := 25.0;

onready var player_data = $PlayerData;
onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
var velocity : Vector3 = Vector3();
var direction : Vector2;
var looking : Vector3;
var is_blocking := false;

# Behaviours
onready var dash_behaviour = $"Behaviours/DashBehaviour";

func _ready() -> void:
	GameManager.define_as_player(self);
	InputManager.connect("dash_input", self, "_on_InputManager_dash_input");

func _process(delta: float) -> void:
	if !player_data.alive:
		GameManager.clear_player();
		queue_free();

	_input_update();
	velocity.y -= gravity*delta;
	velocity.x = lerp(velocity.x, direction.x, 1.0/smoothness);
	velocity.z = lerp(velocity.z, direction.y, 1.0/smoothness);

	var s : Vector3 = (
		transform.origin-InputManager.relative_mouse_pos
	).normalized();
	var angle := atan2(s.z, s.x);
	rotation = Vector3(0, -angle, 0);

func _physics_process(delta: float) -> void:
	if(!dash_behaviour.finished):
		var c = dash_behaviour.dash_and_collide(delta, self);
		if(c): shield_bash(c);
		return;
	velocity = move_and_slide(
		velocity*(blocking_vel if is_blocking else 1.0),
		Vector3.UP
	);

func _input_update():
	direction = Input.get_vector("left", "right", "up", "down");
	direction = direction.normalized()*vel;
	is_blocking = Input.get_action_strength("block", true);


func shield_bash(coll: KinematicCollision):
	var obj = coll.collider;
	if obj is KinematicBody:
		var v = coll.travel.normalized()*force;
		if obj.get_node("Behaviours/EnemyBaseBehaviour"):
			obj.get_node("Behaviours/EnemyBaseBehaviour").bash_knockout(v*10);

func _take_damage(damage):
	emit_signal("take_damage", damage)

#func _on_InputManager_jump_input() -> void:
#	if(is_on_floor()): velocity.y = jump_force;

func _on_InputManager_dash_input(pointing_dir: Vector3) -> void:
	var s := pointing_dir-transform.origin;
	var angle := atan2(s.z, s.x);
	dash_behaviour.setup_dash(Vector3(cos(angle), 0, sin(angle)));

func _on_DashBehaviour_dash_finished(inertia) -> void: velocity = inertia/20;
