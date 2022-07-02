extends KinematicBody
class_name BasicEnemyBody

export var drag := .5;

onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
var velocity : Vector3 = Vector3();

func _process(delta: float) -> void:
	velocity.y -= gravity*delta;
	velocity.x *= abs(drag-1);
	velocity.z *= abs(drag-1);

func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity);

func _on_EnemyBaseBehaviour_knockout(inertia) -> void: velocity = inertia;
