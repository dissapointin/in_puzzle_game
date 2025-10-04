extends Node3D

@onready var cube: Cube = $Cube

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _ready() -> void:
	cube.set_side(cube.get_node("Side_TOP"), Side.SIDE.BOTTOM)
	cube.set_side(cube.get_node("Side_BOTTOM"), Side.SIDE.BOTTOM)
	cube.set_side(cube.get_node("Side_FRONT"), Side.SIDE.BOTTOM)
	cube.set_side(cube.get_node("Side_BACK"), Side.SIDE.BOTTOM)
	cube.set_side(cube.get_node("Side_LEFT"), Side.SIDE.BOTTOM)
	cube.set_side(cube.get_node("Side_RIGHT"), Side.SIDE.BOTTOM)
	print("s")

	await wait(2)
	print("top")
	cube.rotate_cube(Side.SIDE.TOP)
	await wait(2)
	print("bot")
	cube.rotate_cube(Side.SIDE.BOTTOM)
	await wait(2)
	print("fro")
	cube.rotate_cube(Side.SIDE.FRONT)
	await wait(2)
	print("bac")
	cube.rotate_cube(Side.SIDE.BACK)
	await wait(2)
	print("lef")
	cube.rotate_cube(Side.SIDE.LEFT)
	await wait(2)
	print("rig")
	cube.rotate_cube(Side.SIDE.RIGHT)
