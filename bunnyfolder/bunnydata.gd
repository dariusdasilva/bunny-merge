extends Node

enum Tier { BUNNY_1, BUNNY_2, }

var scenes = {
	Tier.BUNNY_1: preload("res://bunnyfolder/bunny_1.tscn"),
	Tier.BUNNY_2: preload("res://bunnyfolder/bunny_2.tscn"),
}

var scores = {
	Tier.BUNNY_1: 1,
	Tier.BUNNY_2:   3,
}

func next_tier(t: Tier):
	if t == Tier.BUNNY_2:
		return null # biggest tier, can't merge further
	return t + 1
