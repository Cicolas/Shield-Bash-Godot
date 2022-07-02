extends TimedBehaviour
class_name ShootBehaviour

export(Resource) var bullet_res: Resource;
export var shoot_vel: float;
export var shoot_count: int;
export var shoot_max_distance: float;
export var shoot_max_time_alive: float;

var UUID := 1000;
var shoot_pool := [];

func _ready() -> void:
	for _i in range(shoot_count):
		var b = bullet_res.instance();
		b.UUID = UUID;
		UUID += 1;
		b.connect("hit", self, "_on_Bullet_hit", [b.UUID]);
		shoot_pool.append({'bullet': b, 'able': true, 'instanciated': false});

func shoot(dir: Vector3, position: Vector3) -> void:
	if is_ready:
		recover_bullets(position)
		for x in shoot_pool:
			if x['able']:
				cooldown_reset();
				x['able'] = false;
				x['bullet'].visible = true;
				x['bullet'].transform.origin = position;
				x['bullet'].bullet_velocity = dir*shoot_vel;
				if !x['instanciated']:
					$"/root/World".add_child(x['bullet']);
					x['instanciated'] = true;
				break;
#		print(free_bullets_count())
		pass

func recover_bullets(position: Vector3):
	for x in shoot_pool:
		if !x['able']:
			if x['bullet'].bullet_time_alive > shoot_max_time_alive:
				x['able'] = true
				x['bullet'].hide()
				x['bullet'].bullet_reset();
				pass
#			var bpos = x['bullet'].transform.origin
#			var distance = ((bpos-position) as Vector3).length()
#			if(distance > shoot_max_distance): x['able'] = true
#			pass

func free_bullets_count():
	var acc := 0;
	for x in shoot_pool:
		if x['able']: acc+=1;
	return acc

func _on_Bullet_hit(body, id):
	var b: Dictionary;
	for x in shoot_pool: if x['bullet'].UUID == id: b = x;

	b['able'] = false;
	b['bullet'].hide()
	b['bullet'].bullet_reset()
	pass
