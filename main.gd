extends Node2D

const SPAWN_Y := 520.0
const SPAWN_X_MIN := 100.0
const SPAWN_X_MAX := 872.0
const SPAWN_OFFSCREEN := Vector2(1500.0, 1500.0)

@export var starting_tiers: Array[PackedScene] = []

var current_bunny: RigidBody2D = null
var score := 0

@onready var score_label: Label = $UI/Score


func _ready() -> void:
	bunny_data.bunny_merged.connect(_on_bunny_merged)
	_update_score_label()
	spawn_next_bunny()


func _input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.pressed
		and current_bunny
		and $DropCooldown.is_stopped()
	):
		drop_current_bunny()


func _process(_delta: float) -> void:
	if current_bunny:
		var drop_x := clampf(get_global_mouse_position().x, SPAWN_X_MIN, SPAWN_X_MAX)
		current_bunny.global_position = Vector2(drop_x, SPAWN_Y)


func drop_current_bunny() -> void:
	current_bunny.freeze = false
	current_bunny = null
	$DropCooldown.start()


func spawn_next_bunny() -> void:
	if starting_tiers.is_empty():
		return
	current_bunny = starting_tiers.pick_random().instantiate()
	add_child(current_bunny)
	current_bunny.global_position = SPAWN_OFFSCREEN
	current_bunny.freeze = true


func _on_drop_cooldown_timeout() -> void:
	spawn_next_bunny()


func _on_bunny_merged(tier: int) -> void:
	score += bunny_data.score_for(tier)
	_update_score_label()


func _update_score_label() -> void:
	if score_label:
		score_label.text = "Score: %d" % score
