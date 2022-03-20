extends RigidBody2D


func _ready():
	pass

func _integrate_forces(state: Physics2DDirectBodyState):
	add_central_force(Vector2(-100*position.x,0))
	add_central_force(Vector2(-100*state.linear_velocity.x,0))
	state.linear_velocity.x = 0

