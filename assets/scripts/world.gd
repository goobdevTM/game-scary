extends Node3D


@export var noise : NoiseTexture2D

@onready var first_chunk: Node3D = $Chunk

const CHUNK = preload("uid://bxw777x45fbv2")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.chunks[Vector2i(0,0)] = first_chunk
	generate_chunks(Vector2i(0,0))
	
func generate_chunks(pos : Vector2i) -> void:
	if not Global.chunks.has(pos + Vector2i(1,0)):
		add_chunk_at(pos + Vector2i(1,0))
		
	if not Global.chunks.has(pos + Vector2i(-1,0)):
		add_chunk_at(pos + Vector2i(-1,0))
		
	if not Global.chunks.has(pos + Vector2i(0,1)):
		add_chunk_at(pos + Vector2i(0,1))
		
	if not Global.chunks.has(pos + Vector2i(0,-1)):
		add_chunk_at(pos + Vector2i(0,-1))
		

func add_chunk_at(pos : Vector2i) -> void:
	var chunk = CHUNK.instantiate()
	add_child(chunk)
	chunk.position = Vector3(pos.x * 16, 0, pos.y * 16)
	Global.chunks[pos] = chunk
