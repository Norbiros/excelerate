extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var ui: SpreadsheetUI = $Overlay/SpreadsheetUI
@onready var spawn_position := player.global_position


func _ready() -> void:
	player.died.connect(_on_player_died)
	player.reached_goal.connect(_on_player_reached_goal)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		_restart()
	ui.selected_cell = Worksheet.cell_at(player.global_position)


func _restart() -> void:
	ui.error_count = 0
	ui.show_win(false)
	_respawn()


func _respawn() -> void:
	player.controls_enabled = true
	player.global_position = spawn_position
	player.velocity = Vector2.ZERO
	$Player/Camera2D.reset_smoothing()


func _on_player_died() -> void:
	ui.error_count += 1
	_respawn()


func _on_player_reached_goal() -> void:
	player.controls_enabled = false
	ui.show_win(true)
