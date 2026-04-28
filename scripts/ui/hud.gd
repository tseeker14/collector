extends CanvasLayer

@onready var agent_count_label = $MarginContainer/VBoxContainer/AgentCount
@onready var resource_count_label = $MarginContainer/VBoxContainer/ResourceCount
@onready var time_label = $MarginContainer/VBoxContainer/TimeLabel
@onready var speed_label = $MarginContainer/VBoxContainer/SpeedLabel

var update_interval: float = 0.5
var timer: float = 0.0


func _ready():
	_update_display()


func _process(delta: float):
	timer += delta
	if timer >= update_interval:
		timer = 0.0
		_update_display()


func _update_display():
	if not is_inside_tree():
		return

	var agents = get_tree().get_nodes_in_group("agents").size()
	var resources = get_tree().get_nodes_in_group("resources").size()

	agent_count_label.text = "Agents: %d" % agents
	resource_count_label.text = "Resources: %d" % resources
	time_label.text = "Time: %.1fs" % GameManager.elapsed_time

	match GameManager.state:
		GameManager.SimulationState.PAUSED:
			speed_label.text = "[PAUSED]"
		GameManager.SimulationState.FAST:
			speed_label.text = "[3x SPEED]"
		GameManager.SimulationState.SLOW:
			speed_label.text = "[0.25x SPEED]"
		_:
			speed_label.text = "[1x]"
