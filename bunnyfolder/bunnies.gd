extends RigidBody2D

signal merged(tier: int)

@export var tier: int
@export var next_scene: PackedScene

var should_be_merged = false

# merge detection
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("bunnies"):

		if body.tier == tier:

			if get_instance_id() < body.get_instance_id():

				# same time = get fucked
				request_merge(body)

func request_merge(body: Node2D) -> void:
	should_be_merged = true
	body.should_be_merged = true
	call_deferred("merge", body)


# merge action
func merge(body: Node2D) -> void:
	if not next_scene:
		return

	var midpoint = (global_position + body.global_position) / 2.0
	var bigger_bunny = next_scene.instantiate()
	get_parent().add_child(bigger_bunny)
	bigger_bunny.global_position = midpoint
	bigger_bunny.apply_impulse(Vector2(0, -50))  # spice

	merged.emit(tier)
	queue_free()
	body.queue_free()
