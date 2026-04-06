extends BaseAgent
class_name GathererAgent

var resources_collected: int = 0

func _ready():
	agent_name = "Gatherer-%d" % randi_range(1, 999)
	agent_color = Color(0.2, 0.8, 0.4)
	move_speed = GameManager.agents_config.gatherer_speed
	perception_radius = GameManager.agents_config.perception_radius
	super._ready()


func _register_states():
	var idle = IdleState.new()
	var patrol = PatrolState.new()
	var chase = ChaseState.new()
	var search = SearchState.new()
	var interact = InteractState.new()

	state_machine.add_state(idle)
	state_machine.add_state(patrol)
	state_machine.add_state(chase)
	state_machine.add_state(search)
	state_machine.add_state(interact)

	state_machine.initial_state = "Idle"


func get_target_type() -> String:
	return "gatherer"


func collect_resource(resource: Node):
	super(resource)
	resources_collected += 1
	GameManager.collect_resource(resource)
	resource.queue_free()
	DataLogger.log_event("gatherer_collected",
		{"name": agent_name, "total": resources_collected})
