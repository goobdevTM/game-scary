extends Node3D

const PLANT = preload("uid://hbk13c817oig")
const TREE = preload("uid://c2uxda7mneqrd")

signal shown


@onready var generate_area: Area3D = $GenerateArea
@onready var terrain: Node3D = $Terrain
@onready var objects: Node3D = $Terrain/Objects

var colors : Array = [Color(0.403, 0.482, 0.56, 1.0), Color(0.426, 0.46, 0.124, 1.0)]
var unc : bool = false
var chunk_pos : Vector2i 

func _ready() -> void:
	
	chunk_pos = Vector2i(position.x / 16, position.z / 16) 
			
	Global.flashlight_changed.connect(flash)
	hide()
	for x in range(-8,8):
		for y in range(-8,8):
			if randi_range(0,2) == 0:
				spawn_random_object(Vector2i(x,y))
	await get_tree().create_timer(0).timeout
	unc = true
	await get_tree().create_timer(0.1).timeout
	flash(false)

func flash(flashlight_on : bool) -> void:
	if visible and terrain.visible:
		var change_color_to : Color
		if flashlight_on:
			change_color_to = colors[1]
		else:
			change_color_to = colors[0]
			
		for i : Node3D in objects.get_children():
			if i.get("modulate"):
				i.modulate = change_color_to
			else:
				for j in i.get_children():
					if j.get("modulate"):
						j.modulate = change_color_to
		
func _on_generate_area_body_entered(body: Node3D) -> void:
	get_parent().generate_chunks(Vector2i(position.x, position.z) / 16)
	generate_area.queue_free()


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	terrain.show()
	flash(Global.flashlight)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	terrain.hide()
	

func _on_visible_area_body_exited(body: Node3D) -> void:
	hide()
	emit_signal("shown")


func _on_visible_area_body_entered(body: Node3D) -> void:
	show()
	flash(Global.flashlight)
	
func spawn_random_object(pos : Vector2i) -> void:
	var rand : int = randi_range(0,1)
	var object : Node3D = null
	if randi_range(0,2) == 0:
		rand = randi_range(0,1)
		match rand:
			0:
				object = PLANT.instantiate()
			1:
				object = TREE.instantiate()
	else:
		if get_parent().tree_noise.noise.get_noise_2d(pos.x + position.x, pos.y + position.z) > 0.5:
			object = TREE.instantiate()
			
			
				
	if object:
		object.scale *= randf_range(0.8,1.2)
		objects.add_child(object)
		object.position = Vector3(pos.x, 0, pos.y)


func _on_detect_inside_other_chunk_area_entered(area: Area3D) -> void:
	if area.get_parent().unc:
		queue_free()
		
