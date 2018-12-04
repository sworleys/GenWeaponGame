extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 160 # Pixels/second
const ROTATION_SPEED = 5 # Pixels/second

# Player num
export var player_num = 1

# Size of gun pool
export var pool_size = 4


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
	pool.select(0)
	



func _input(event):
	if(event.is_action_pressed("player" + str(player_num) + "_shoot")):
		shooting = true
	elif(event.is_action_released("player" + str(player_num) + "_shoot")):
		shooting = false
	elif(event.is_action_pressed("player" + str(player_num) + "_cycle_weapon")):
		if (equip_gun >= pool_size - 1):
			equip_gun = 0
			
		else:
			equip_gun += 1
		pool.select(equip_gun)
		


func _physics_process(delta):
	var motion = Vector2()
	var direction = ($gun.bullet_spawn.get_global_position()- get_global_position()).normalized()
	
	if Input.is_key_pressed(KEY_Y):
		$genetic.evolve(gun_pool)
		pool.add_guns(gun_pool)
	
	if player_num == 1:
		if Input.is_action_pressed("move_up"):
			motion += direction
		if Input.is_action_pressed("move_bottom"):
			motion -= direction
		if Input.is_action_pressed("move_left"):
			rotate((-1) * ROTATION_SPEED * delta)
		if Input.is_action_pressed("move_right"):
			rotate(ROTATION_SPEED * delta)
	elif player_num == 2:
		if Input.is_key_pressed(KEY_W):
			motion += direction
		if Input.is_key_pressed(KEY_S):
			motion -= direction
		if Input.is_key_pressed(KEY_A):
			rotate((-1) * ROTATION_SPEED * delta)
		if Input.is_key_pressed(KEY_D):
			rotate(ROTATION_SPEED * delta)
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)

func _process(delta):
	if (shooting):
		fire_once()

func fire_once():
	gun_pool[equip_gun].shoot()
	pool.set_item_text(equip_gun, gun_pool[equip_gun].to_string())
	shooting = false
