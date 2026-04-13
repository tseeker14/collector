extends Node
class_name EnvironmentSystem

@export var sun: DirectionalLight3D

var time_of_day: float = 0.0
var day_length: float = 120.0
var is_enabled: bool = true

var _ambient_base: Color = Color(0.3, 0.35, 0.45)
var _sunrise_color: Color = Color(0.9, 0.6, 0.3)
var _day_color: Color = Color(1.0, 0.95, 0.85)
var _sunset_color: Color = Color(0.9, 0.4, 0.2)
var _night_color: Color = Color(0.1, 0.1, 0.15)


func _ready():
	is_enabled = GameManager.world_config.enable_day_night
	day_length = GameManager.world_config.day_length
	if not sun:
		sun = get_parent().get_node("DirectionalLight3D")


func _process(delta: float):
	if not is_enabled or not sun:
		return

	time_of_day = fmod(time_of_day + delta / day_length, 1.0)
	_update_sun()
	_update_ambient()


func _update_sun():
	var angle = time_of_day * TAU - PI / 2
	sun.rotation.x = angle
	var intensity = max(0, sin(angle))
	sun.light_energy = 0.3 + intensity * 0.7


func _update_ambient():
	var env = get_parent().get_node("WorldEnvironment")
	if not env or not env.environment:
		return

	var t = time_of_day
	var color: Color
	if t < 0.25:
		var p = t / 0.25
		color = _night_color.lerp(_sunrise_color, p)
	elif t < 0.45:
		var p = (t - 0.25) / 0.2
		color = _sunrise_color.lerp(_day_color, p)
	elif t < 0.75:
		var p = (t - 0.45) / 0.3
		color = _day_color.lerp(_sunset_color, p)
	else:
		var p = (t - 0.75) / 0.25
		color = _sunset_color.lerp(_night_color, p)

	env.environment.ambient_light_color = color
