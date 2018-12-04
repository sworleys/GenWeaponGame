extends ItemList

var root


func _ready():
	pass

func add_guns(pool):
	for gun in pool:
		add_item(gun.to_string())

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
