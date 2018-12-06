extends Node

const MUTATION_CHANCE = 5


func _ready():
	pass

func evolve(pool):
	randomize()
	pool.sort_custom(pool[0], "compare")
	for i in range(0, pool.size()):
		var gun = pool[i]
		gun.num_fired = 0
		for param in gun.data.keys():
			if i <= 1:
				var random_sel = (randi() % 2 + 1) - 1
				var random_parent = pool[random_sel]
				gun.data[param] = random_parent.data[param]
			var mutation = randi() % 100 + 1
			if (mutation <= MUTATION_CHANCE):
				gun.rand_chrom(param)


