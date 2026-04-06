extends BaseAgent
class_name WandererAgent

var exploration_points: Array[Vector3] = []
var current_exploration_index: int = 0

func _ready():
	agent_name = "Wanderer-%d" % randi_range(1, 999)
	agent_color = Color(0.6, 0.5, 0.9)
	move_speed = GameManager.agents_config.wanderer_speed
	perception_radius = GameManager.agents_config.perception_radius * 0.6
	super._ready()
	_generate_exploration_path()


func _register_states():
	var idle = IdleState.new()
	var patrol = PatrolState.new()
	var flee = FleeState.new()

	state_machine.add_state(idle)
	state_machine.add_state(patrol)
	state_machine.add_state(flee)

	state_machine.initial_state = "Idle"


func _generate_exploration_path():
	var half = GameManager.world_config.world_size - 3
	for i in range(5):
		exploration_points.append(Vector3(
			randf_range(-half, half),
			0.5,
			randf_range(-half, half)
		))


func get_target_type() -> String:
	return "wanderer"
