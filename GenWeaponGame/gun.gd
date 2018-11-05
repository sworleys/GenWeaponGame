extends Node2D 

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# Bullet scene
export (PackedScene) var bullet

# Bullet container (main scene)
onready var bullet_container = get_parent().get_parent()

# Bullet spawn
export (NodePath) var bullet_spawn_path
onready var bullet_spawn = get_node(bullet_spawn_path)


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func shoot():
	var b = bullet.instance()
	b.set_global_position(bullet_spawn.get_global_position())
	b.shoot(get_global_position())
	bullet_container.add_child(b)
