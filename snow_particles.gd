extends GPUParticles3D

# Change this in the inspector to spawn more or fewer snowflakes.
@export var particle_count: int = 150000 :
	set(value):
		particle_count = value
		amount = value

func _ready() -> void:
	amount = particle_count
	emitting = true
