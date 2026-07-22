class_name SpinningCross
extends Formation

func populate() -> void:
	make_rect(5, 5, Vector2(-2, -2))
	make_rect(5, 5, Vector2(3, -2))
	make_rect(5, 5, Vector2(-7, -2))
	make_rect(5, 5, Vector2(-2, 3))
	make_rect(5, 5, Vector2(-2, -7))
	var direction = Vector2(1,0).rotated(randf_range(0, 2*PI))
	velocity = direction * randf_range(0.7, 1.4) * 50
	angular_velocity = randf_range(-PI, PI) * 0.5
	position = spawner.gen_spawn_location(radius)
