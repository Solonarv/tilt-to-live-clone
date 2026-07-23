class_name UnstableNucleus
extends Formation

@export var scale_constant := 32.0
@export var base_mass := 16.0
@export var gravity_strength := 160
@export var explode_energy := 160000
@export var explode_energy_variance := 2
@export var explode_angle_variance = PI/4

@onready var collider: Area2D = $Collider
@onready var collider_shape: CollisionShape2D = $Collider/CollisionShape2D

var energy := 0.0

func populate() -> void:
	var all_enemies = get_tree().get_nodes_in_group(&"enemies")
	for area in all_enemies:#  collider.get_overlapping_areas():
		if (area.position - position).length_squared() <= influence_radius():
			_on_collider_area_entered(area)
	if children.size() == 0:
		var seed = all_enemies[randi_range(0, all_enemies.size()-1)]
		position = seed.position
		_on_collider_area_entered(seed)
	print("unstable nucleus startup found size=", children.size(),
		" collider radius=", influence_radius())

func mass() -> float:
	return children.size() + base_mass

func influence_radius() -> float:
	return sqrt(mass()) * scale_constant

func _physics_process(delta: float) -> void:
	if energy >= explode_energy:
		explode()
	else:
		energy = 0
	super._physics_process(delta)
	var scale_factor = influence_radius()
	(collider_shape.shape as CircleShape2D).radius = scale_factor
	var average_position := Vector2(0,0)
	for child in children:
		average_position += child.position
		var distance = child.position - position
		var gravity = -distance.normalized() * mass() / distance.length_squared()
		var delta_v = gravity * delta
		energy += gravity.dot(child.velocity) + child.velocity.length_squared()
		child.velocity += delta_v
		print("F=",gravity, " Δv=",delta_v, " v=",child.velocity)
	position = average_position + Vector2(8,0).rotated(randf_range(-PI,PI))


func _on_collider_area_entered(area: Area2D) -> void:
	if area.is_in_group(&"enemies"):
		var enemy = area as Enemy
		enemy.reparent(self)
		children.append(enemy)
		enemy.in_formation = true
		enemy.target = null

func explode() -> void:
	print("exploding unstable nucleus with size=", children.size(), "energy=", energy)
	var energy_per_child = energy / children.size()
	for child in children:
		var e_kin = energy_per_child * exp(clamp(randfn(0, explode_energy_variance), 0.25, 4))
		var v = (child.position - position).normalized() * sqrt(e_kin)
		child.velocity = v.rotated(randfn(0, explode_angle_variance))
		
