extends CharacterBody2D

signal died
signal reached_goal

const SPEED := 270.0
const ACCELERATION := 1500.0
const JUMP_VELOCITY := -470.0
const JUMP_CELL_VELOCITY := -690.0
const FALL_LIMIT := 1200.0

var controls_enabled := true


func _physics_process(delta: float) -> void:
	if not controls_enabled:
		velocity = Vector2.ZERO
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	move_and_slide()

	_apply_touched_cells()
	if global_position.y > FALL_LIMIT:
		died.emit()


func _apply_touched_cells() -> void:
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var layer := collision.get_collider() as TileMapLayer
		if layer == null:
			continue

		var point := layer.to_local(collision.get_position() - collision.get_normal())
		var tile := layer.get_cell_tile_data(layer.local_to_map(point))
		if tile == null:
			continue

		match tile.get_custom_data("effect"):
			&"error":
				died.emit()
				return
			&"goal":
				reached_goal.emit()
				return
			&"jump":
				if collision.get_normal().y < -0.5:
					velocity.y = JUMP_CELL_VELOCITY
