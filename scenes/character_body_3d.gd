extends CharacterBody3D

@export var speed : float
@export var camera_sens : Vector2 = Vector2(0.5, 0.3)

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
	pass

	
func _input(event: InputEvent):
	print(1)
	if event is InputEventMouseMotion:
		_rotate_camera(event.relative.x, event.relative.y)

	
func _rotate_camera(x, y):
		rotation.y -= x * camera_sens.y
		rotation.x -= y * camera_sens.x
		

	
