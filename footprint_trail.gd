extends Node3D

const STEP_DISTANCE = 0.9
const LIFETIME = 10.0
const FADE_TIME = 3.0

var _last_footprint_pos := Vector3.ZERO
var _last_pos := Vector3.ZERO

func _ready() -> void:
	_last_pos = global_position
	_last_footprint_pos = global_position

func _physics_process(_delta: float) -> void:
	var pos = global_position
	var direction = pos - _last_pos
	_last_pos = pos

	if pos.distance_to(_last_footprint_pos) >= STEP_DISTANCE:
		_last_footprint_pos = pos
		_spawn_print(pos, direction)

func _spawn_print(pos: Vector3, direction: Vector3) -> void:
	var inst := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.25
	mesh.bottom_radius = 0.25
	mesh.height = 0.015
	inst.mesh = mesh
	inst.scale = Vector3(1.0, 1.0, 1.6)

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.72, 0.80, 0.90, 0.75)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	inst.material_override = mat

	if direction.length() > 0.001:
		inst.rotation.y = atan2(direction.x, direction.z)

	get_tree().current_scene.add_child(inst)
	inst.global_position = Vector3(pos.x, 0.02, pos.z)

	var tween := get_tree().create_tween()
	tween.tween_interval(LIFETIME - FADE_TIME)
	tween.tween_method(func(a: float): mat.albedo_color.a = a, 0.75, 0.0, FADE_TIME)
	tween.tween_callback(inst.queue_free)
