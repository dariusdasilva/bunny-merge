extends RigidBody2D

class_name Bunny

@export var tier: int

var _merging := false


# Merge detection: two bunnies of the same tier fuse into the next one.
func _on_body_entered(body: Node2D) -> void:
	if _merging or not (body is Bunny):
		return
	if body.tier != tier or body._merging:
		return
	# Lower instance id defers to the other one; only one pair merges.
	if get_instance_id() < body.get_instance_id():
		request_merge(body)


func request_merge(body: Node) -> void:
	_merging = true
	body._merging = true
	merge.call_deferred(body)


func merge(body: Node) -> void:
	if not is_instance_valid(body):
		_merging = false
		return

	var scene := bunny_data.next_scene_for(tier)
	if scene == null:
		# Max tier: nothing to merge into, leave both bunnies alone.
		_merging = false
		body._merging = false
		return

	var bigger_bunny := scene.instantiate()
	get_parent().add_child(bigger_bunny)
	bigger_bunny.global_position = (global_position + body.global_position) / 2.0
	bigger_bunny.apply_impulse(Vector2(0, -50)) # spice

	bunny_data.bunny_merged.emit(tier)
	queue_free()
	body.queue_free()
