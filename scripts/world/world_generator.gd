extends Node
class_name WorldGenerator

var ResourceNodeScript = preload("res://scripts/world/resource_node.gd")
var ObstacleScript = preload("res://scripts/world/obstacle.gd")


func generate():
	generate_terrain()
	generate_resources()
	generate_obstacles()
	get_parent().get_node("Spawner").spawn_all()


func generate_terrain():
	var ground = StaticBody3D.new()
	ground.name = "Ground"

	var shape = CollisionShape3D.new()
	shape.shape = BoxShape3D.new()
	shape.shape.size = Vector3(
		GameManager.world_config.world_size * 2,
		0.5,
		GameManager.world_config.world_size * 2
	)
	ground.add_child(shape)

	var mesh = MeshInstance3D.new()
	mesh.mesh = BoxMesh.new()
	mesh.mesh.size = Vector3(
		GameManager.world_config.world_size * 2,
		0.5,
		GameManager.world_config.world_size * 2
	)

	var mat = StandardMaterial3D.new()
	mat.albedo_color = GameManager.world_config.ground_color
	mesh.material_override = mat
	ground.add_child(mesh)

	get_parent().add_child(ground)

	var env = get_parent().get_node("WorldEnvironment")
	if not env:
		env = WorldEnvironment.new()
		env.name = "WorldEnvironment"
		get_parent().add_child(env)


func generate_resources():
	var half = GameManager.world_config.world_size
	for i in range(GameManager.world_config.resource_count):
		var res = ResourceNodeScript.new()
		res.position = Vector3(
			randf_range(-half + 2, half - 2),
			0.5,
			randf_range(-half + 2, half - 2)
		)
		get_parent().add_child(res)
		GameManager.register_resource(res)


func generate_obstacles():
	var half = GameManager.world_config.world_size - 2
	for i in range(GameManager.world_config.obstacle_count):
		var obs = ObstacleScript.new()
		obs.position = Vector3(
			randf_range(-half + 2, half - 2),
			0.5,
			randf_range(-half + 2, half - 2)
		)
		get_parent().add_child(obs)
