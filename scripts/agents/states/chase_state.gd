extends State
class_name ChaseState

var chase_target: Node3D = null
var chase_timer: float = 0.0


func enter():
	chase_target = _find_best_target()
	chase_timer = 0.0


func _find_best_target():
	var closest = null
	var closest_dist = INF
	for other in get_tree().get_nodes_in_group("agents"):
		if other == agent:
			continue
		var d = agent.global_position.distance_to(other.global_position)
		if d < closest_dist and d < agent.perception_radius:
			closest = other
			closest_dist = d
	# Also look for resources
	for res in get_tree().get_nodes_in_group("resources"):
		var d = agent.global_position.distance_to(res.global_position)
		if d < closest_dist and d < agent.perception_radius:
			closest = res
			closest_dist = d
	return closest


func update(_delta: float):
	if not chase_target or not is_instance_valid(chase_target):
		state_machine.transition_to("Search")
		return
	if agent.global_position.distance_to(chase_target.global_position) > agent.perception_radius * 1.5:
		state_machine.transition_to("Search")
		return


func physics_update(delta: float):
	if not chase_target or not is_instance_valid(chase_target):
		state_machine.transition_to("Idle")
		return

	var dir = (chase_target.global_position - agent.global_position).normalized()
	dir.y = 0
	agent.velocity = dir * agent.move_speed * 1.3
	agent.move_and_slide()

	if agent.global_position.distance_to(chase_target.global_position) < 1.2:
		state_machine.transition_to("Interact")
