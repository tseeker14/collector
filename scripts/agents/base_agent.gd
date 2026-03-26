extends CharacterBody3D
class_name BaseAgent

@export var agent_name: String = "Agent"
@export var max_health: float = 100.0
@export var move_speed: float = 3.0
@export var perception_radius: float = 15.0
@export var agent_color: Color = Color(0.5, 0.5, 0.8)

var health: float
var state_machine: StateMachine
var alive: bool = true
var home_position: Vector3
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	health = max_health
	home_position = global_position
	add_to_group("agents")
	_setup_mesh()
	_setup_state_machine()
	GameManager.register_agent(self)


func _setup_mesh():
	var shape = CollisionShape3D.new()
	shape.shape = CapsuleShape3D.new()
	shape.shape.radius = 0.3
	shape.shape.height = 1.2
	add_child(shape)

	var mesh = MeshInstance3D.new()
	mesh.mesh = CapsuleMesh.new()
	mesh.mesh.radius = 0.3
	mesh.mesh.height = 1.2

	var mat = StandardMaterial3D.new()
	mat.albedo_color = agent_color
	mesh.material_override = mat
	add_child(mesh)


func _setup_state_machine():
	state_machine = StateMachine.new()
	state_machine.name = "StateMachine"
	add_child(state_machine)
	_register_states()


func _register_states():
	pass


func _physics_process(delta):
	if not alive:
		return
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()


func take_damage(amount: float):
	health -= amount
	if health <= 0:
		die()


func die():
	alive = false
	hide()
	set_physics_process(false)
	GameManager.unregister_agent(self)
	DataLogger.log_event("agent_died", {"name": agent_name, "pos": global_position})
	get_tree().create_timer(GameManager.agents_config.respawn_delay).timeout.connect(_respawn)


func _respawn():
	health = max_health
	alive = true
	global_position = Vector3(
		randf_range(-GameManager.world_config.world_size + 2, GameManager.world_config.world_size - 2),
		0.5,
		randf_range(-GameManager.world_config.world_size + 2, GameManager.world_config.world_size - 2)
	)
	show()
	set_physics_process(true)
	GameManager.register_agent(self)
	state_machine.transition_to("Idle")


func collect_resource(resource: Node):
	if resource.has_method("get_resource_value"):
		var val = resource.get_resource_value()
		DataLogger.log_event("agent_collected", {"agent": agent_name, "value": val})
