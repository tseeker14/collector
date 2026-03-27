extends State
class_name IdleState

var idle_timer: float = 0.0
var idle_duration: float = 2.0


func enter():
	idle_timer = 0.0
	idle_duration = randf_range(1.0, 4.0)
	agent.velocity = Vector3.ZERO


func update(delta: float):
	idle_timer += delta
	if idle_timer >= idle_duration:
		state_machine.transition_to("Patrol")


func physics_update(_delta: float):
	agent.move_and_slide()
