extends CharacterBody3D

@export var speed : float
<<<<<<< HEAD
@export var camera_sens : Vector2 = Vector2(0.05, 0.03)
=======
@export var camera_sens : Vector2 = Vector2(0.5, 0.3)
@onready var camera : Camera3D = $Camera3D
var mouse_direction : float = 0

signal move_cube_input

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 1 * delta
	else:
		velocity.y = 0
		
	var side_axis : float = Input.get_axis("moveleft", "moveright")
	var straight_axis : float = Input.get_axis( "forward","backward")
	
	var direction : Vector3 = Vector3(side_axis, 0, straight_axis)
	var enddirection = basis * direction.normalized() * speed
	
	velocity.z = enddirection.z
	velocity.x = enddirection.x
	move_and_slide()
	pass
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_cube"):
		_rotate_cube()
	pass

	
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		_rotate_camera(event.relative.x, event.relative.y)
		mouse_direction = sign(event.relative.x)
		

	
func _rotate_camera(x, y):
		rotation.y -= x * camera_sens.y
		camera.rotation.x -= y * camera_sens.x
		
func _rotate_cube():
	var ray: RayCast3D = camera.raycast
	ray.target_position = Vector3.FORWARD * 20
	print(ray.is_colliding())
	var normal: Vector3 = round(ray.get_collision_normal())
	print(mouse_direction)
	emit_signal("move_cube_input", normal, mouse_direction)
	pass
 
	
