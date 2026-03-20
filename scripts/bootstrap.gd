extends Node

func _ready():
	_setup_inputs()


func _setup_inputs():
	var actions = {
		"move_left": KEY_A,
		"move_right": KEY_D,
		"move_forward": KEY_W,
		"move_back": KEY_S,
		"interact": KEY_E,
		"toggle_debug": KEY_F1,
		"toggle_inspector": KEY_F2,
		"pause_simulation": KEY_SPACE,
		"speed_up": KEY_BRACKETRIGHT,
		"slow_down": KEY_BRACKETLEFT,
	}

	for action in actions:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var event = InputEventKey.new()
			event.keycode = actions[action]
			InputMap.action_add_event(action, event)
