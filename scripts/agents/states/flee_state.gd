extends State
class_name FleeState

var threat: Node3D = null
var flee_target: Vector3
var flee_timer: float = 0.0


func enter():
	threat = _find_threat()
	if threat:
		var away = (agent.global_position - threat.global_position).normalized()
		flee_target = agent.global_position + away * 15
		# Clamp to world bounds
		var half = GameManager.world_config.world_size - 2
		flee_target.x = clamp(flee_target.x, -half, half)
		flee_target.z = clamp(flee_target.z, -half, half)
	flee_timer = 0.0


func _find_threat():
	for other in get_tree().get_nodes_in_group("agents"):
		if other == agent:
			continue
		if other.is_in_group("hunters"):
			var d = agent.global_position.distance_to(other.global_position)
			if d < agent.perception_radius * 0.7:
				return other
	return null


func update(delta: float):
	flee_timer += delta
	if not threat or not is_instance_valid(threat):
		state_machine.transition_to("Idle")
		return
	var d = agent.global_position.distance_to(threat.global_position)
	if d > agent.perception_radius * 1.2:
		state_machine.transition_to("Patrol")
		return
	if flee_timer > 4.0:
		state_machine.transition_to("Patrol")


func physics_update(delta: float):
	var dir = (flee_target - agent.global_position).normalized()
	dir.y = 0
	agent.velocity = dir * agent.move_speed * 1.5
	agent.move_and_slide()
