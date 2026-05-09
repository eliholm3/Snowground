extends RigidBody3D

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(15.0).timeout.connect(queue_free)

func _physics_process(_delta: float) -> void:
	apply_central_force(WindField.get_wind_at(global_position) * mass)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("snowman"):
		body.get_hit()
		queue_free()
	# CSGBox3D with use_collision generates an internal StaticBody3D child,
	# so check the body itself and its parent for the floor group.
	elif body.is_in_group("tree"):
		queue_free()
	elif body.is_in_group("floor") or (body.get_parent() != null and body.get_parent().is_in_group("floor")):
		queue_free()
