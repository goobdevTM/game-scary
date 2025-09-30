extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D

const default_speed : int = 1
const jump_vel : int = 5
const friction : float = 0.75

var speed : float
var coyote_time : float = 0
var buffer_jump : float = 0
var direction : Vector3
var input_dir : Vector2
var sensitivity : float = 0.004
var vel : Vector2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	speed = default_speed

func _physics_process(delta: float) -> void:
	coyote_time -= delta
	buffer_jump -= delta
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		buffer_jump = 0.08
	if is_on_floor():
		coyote_time = 0.05
		
	if coyote_time > 0 and buffer_jump > 0:
		buffer_jump = 0
		coyote_time = 0
		velocity.y = jump_vel

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	vel = Vector2(direction.x, direction.z) * speed
	
	velocity += Vector3(vel.x, 0, vel.y)
	velocity.x *= friction
	velocity.z *= friction
	
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * sensitivity
		camera.rotation.x -= event.relative.y * sensitivity
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
