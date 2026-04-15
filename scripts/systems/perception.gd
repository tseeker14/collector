extends Node
class_name PerceptionSystem

var agent: BaseAgent
var radius: float = 15.0
var detection_interval: float = 0.5
var timer: float = 0.0


func get_visible_agents() -> Array[BaseAgent]:
	var result: Array[BaseAgent] = []
	for other in get_tree().get_nodes_in_group("agents"):
		if other == agent:
			continue
		var d = agent.global_position.distance_to(other.global_position)
		if d <= radius:
			if _has_line_of_sight(other):
				result.append(other)
	return result


func get_nearest_agent() -> BaseAgent:
	var closest: BaseAgent = null
	var closest_dist = INF
	for other in get_tree().get_nodes_in_group("agents"):
		if other == agent:
			continue
		var d = agent.global_position.distance_to(other.global_position)
		if d < closest_dist and d <= radius:
			if _has_line_of_sight(other):
				closest = other
				closest_dist = d
	return closest


func get_visible_resources() -> Array[Node]:
	var result: Array[Node] = []
	for res in get_tree().get_nodes_in_group("resources"):
		var d = agent.global_position.distance_to(res.global_position)
		if d <= radius and _has_line_of_sight(res):
			result.append(res)
	return result


func _has_line_of_sight(target: Node3D) -> bool:
	var space = agent.get_world_3d().direct_space_state
	if not space:
		return true
	var query = PhysicsRayQueryParameters3D.create(
		agent.global_position + Vector3.UP * 0.5,
		target.global_position + Vector3.UP * 0.5,
		1
	)
	var result = space.intersect_ray(query)
	if result.is_empty():
		return true
	return result.collider == target


func _to_string() -> String:
	return "PerceptionSystem(radius=%d)" % radius
