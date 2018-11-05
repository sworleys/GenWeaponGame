extends KinematicBody2D

var direction = Vector2()
export var speed = 1000

func shoot(player_position):
	direction = (get_global_position() - player_position).normalized()
	rotation = direction.angle()


func _physics_process(delta):
	position += direction * speed * delta