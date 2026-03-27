extends State
class_name PatrolState

var patrol_target: Vector3
var patrol_timer: float = 0.0
var patrol_duration: float = 5.0


func enter():
	_pick_patrol_target()
	patrol_timer = 0.0


func _pick_patrol_target():
	var half = GameManager.world_config.world_size - 3
	patrol_target = Vector3(
		randf_range(-half, half),
		0.5,
		randf_range(-half, half)
	)


func update(_delta: float):
	_check_transitions()


func physics_update(delta: float):
	patrol_timer += delta
	var dir = (patrol_target - agent.global_position).normalized()
	dir.y = 0
	agent.velocity = dir * agent.move_speed

	if agent.global_position.distance_to(patrol_target) < 1.5:
		state_machine.transition_to("Idle")
		return

	if patrol_timer >= patrol_duration:
		_pick_patrol_target()
		patrol_timer = 0.0

	agent.move_and_slide()


func _check_transitions():
	var nearest = _find_nearest_agent()
	if nearest and agent.global_position.distance_to(nearest.global_position) < agent.perception_radius:
		if agent.has_method("get_target_type"):
			state_machine.transition_to("Chase")


func _find_nearest_agent():
	var closest = null
	var closest_dist = INF
	for other in get_tree().get_nodes_in_group("agents"):
		if other == agent:
			continue
		var d = agent.global_position.distance_to(other.global_position)
		if d < closest_dist and d < agent.perception_radius:
			closest = other
			closest_dist = d
	return closest
