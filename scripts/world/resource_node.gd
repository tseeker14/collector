extends Area3D
class_name ResourceNode

@export var resource_value: int = 1
@export var respawn_time: float = 5.0
@export var glow_color: Color = Color(0.0, 0.8, 0.4)

var collected: bool = false


func _ready():
	add_to_group("resources")

	var shape = CollisionShape3D.new()
	shape.shape = SphereShape3D.new()
	shape.shape.radius = 0.3
	add_child(shape)

	var mesh = MeshInstance3D.new()
	mesh.mesh = SphereMesh.new()
	mesh.mesh.radius = 0.3
	mesh.mesh.height = 0.6

	var mat = StandardMaterial3D.new()
	mat.albedo_color = glow_color
	mat.emission_enabled = true
	mat.emission = glow_color
	mat.emission_energy_multiplier = 0.5
	mesh.material_override = mat
	add_child(mesh)

	body_entered.connect(_on_collected)


func _on_collected(body: Node):
	if collected:
		return
	if body.has_method("collect_resource"):
		collected = true
		hide()
		set_process(false)
		GameManager.collect_resource(self)
		get_tree().create_timer(respawn_time).timeout.connect(_respawn)


func _respawn():
	collected = false
	show()
	set_process(true)


func _process(delta):
	rotate_y(delta * 1.5)
	position.y = 0.5 + sin(Time.get_ticks_msec() * 0.003) * 0.1
