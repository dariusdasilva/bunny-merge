extends Node

## scenes, scores, and merge results.

enum Tier { BUNNY_1, BUNNY_2, BUNNY_3 }

signal bunny_merged(tier: Tier)

const TIER_SCENES: Dictionary = {
	Tier.BUNNY_1: preload("res://bunnyfolder/bunny_1.tscn"),
	Tier.BUNNY_2: preload("res://bunnyfolder/bunny_2.tscn"),
	Tier.BUNNY_3: preload("res://bunnyfolder/bunny_3.tscn"),
}

const TIER_SCORES: Dictionary = {
	Tier.BUNNY_1: 1,
	Tier.BUNNY_2: 3,
	Tier.BUNNY_3: 10,
}

const MAX_TIER := Tier.BUNNY_3


func scene_for(tier: int) -> PackedScene:
	return TIER_SCENES.get(tier)


func score_for(tier: int) -> int:
	return TIER_SCORES.get(tier, 0)


func next_tier(tier: int) -> int:
	if tier >= MAX_TIER:
		return -1 # biggest tier, can't merge further
	return tier + 1


func next_scene_for(tier: int) -> PackedScene:
	var next := next_tier(tier)
	if next < 0:
		return null
	return scene_for(next)
