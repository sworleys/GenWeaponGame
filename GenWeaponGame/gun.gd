extends Node2D 


# Chromos Max Values


# Holds max data
export var max_data = {
	speed = 1000,
	size = 70,
	angle = 50,
	burst = 5,
	burst_angle = 25,
	bounces = 3
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
	if abs(bullet_spawn.position.y) < data['size']*2:
		bullet_spawn.position.y = -1 * (data['size'] + 1)

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
	

# Shoot all bullets in chamber
func shoot():
	num_fired += 1
	if data["burst"] == 1:
		shoot_bullet(0)
	else:
		for i in range(data["burst"]):
			var rand_angle = (randi() % (2 * max_data["burst_angle"]) + 1) - max_data["burst_angle"]
			shoot_bullet(rand_angle)

# Shoot a single bullet
func shoot_bullet(burst_angle):
	var b = bullet.instance()
	b.init(data)
	b.set_global_position(bullet_spawn.get_global_position())
	#b.set_rotation_degrees(burst_angle)
	b.shoot(get_global_position(), burst_angle)
	#b.direction.set_rotation_degrees(b.get_rotation_degrees() + burst_angle)
	bullet_container.add_child(b)

static func compare(a, b):
	if a.num_fired > b.num_fired:
		return true
	return false