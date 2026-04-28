extends CanvasLayer

@onready var panel = $Panel
@onready var info_label = $Panel/VBoxContainer/InfoLabel


func _ready():
	_update_info()
	panel.hide()


func _input(event: InputEvent):
	if event.is_action_pressed("toggle_debug"):
		panel.visible = not panel.visible

	if event.is_action_pressed("pause_simulation"):
		GameManager.toggle_pause()
		_update_info()

	if event.is_action_pressed("speed_up"):
		GameManager.toggle_speed()
		_update_info()

	if event.is_action_pressed("slow_down"):
		if GameManager.state == GameManager.SimulationState.RUNNING:
			GameManager.state = GameManager.SimulationState.SLOW
		elif GameManager.state == GameManager.SimulationState.SLOW:
			GameManager.state = GameManager.SimulationState.RUNNING
		_update_info()


func _update_info():
	if not is_inside_tree():
		return
	var stats = DataLogger.get_stats_summary()
	info_label.text = """=== CONTROLS ===
F1: Toggle debug panel
F2: Toggle agent inspector
SPACE: Pause/Resume
]: Speed up (3x)
]: Slow down (0.25x)

=== STATS ===
Spawned: %d
Deaths: %d
Resources: %d
Attacks: %d
""" % [stats.agent_spawns, stats.agent_deaths, stats.resources_collected, stats.attacks]
