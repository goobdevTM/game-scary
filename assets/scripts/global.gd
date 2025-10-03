extends Node

var flashlight : bool = false

signal flashlight_changed(flashlight : bool)

var chunks : Dictionary = {}

var seed : int

func _ready() -> void:
	seed = randi()
