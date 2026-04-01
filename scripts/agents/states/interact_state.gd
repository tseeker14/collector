extends State
class_name InteractState

var interact_target: Node3D = null
var interact_time: float = 0.0
var interact_duration: float = 1.5


func enter():
	interact_target = _find_interactable()
	interact_time = 0.0
	agent.velocity = Vector3.ZERO


func _find_interactable():
	var closest = null
	var closest_dist = INF
	for other in get_tree().get_nodes_in_group("agents"):
		if other == agent:
			continue
		var d = agent.global_position.distance_to(other.global_position)
		if d < closest_dist and d < 2.0:
			closest = other
			closest_dist = d
	for res in get_tree().get_nodes_in_group("resources"):
		var d = agent.global_position.distance_to(res.global_position)
		if d < closest_dist and d < 2.0:
			closest = res
			closest_dist = d
	return closest


func update(delta: float):
	interact_time += delta
	if interact_time >= interact_duration:
		_interact()
		state_machine.transition_to("Idle")


func _interact():
	if not interact_target or not is_instance_valid(interact_target):
		return
	if interact_target.is_in_group("resources"):
		agent.collect_resource(interact_target)
		interact_target.queue_free()
	elif interact_target.is_in_group("agents"):
		interact_target.take_damage(25.0)
		DataLogger.log_event("agent_attacked",
			{"attacker": agent.agent_name, "target": interact_target.name})


func physics_update(_delta: float):
	agent.move_and_slide()
