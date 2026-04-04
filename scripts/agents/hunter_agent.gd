extends BaseAgent
class_name HunterAgent

@export var attack_damage: float = 30.0
@export var chase_range: float = 20.0

func _ready():
	agent_name = "Hunter-%d" % randi_range(1, 999)
	agent_color = Color(0.9, 0.2, 0.2)
	move_speed = GameManager.agents_config.hunter_speed
	perception_radius = chase_range
	super._ready()
	add_to_group("hunters")


func _register_states():
	var idle = IdleState.new()
	var patrol = PatrolState.new()
	var chase = ChaseState.new()
	var search = SearchState.new()
	var interact = InteractState.new()
	var flee = FleeState.new()

	state_machine.add_state(idle)
	state_machine.add_state(patrol)
	state_machine.add_state(chase)
	state_machine.add_state(search)
	state_machine.add_state(interact)
	state_machine.add_state(flee)

	state_machine.initial_state = "Idle"


func get_target_type() -> String:
	return "hunter"
