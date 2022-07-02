extends Node
class_name TurretBehaviour

export(NodePath) var obj : String;

var obj_pos: Vector3;
var player_pos: Vector3;

# Behaviours
onready var shoot_behaviour = $"../ShootBehaviour";

func _ready() -> void:
	obj_pos = get_node(obj).transform.origin;
	player_pos = $"/root/World/Player".transform.origin;

func _process(delta: float) -> void:
	var tp = track_player();
	if tp:
		shoot_behaviour.shoot(Vector3(tp.x, 0, tp.z).normalized(), obj_pos);

func track_player() -> Object:
	if !GameManager.player: return null;
	player_pos = GameManager.player.transform.origin;
	var d = (player_pos-obj_pos).normalized();
	return d;
