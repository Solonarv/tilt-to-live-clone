class_name SweeperV
extends Formation

var is_mirror := false

func populate() -> void:
	make_rect(160, 2, Vector2(-80, -1))
	var direction: Vector2
	if target.position.y < spawner.extent.y/2:
		direction = Vector2(0,1)
	else:
		direction = Vector2(0,-1)
	if is_mirror: direction = -direction
	position = spawner.get_edge_center(direction) - direction*8
	velocity = -direction * 2**randf_range(0,1) * 80
