extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 100 # Pixels/second
const ROTATION_SPEED = 5 # Pixels/second

# Player num
export var player_num = 1

# Size of gun pool
export var pool_size = 4

# Player color
export var color = Color(1, 0, 0)

# Health
export var max_health = 5000
var health_points = max_health

# Power
export var max_power = 5000
var power_points = max_power/2

# Is shooting?
var shooting = false

# Pool for holding guns to select from
var gun_pool = []

# Gun currently equipped
var equip_gun = 0

# Text pool display
var pool


func _ready():
	$gun.init()
	gun_pool.append($gun)
	
	for i in range(pool_size - 1):
		var new_gun = $gun.duplicate()
		add_child(new_gun)
		new_gun.init()
		new_gun.rand_chromos()
		gun_pool.append(new_gun)
	
	pool = get_parent().get_node("player" + str(player_num) + "_pool")
	pool.add_guns(gun_pool)
	equip_gun(0)
	# Reducing by 0 to set the power label
	reduce_power(0)



func _input(event):
	if(event.is_action_pressed("player" + str(player_num) + "_shoot")):
		shooting = true
	elif(event.is_action_released("player" + str(player_num) + "_shoot")):
		shooting = false
	elif(event.is_action_pressed("player" + str(player_num) + "_cycle_weapon")):
		var index
		if (equip_gun >= pool_size - 1):
			index = 0
		else:
			index = equip_gun + 1
		equip_gun(index)


# Equips gun
func equip_gun(index):
		un_equip_gun()
		equip_gun = index
		gun_pool[equip_gun].equip()
		pool.select(index)

# Un-equips gun
func un_equip_gun():
	gun_pool[equip_gun].un_equip()


func _physics_process(delta):
	if (power_points < max_power):
		add_power(1)
	var motion = Vector2()
	var direction = ($gun.bullet_spawn.get_global_position()- get_global_position()).normalized()

	
	if player_num == 1:
		if Input.is_action_pressed("move_up"):
			motion += direction
		if Input.is_action_pressed("move_bottom"):
			motion -= direction
		if Input.is_action_pressed("move_left"):
			rotate((-1) * ROTATION_SPEED * delta)
		if Input.is_action_pressed("move_right"):
			rotate(ROTATION_SPEED * delta)
		if Input.is_key_pressed(KEY_L):
			evolution()
	elif player_num == 2:
		if Input.is_key_pressed(KEY_W):
			motion += direction
		if Input.is_key_pressed(KEY_S):
			motion -= direction
		if Input.is_key_pressed(KEY_A):
			rotate((-1) * ROTATION_SPEED * delta)
		if Input.is_key_pressed(KEY_D):
			rotate(ROTATION_SPEED * delta)
		if Input.is_key_pressed(KEY_E):
			evolution()
	
	motion = motion.normalized() * MOTION_SPEED
	move_and_slide(motion)

func _process(delta):
	if (shooting):
		fire_once()

func fire_once():
	var consumption = (get_cur_gun().data['size'] + get_cur_gun().data['speed']) * get_cur_gun().data["burst"]
	if not (power_points - consumption < 0):
		reduce_power(consumption)
		get_cur_gun().shoot()
		pool.set_item_text(equip_gun, get_cur_gun().to_string())
		shooting = false

func get_type():
	return "player"

# Returns the gun object currently equipped
func get_cur_gun():
	return gun_pool[equip_gun]

func evolution():
	un_equip_gun()
	$genetic.evolve(gun_pool)
	pool.add_guns(gun_pool)
	equip_gun(0)

#func reduce_health(damage):
#	health_points -= damage
#	if health_points <= 0:
#		print("Player " + str(player_num) + " dies in a blaze of glory...")
#		get_tree().quit()
#	$health.set_text(str(health_points))

func reduce_power(power):
	power_points -= power
	if power_points <= 0:
		print("Player " + str(player_num) + " dies in a blaze of glory...")
		get_tree().quit()
	$power.set_text(str(power_points))

func add_power(power):
	power_points += power
	$power.set_text(str(power_points))
