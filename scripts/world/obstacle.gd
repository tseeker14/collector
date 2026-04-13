extends StaticBody3D
class_name Obstacle

@export var obstacle_height: float = 1.5
@export var obstacle_width: float = 0.8


func _ready():
	add_to_group("obstacles")

	var shape = CollisionShape3D.new()
	shape.shape = BoxShape3D.new()
	shape.shape.size = Vector3(obstacle_width, obstacle_height, obstacle_width)
	add_child(shape)

	var mesh = MeshInstance3D.new()
	mesh.mesh = BoxMesh.new()
	mesh.mesh.size = Vector3(obstacle_width, obstacle_height, obstacle_width)

	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.4, 0.3, 0.25)
	mesh.material_override = mat
	add_child(mesh)

	position.y = obstacle_height / 2
