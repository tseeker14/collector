extends Node
class_name StateMachine

@export var initial_state: String = "Idle"

var current_state: State = null
var states: Dictionary = {}
var agent: BaseAgent


func _ready():
	agent = get_parent() as BaseAgent
	for child in get_children():
		if child is State:
			child.agent = agent
			child.state_machine = self
			states[child.name.to_lower()] = child
	if initial_state.to_lower() in states:
		transition_to(initial_state)
	else:
		push_warning("StateMachine: initial state '%s' not found" % initial_state)


func _process(delta):
	if current_state:
		current_state.update(delta)


func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)


func transition_to(state_name: String):
	var key = state_name.to_lower()
	if key not in states:
		push_warning("StateMachine: state '%s' not found" % state_name)
		return
	if current_state:
		current_state.exit()
	current_state = states[key]
	current_state.enter()


func add_state(state: State):
	state.agent = agent
	state.state_machine = self
	state.name = state.get_script().get_global_name()
	add_child(state)
	states[state.name.to_lower()] = state


func get_current_state_name() -> String:
	return current_state.name if current_state else "None"
