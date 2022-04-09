extends Node2D


func _ready():
	var dir = global_transform.basis_xform(Vector2(0,1))
	$Area2D.gravity_vec = dir
