extends KinematicBody2D

# Is the bullet just for display
export var chamber = false

# Time bullet lives on screen
export var max_life = 6
var life_time = max_life

var direction = Vector2()

# Paremeters from gun chromos
var data
var speed
var size
var angle
var bounces
var reproduce
var burst_angle
var color

# Which player shot it
var player_num

# Drawing and collisisons
var angle_from
var angle_to

func init(param, num):
	player_num = num
	data = param
	speed = param['speed']
	size = param['size']
	angle = param['angle']
	angle_from = 270 - angle
	angle_to = 270 + angle
	bounces = param['bounces']
	reproduce = param['reproduce']
	burst_angle = param['burst_angle']
	color = param['color']
	
	# Make bullet shape based on parameters
	# Chord formula
	var chord = 2 * size * sin(((angle_to - angle_from) * PI / 180) / 2)
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(chord/2, size/2))
	get_node("CollisionShape2D").set_shape(shape)
	update()


func shoot(player_position, angle):
	direction = (get_global_position() - player_position).normalized()
	direction = direction.rotated(angle * PI / 180)
	rotation = direction.angle()


func _physics_process(delta):
	if chamber:
		return
	life_time -= delta
	if life_time <= 0:
		if reproduce == 2:
			reproduce()
		else:
			queue_free()

	var collision_info = move_and_collide(direction * speed * delta)
	if collision_info:
		var collider_type = collision_info.collider.get_type()
		var collider = collision_info.collider
		if collider_type == "player":
			if collider.player_num != player_num:
				# Gotta get max from a gun, can be any gun since is determine before run time
				collider.reduce_power((collider.get_cur_gun().max_data['speed'] - speed + size) * 2)
				queue_free()
			else:
				position += direction * speed * delta
		elif collider_type == "bullet":
			position += direction * speed * delta
		else:
			if bounces >= 1:
				bounces -= 1
				direction = direction.bounce(collision_info.normal)
				rotation = direction.angle()
				speed = speed / 2
			else:
				queue_free()


# When the original bullet dies, reproduce it
# once with changed state
func reproduce():
	life_time = max_life
	data['reproduce'] = 1
	data['size'] = int(size / 3)
	data['speed'] = int(speed * 5)
	init(data, player_num)
	var rand_angle = (randi() % (2 * burst_angle) + 1) - burst_angle
	direction = direction.rotated(rand_angle * PI / 180)
	rotation = direction.angle()
	# Force redraw
	update()


# http://docs.godotengine.org/en/3.0/tutorials/2d/custom_drawing_in_2d.html
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	for i in range(nb_points+1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
		draw_polygon(points_arc, colors)

func _draw():
	var center = Vector2(size/2, 0)
	draw_circle_arc(center, size, angle_from, angle_to, color)

func get_type():
	return "bullet"

