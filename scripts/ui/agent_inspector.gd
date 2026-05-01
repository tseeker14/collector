extends CanvasLayer

@onready var panel = $Panel
@onready var name_label = $Panel/VBoxContainer/NameLabel
@onready var state_label = $Panel/VBoxContainer/StateLabel
@onready var health_bar = $Panel/VBoxContainer/HealthBar
@onready var position_label = $Panel/VBoxContainer/PositionLabel
@onready var target_label = $Panel/VBoxContainer/TargetLabel

var selected_agent: BaseAgent = null
var is_visible: bool = false


func _ready():
	panel.hide()


func toggle():
	is_visible = not is_visible
	panel.visible = is_visible
	if not is_visible:
		selected_agent = null


func select_agent(agent: BaseAgent):
	selected_agent = agent
	_update_inspector()


func _process(_delta: float):
	if selected_agent and is_visible and is_instance_valid(selected_agent):
		_update_inspector()
	elif selected_agent and not is_instance_valid(selected_agent):
		selected_agent = null
		name_label.text = "No agent selected"


func _update_inspector():
	if not selected_agent:
		return
	name_label.text = "Agent: %s" % selected_agent.agent_name
	state_label.text = "State: %s" % selected_agent.state_machine.get_current_state_name()
	health_bar.value = (selected_agent.health / selected_agent.max_health) * 100
	health_bar.get_node("Label").text = "HP: %d/%d" % [selected_agent.health, selected_agent.max_health]
	position_label.text = "Pos: (%.1f, %.1f)" % [selected_agent.global_position.x, selected_agent.global_position.z]


func _input(event):
	if event.is_action_pressed("toggle_inspector"):
		toggle()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and is_visible:
		var space = get_viewport().get_camera_3d()
		if space:
			var from = space.project_ray_origin(event.position)
			var dir = space.project_ray_normal(event.position)
			var state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(from, from + dir * 100)
			var result = state.intersect_ray(query)
			if result and result.collider is BaseAgent:
				select_agent(result.collider)
