extends Node

export var max_life: int;

onready var life: float = max_life;
var alive: bool = true;

func _on_Player_take_damage(damage) -> void:
	life = clamp(life-damage, 0, max_life);
	alive = !(life == 0);
