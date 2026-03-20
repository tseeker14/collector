extends Node

enum SimulationState { RUNNING, PAUSED, SLOW, FAST }

var state: SimulationState = SimulationState.RUNNING
var agent_count: int = 0
var total_resources_collected: int = 0
var elapsed_time: float = 0.0
var world_config: WorldConfig
var agents_config: AgentsConfig

var agents: Array[BaseAgent] = []
var resources: Array[Node] = []


func _ready():
	world_config = WorldConfig.new()
	agents_config = AgentsConfig.new()
	start_simulation()


func start_simulation():
	var world = preload("res://scripts/world/world_generator.gd").new()
	add_child(world)
	world.generate()


func register_agent(agent: BaseAgent):
	agents.append(agent)
	agent_count = agents.size()
	DataLogger.log_event("agent_spawned", {"name": agent.agent_name, "type": agent.get_class()})


func unregister_agent(agent: BaseAgent):
	agents.erase(agent)
	agent_count = agents.size()
	DataLogger.log_event("agent_destroyed", {"name": agent.agent_name})


func register_resource(resource: Node):
	resources.append(resource)


func unregister_resource(resource: Node):
	resources.erase(resource)


func collect_resource(resource: Node):
	resources.erase(resource)
	total_resources_collected += 1
	DataLogger.log_event("resource_collected", {"position": resource.global_position})


func get_simulation_speed() -> float:
	match state:
		SimulationState.PAUSED:
			return 0.0
		SimulationState.SLOW:
			return 0.25
		SimulationState.FAST:
			return 3.0
		_:
			return 1.0


func toggle_pause():
	if state == SimulationState.PAUSED:
		state = SimulationState.RUNNING
	else:
		state = SimulationState.PAUSED


func toggle_speed():
	match state:
		SimulationState.RUNNING:
			state = SimulationState.FAST
		SimulationState.FAST:
			state = SimulationState.RUNNING
		SimulationState.SLOW:
			state = SimulationState.RUNNING
		_:
			state = SimulationState.RUNNING
