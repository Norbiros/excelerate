extends Node2D

# The background needs to be endless for that reason it is drawn using this script

func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var visible_rect := get_canvas_transform().affine_inverse() * get_viewport_rect()
	var first := Worksheet.cell_at(visible_rect.position)
	var last := Worksheet.cell_at(visible_rect.end) + Vector2i.ONE
	var top_left := Vector2(first) * Worksheet.CELL_SIZE
	var bottom_right := Vector2(last) * Worksheet.CELL_SIZE

	draw_rect(Rect2(top_left, bottom_right - top_left), Color.WHITE)
	for column in range(first.x, last.x + 1):
		var x := column * Worksheet.CELL_SIZE.x
		draw_line(Vector2(x, top_left.y), Vector2(x, bottom_right.y), Worksheet.GRIDLINE_COLOR)
	for row in range(first.y, last.y + 1):
		var y := row * Worksheet.CELL_SIZE.y
		draw_line(Vector2(top_left.x, y), Vector2(bottom_right.x, y), Worksheet.GRIDLINE_COLOR)
