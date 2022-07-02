extends TimedBehaviour
class_name DashBehaviour

signal dash_finished(inertia)

export var force: float;
export var dash_time: float;

var finished: bool = true;
var direction: Vector3;
var dash_time_elapsed: float = 0;

func setup_dash(_direction: Vector3):
	if is_ready:
		cooldown_is_counting = false;
		finished = false;
		dash_time_elapsed = 0;
		direction = _direction;

func dash_and_collide(delta: float, kinematic_body: KinematicBody) -> KinematicCollision:
	var c = null;
	if dash_time_elapsed > dash_time:
		emit_signal("dash_finished", direction*force);
		finish_dash();
	else:
		dash_time_elapsed += delta;
		c =  kinematic_body.move_and_collide(direction*force*delta);
		if c: finish_dash();
	return c;

func finish_dash():
	cooldown_reset();
	finished = true;
