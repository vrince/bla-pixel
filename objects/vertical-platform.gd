extends RigidBody2D


func _ready():
	pass

func _integrate_forces(state: Physics2DDirectBodyState):
	state.linear_velocity.x = 0
	position.x = 0
