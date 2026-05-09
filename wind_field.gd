extends Node

const GRID_SIZE     = 10
const CELL_SIZE     = 10.0
const ZONE_HEIGHT   = 50.0
const MAP_OFFSET    = 50.0
const WIND_STRENGTH = 40.0

static var _grid: Array[Vector3] = []

static func _ensure_generated() -> void:
	if _grid.size() == GRID_SIZE * GRID_SIZE:
		return
	_grid.resize(GRID_SIZE * GRID_SIZE)
	for i in range(GRID_SIZE * GRID_SIZE):
		var angle    = randf() * TAU
		var strength = randf() * WIND_STRENGTH
		_grid[i]     = Vector3(cos(angle), 0.0, sin(angle)) * strength

static func get_wind_at(world_pos: Vector3) -> Vector3:
	_ensure_generated()
	if world_pos.y < 0.0 or world_pos.y > ZONE_HEIGHT:
		return Vector3.ZERO
	var gx = clamp(int((world_pos.x + MAP_OFFSET) / CELL_SIZE), 0, GRID_SIZE - 1)
	var gz = clamp(int((world_pos.z + MAP_OFFSET) / CELL_SIZE), 0, GRID_SIZE - 1)
	return _grid[gz * GRID_SIZE + gx]
