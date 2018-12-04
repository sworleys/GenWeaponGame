extends Node

const MUTATION_CHANCE = 20


func _ready():
	pass

func evolve(pool):
	randomize()
	pool.sort_custom(pool[0], "compare")
	
	for i in range(0, pool.size()):
		var gun = pool[i]
		gun.num_fired = 0
		if i <= 2:
			continue
		for param in gun.data.keys():
			var random_parent = pool[(randi() % 2 + 1) - 1]
			var mutation = randi() % 100 + 1
			if (mutation <= MUTATION_CHANCE):
				gun.rand_chrom(param)
			else:
				gun.data[param] = random_parent.data[param]

