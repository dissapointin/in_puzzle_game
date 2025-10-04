extends Node3D

@onready var cube: Cube = $Cube

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _ready() -> void:
	
	#var bottom_side: Side = cube.get_node("Side_BOTTOM")
	#var front_side: Side = cube.get_node("Side_FRONT")
	#var back_side: Side = cube.get_node("Side_BACK")
	#var left_side: Side = cube.get_node("Side_LEFT")
	#var right_side: Side = cube.get_node("Side_RIGHT")

	bottom_side: Side = cube.get_node("Side_BOTTOM")

	await wait(2)
	print("top")
	cube.rotate_cube(top_side, Side.SIDE.TOP)
	await wait(2)
	print("bot")
	cube.rotate_cube(bottom_side, Side.SIDE.BOTTOM)
	await wait(2)
	print("fro")
	cube.rotate_cube(front_side, Side.SIDE.FRONT)
	await wait(2)
	print("bac")
	cube.rotate_cube(back_side, Side.SIDE.BACK)
	await wait(2)
	print("lef")
	cube.rotate_cube(left_side, Side.SIDE.LEFT)
	await wait(2)
	print("rig")
	cube.rotate_cube(right_side, Side.SIDE.RIGHT)
