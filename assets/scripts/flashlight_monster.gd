extends Node3D

@onready var anim: AnimationPlayer = $Anim
@onready var sprite: Sprite3D = $Sprite3D
@onready var player: CharacterBody3D = $".."

var start_pos : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.flashlight_changed.connect(flash)
	hide()
	
func flash(flashlight : bool) -> void:
	if randi_range(0,3) == 0:
		sprite.modulate.a = 1
		show()
		start_pos = position
		top_level = true
		if flashlight:
			anim.play("disappear")
		else:
			anim.play("RESET")
		while anim.is_playing():
			if global_position.distance_to(player.global_position) <= 6:
				sprite.modulate.a = (global_position.distance_to(player.global_position) - 3.5) / 6
			await get_tree().create_timer(0).timeout
		top_level = false
		position = start_pos
		hide()
