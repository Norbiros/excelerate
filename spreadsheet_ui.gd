class_name SpreadsheetUI
extends Control

# Corner where the worksheet cells begin
const GRID_ORIGIN := Vector2(44.0, 142.0)

const HEADER_COLOR := Color("f5f5f5")
const HEADER_SELECTED_COLOR := Color("dfeee5")
const HEADER_BORDER_COLOR := Color("d4d4d4")
const HEADER_TEXT_COLOR := Color("444444")
const HEADER_HEIGHT := 24.0
const HEADER_FONT_SIZE := 13

var selected_cell := Vector2i.ZERO:
	set(value):
		selected_cell = value
		$FormulaBar/NameBox/CellName.text = Worksheet.cell_name(value)

var error_count := 0:
	set(value):
		error_count = value
		$StatusBar/Errors.text = "Errors: %d" % value


func _process(_delta: float) -> void:
	queue_redraw()


func show_win(shown: bool) -> void:
	$WinDialog.visible = shown


func _draw() -> void:
	var world_to_screen := get_viewport().get_canvas_transform()
	var first := Worksheet.cell_at(world_to_screen.affine_inverse() * GRID_ORIGIN)
	var last := Worksheet.cell_at(world_to_screen.affine_inverse() * size)
	var header_top := GRID_ORIGIN.y - HEADER_HEIGHT

	for column in range(maxi(first.x, 0), last.x + 1):
		var left := (world_to_screen * Vector2(column * Worksheet.CELL_SIZE.x, 0.0)).x
		var rect := Rect2(left, header_top, Worksheet.CELL_SIZE.x, HEADER_HEIGHT)
		_draw_header_cell(rect, Worksheet.column_name(column), column == selected_cell.x)

	for row in range(maxi(first.y, 0), last.y + 1):
		var top := (world_to_screen * Vector2(0.0, row * Worksheet.CELL_SIZE.y)).y
		var rect := Rect2(0.0, top, GRID_ORIGIN.x, Worksheet.CELL_SIZE.y)
		_draw_header_cell(rect, str(row + 1), row == selected_cell.y)

	# Top left corner, covers headers that scrolled under it
	_draw_header_cell(Rect2(0.0, header_top, GRID_ORIGIN.x, HEADER_HEIGHT), "", false)


func _draw_header_cell(rect: Rect2, text: String, selected: bool) -> void:
	draw_rect(rect, HEADER_SELECTED_COLOR if selected else HEADER_COLOR)
	draw_rect(rect.grow(-0.5), HEADER_BORDER_COLOR, false, 1.0)

	var font := get_theme_default_font()
	var baseline := rect.position.y + (rect.size.y + font.get_ascent(HEADER_FONT_SIZE) - font.get_descent(HEADER_FONT_SIZE)) / 2.0
	var color := Worksheet.ACCENT_COLOR if selected else HEADER_TEXT_COLOR
	draw_string(font, Vector2(rect.position.x, roundf(baseline)), text, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, HEADER_FONT_SIZE, color)
