extends Node2D 


# Chromos Max Values


# Holds max data
var max_data = {
	speed = 300,
	size = 60,
	angle = 50,
	burst = 5,
	burst_angle = 50,
	bounces = 3,
	reproduce = 2,
	color = 255
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

# Is gun equipped
var equipped = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	rand_chromos()

func init():
	bullet_container = get_parent().get_parent()
	bullet_spawn = get_node("bullet_spawn")
	$chamber.init(data, get_parent().player_num)
	$chamber.set_global_position(bullet_spawn.get_global_position())
	# Doesn't actually shoot, just sets direction
	$chamber.shoot(get_global_position(), 0)
	$chamber.hide()

# Gun is equipped by player
func equip():
	equipped = true
	$chamber.init(data, get_parent().player_num)
	$chamber/burst.set_text(str(data["burst"]))
	$chamber.show()

# Gun is un-equipped by player
func un_equip():
	equipped = false
	$chamber.hide()

# Randomize the parameters
func rand_chromos():
	for param in max_data.keys():
		rand_chrom(param)

func rand_chrom(param):
		if param == "color":
			data[param] = Color(
					get_random(param) / float(max_data[param]),
					get_random(param) / float(max_data[param]), 
					get_random(param) / float(max_data[param])
					)
		else:
			data[param] = get_random(param)

# Get a random between 1 and the parameters max
func get_random(param):
	randomize()
	return randi() % max_data[param] + 1

func to_string():
	var pool_str = "num_fired:" + str(num_fired) + ", "
	for key in data.keys():
		if not (key == "color"):
			pool_str += str(key) + ":" + str(data[key]) + ", "
	return pool_str

func to_csv():
	var gun_str = ""
	var i = 0
	for key in data.keys():
		if not (key == "color"):
			if i != 0:
				gun_str += ","
			gun_str += str(data[key])
		i += 1
	return gun_str

# Shoot all bullets in chamber
func shoot():
	num_fired += 1
	if data["burst"] == 1:
		shoot_bullet(0)
	else:
		for i in range(data["burst"]):
			var rand_angle = (randi() % (2 * data["burst_angle"]) + 1) - data["burst_angle"]
			shoot_bullet(rand_angle)

# Shoot a single bullet
func shoot_bullet(burst_angle):
	var b = bullet.instance()
	b.init(data.duplicate(), get_parent().player_num)
	b.set_global_position(bullet_spawn.get_global_position())
	b.shoot(get_global_position(), burst_angle)
	bullet_container.add_child(b)


static func compare(a, b):
	if a.num_fired > b.num_fired:
		return true
	return false