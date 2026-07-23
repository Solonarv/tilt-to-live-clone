class_name CollapsingCircle
extends Formation


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if shrink_speed != null and radius > 32:
		for child in children:
			if is_instance_valid(child):
				var move = child.position.limit_length(shrink_speed*delta)
				child.position -= move
		radius -= shrink_speed*delta


func populate() -> void:
	for i in range(0, 50):
				var direction = Vector2(1,0).rotated(2*PI*i/50)
				add_child_at(direction * 320)
				add_child_at(direction * 328)
	var direction = Vector2(1,0).rotated(randf_range(0, 2*PI))
	velocity = direction * randf_range(0.7, 1.4) * 20
	angular_velocity = randf_range(-PI, PI) * 0.1
	position = target.position
	shrink_speed = 4**randf_range(0, 1) * 10
