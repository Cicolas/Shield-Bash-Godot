extends Spatial

var player: Node;

func define_as_player(p: Node):
	player = p;

func clear_player():
	player = null;
