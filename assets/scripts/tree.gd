extends Node3D

@onready var tree: Sprite3D = $tree
@onready var pine: Sprite3D = $pine


var pick: float = 0

func _ready() -> void:
	await get_tree().create_timer(0).timeout
	pick = get_parent().get_parent().get_parent().get_parent().type_noise.noise.get_noise_2d(global_position.x / 16, global_position.z / 16)
	if pick <= -0.37:
		tree.hide()
	else:
		pine.hide()
