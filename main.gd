extends Node2D

@export var starting_tiers: Array[PackedScene] = []

var has_been_dropped: bool = false
var drop_location: Vector2
var current_bunny: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_next_bunny()


func _input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.pressed
		and current_bunny
		and $DropCooldown.is_stopped()
	):
		current_bunny.freeze = false
		current_bunny = null
		$DropCooldown.start()


func _unhandled_input(event: InputEvent) -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_bunny:
		drop_location = get_global_mouse_position()
		drop_location.x = clampf(drop_location.x, 100.0, 872.0)
		drop_location.y = 520.0
		current_bunny.global_position = drop_location


func _physics_process(delta: float) -> void:
	pass


func spawn_next_bunny():
	var scene = starting_tiers.pick_random()
	current_bunny = scene.instantiate()
	add_child(current_bunny)
	current_bunny.global_position = Vector2(1500.0, 1500.0)
	current_bunny.freeze = true


func _on_drop_cooldown_timeout() -> void:
	spawn_next_bunny()
