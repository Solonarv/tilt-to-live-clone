class_name SweeperH
extends Formation

var is_mirror := false

func populate() -> void:
	make_rect(2, 90, Vector2(-1, -45))
	var direction: Vector2
	if target.position.x < spawner.extent.x/2:
		direction = Vector2(1,0)
	else:
		direction = Vector2(-1,0)
	if is_mirror: direction = -direction
	position = spawner.get_edge_center(direction) - direction*8
	velocity = -direction * 2**randf_range(0,1) * 80
