class_name Worksheet
extends RefCounted

const CELL_SIZE := Vector2(96.0, 48.0)

const GRIDLINE_COLOR := Color("e1e1e1")
const ACCENT_COLOR := Color("107c41")


static func cell_at(world_position: Vector2) -> Vector2i:
	return Vector2i((world_position / CELL_SIZE).floor())


static func column_name(column: int) -> String:
	var result := ""
	var number := column + 1
	while number > 0:
		number -= 1
		result = char(65 + number % 26) + result
		number /= 26
	return result


static func cell_name(cell: Vector2i) -> String:
	return column_name(cell.x) + str(cell.y + 1)
