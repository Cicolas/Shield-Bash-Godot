extends Node
class_name TimedBehaviour

export var cooldown_time: float;

var cooldown_time_elapsed: float = 0;
var is_ready := false;
var cooldown_is_counting := true;

func _process(delta: float) -> void:
	if cooldown_time_elapsed < cooldown_time and cooldown_is_counting:
		cooldown_time_elapsed += delta;
		is_ready = false;
		return;
	is_ready = true;

func cooldown_reset():
	is_ready = false;
	cooldown_is_counting = true;
	cooldown_time_elapsed = 0;
