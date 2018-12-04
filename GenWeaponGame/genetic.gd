extends Node

func _ready():
	pass

func evolution(pool):
	var update_pool = []
	
	update_pool = pool.sort_custom(self, "compare")
	
	return update_pool

static func compare(a, b):
	if a.data['num_fired'] < b.data['num_fired']:
		return true
	return false
