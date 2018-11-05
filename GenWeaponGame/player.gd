extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 160 # Pixels/second
const ROTATION_SPEED = 5 # Pixels/second

var shooting = false


func _ready():
	pass

func _input(event):
	if(event.is_action_pressed("player1_shoot")):
		shooting = true
	elif(event.is_action_released("player1_shoot")):
		shooting = false


func _physics_process(delta):
	var motion = Vector2()
	var direction = ($gun.bullet_spawn.get_global_position()- get_global_position()).normalized()
	
	if Input.is_action_pressed("move_up"):
		motion += direction
	if Input.is_action_pressed("move_bottom"):
		motion -= direction
	if Input.is_action_pressed("move_left"):
		rotate((-1) * ROTATION_SPEED * delta)
	if Input.is_action_pressed("move_right"):
		rotate(ROTATION_SPEED * delta)
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)

func _process(delta):
	if (shooting):
		fire_once()

func fire_once():
	$gun.shoot()
	shooting = false
