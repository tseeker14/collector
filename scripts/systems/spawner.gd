extends Node
class_name Spawner

var HunterScript = preload("res://scripts/agents/hunter_agent.gd")
var GathererScript = preload("res://scripts/agents/gatherer_agent.gd")
var WandererScript = preload("res://scripts/agents/wanderer_agent.gd")


func spawn_all():
	_spawn_type(HunterScript, GameManager.agents_config.hunter_count)
	_spawn_type(GathererScript, GameManager.agents_config.gatherer_count)
	_spawn_type(WandererScript, GameManager.agents_config.wanderer_count)


func _spawn_type(script: GDScript, count: int):
	var half = GameManager.world_config.world_size - 3
	for i in range(count):
		var agent = script.new()
		agent.position = Vector3(
			randf_range(-half, half),
			0.5,
			randf_range(-half, half)
		)
		get_parent().add_child(agent)
		DataLogger.log_event("spawner_created",
			{"type": script.get_global_name(), "index": i, "pos": agent.position})


func spawn_agent_of_type(type_name: String):
	var half = GameManager.world_config.world_size - 3
	var pos = Vector3(randf_range(-half, half), 0.5, randf_range(-half, half))

	match type_name.to_lower():
		"hunter":
			var a = HunterScript.new()
			a.position = pos
			get_parent().add_child(a)
		"gatherer":
			var a = GathererScript.new()
			a.position = pos
			get_parent().add_child(a)
		"wanderer":
			var a = WandererScript.new()
			a.position = pos
			get_parent().add_child(a)


func get_agent_count() -> Dictionary:
	var counts = {}
	for agent in get_tree().get_nodes_in_group("agents"):
		var cls = agent.get_script().get_global_name()
		counts[cls] = counts.get(cls, 0) + 1
	return counts
