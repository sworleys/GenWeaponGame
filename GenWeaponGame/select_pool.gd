extends ItemList

var root
#var file = File.new()

func _ready():
	pass

func add_guns(pool):
	clear()
#	if file.open("res://gun_log.csv, File.READ_WRITE) != 0:
#    	print("Error opening file")
#	else:
#		file.seek_end()
#		for gun in pool:
#			file.store_line(gun.to_csv())
#		file.close()
	for gun in pool:
		add_item(gun.to_string())


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
# Open a file