@tool
class_name CellLabel
extends Label

# Text typed into a worksheet cell, which snaps itself to the cell

const PADDING := 6.0

@export var cell := Vector2i.ZERO:
	set(value):
		cell = value
		_snap_to_cell()


func _ready() -> void:
	_snap_to_cell()


func _snap_to_cell() -> void:
	position = Vector2(cell) * Worksheet.CELL_SIZE + Vector2(PADDING, 0.0)
	size = Worksheet.CELL_SIZE - Vector2(PADDING * 2.0, 0.0)
