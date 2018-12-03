extends KinematicBody2D

var direction = Vector2()
var shape

# Paremeters from gun chromos
var speed
var size
var angle


func init(data):
	speed = data['speed']
	size = data['size']
	angle = data['angle']
	
	# Make bullet shape based on parameters
	shape = CircleShape2D.new()
	shape.set_radius(size)
	self.get_node("CollisionShape2D").set_shape(shape)


func shoot(player_position):
	direction = (get_global_position() - player_position).normalized()
	rotation = direction.angle()


func _physics_process(delta):
	position += direction * speed * delta

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
	var center = Vector2(0, 0)
	var radius = size
	var angle_from = 270 - angle
	var angle_to = 270 + angle
	var color = Color(1.0, 1.0, 1.0)
	draw_circle_arc(center, radius, angle_from, angle_to, color)



