extends Area
class_name Bullet

signal hit(coll)

export var bullet_damage: float;

var UUID: int;
var bullet_velocity: Vector3;
var bullet_time_alive: float;

func _process(delta: float) -> void:
	transform.origin += bullet_velocity * delta;
	bullet_time_alive += delta;

func bullet_reset():
	bullet_velocity = Vector3.ZERO;
	bullet_time_alive = 0;

func _on_Bullet_body_entered(body: Node) -> void:
	# player related bullet collision
	if body.has_method("_take_damage"): body._take_damage(bullet_damage);
	emit_signal("hit", body);
