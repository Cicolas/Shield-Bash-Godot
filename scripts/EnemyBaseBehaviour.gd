extends Node
class_name EnemyBaseBehaviour

signal knockout(inertia)

export var balance := 0.0;

func bash_knockout(inertia: Vector3):
	emit_signal("knockout", inertia*abs(balance-1));
