extends Node2D 


# Chromos Max Values


# Holds max data
export var max_data = {
	speed = 1000,
	size = 100,
	angle = 50
}

# Holds chromos info
var data = {}

# Number of times fired
var num_fired = 0

# Bullet scene
export (PackedScene) var bullet

# Bullet container (main scene)
var bullet_container

# Bullet spawn
var bullet_spawn


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	rand_chromos()

func init():
	bullet_container = get_parent().get_parent()
	bullet_spawn = get_node("bullet_spawn")



#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


# Randomize the parameters
func rand_chromos():
	randomize()
	for param in max_data.keys():
		rand_chrom(param)

func rand_chrom(param):
		data[param] = randi() % max_data[param] + 1

func to_string():
	var pool_str = "num_fired:" + str(num_fired) + ", "
	for key in data.keys():
		pool_str += str(key) + ":" + str(data[key]) + ", "
	return pool_str
	

func shoot():
	num_fired += 1
	var b = bullet.instance()
	b.init(data)
	b.set_global_position(bullet_spawn.get_global_position())
	b.shoot(get_global_position())
	bullet_container.add_child(b)
