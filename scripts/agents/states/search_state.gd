extends State
class_name SearchState

var search_origin: Vector3
var search_radius: float = 8.0
var search_target: Vector3
var search_timer: float = 0.0
var search_attempts: int = 0


func enter():
	search_origin = agent.global_position
	search_attempts = 0
	_pick_search_point()


func _pick_search_point():
	var angle = randf_range(0, TAU)
	var dist = randf_range(2, search_radius)
	search_target = search_origin + Vector3(cos(angle) * dist, 0.5, sin(angle) * dist)
	var half = GameManager.world_config.world_size - 2
	search_target.x = clamp(search_target.x, -half, half)
	search_target.z = clamp(search_target.z, -half, half)


func update(_delta: float):
	if _found_anything():
		state_machine.transition_to("Chase")
		return


func physics_update(delta: float):
	search_timer += delta
	var dir = (search_target - agent.global_position).normalized()
	dir.y = 0
	agent.velocity = dir * agent.move_speed * 0.8
	agent.move_and_slide()

	if agent.global_position.distance_to(search_target) < 1.0:
		search_attempts += 1
		if search_attempts >= 4:
			state_machine.transition_to("Patrol")
		else:
			_pick_search_point()

	if search_timer > 8.0:
		state_machine.transition_to("Patrol")


func _found_anything():
	for other in get_tree().get_nodes_in_group("agents"):
		if other == agent:
			continue
		if agent.global_position.distance_to(other.global_position) < agent.perception_radius * 0.5:
			return true
	for res in get_tree().get_nodes_in_group("resources"):
		if agent.global_position.distance_to(res.global_position) < agent.perception_radius * 0.5:
			return true
	return false
