extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"

const default_speed : float = 2.5
const friction : float = 0.5

var speed : float
var direction : Vector3
var input_dir : Vector2
var sensitivity : float = 0.004
var vel : Vector2
var flashlight : bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	speed = default_speed

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	vel = Vector2(direction.x, direction.z) * speed
	
	velocity += Vector3(vel.x, 0, vel.y)
	velocity.x *= friction
	velocity.z *= friction
	
	
	if Input.is_action_just_pressed("flashlight"):
		flashlight = not flashlight
		Global.flashlight = flashlight
		if flashlight:
			world_environment.environment.fog_density = 0.1
		else:
			world_environment.environment.fog_density = 0.2
		Global.emit_signal("flashlight_changed", flashlight)
	
	
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * sensitivity
		camera.rotation.x -= event.relative.y * sensitivity
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
