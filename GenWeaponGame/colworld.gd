extends Node2D


# Evolve timer
export var evolve_time = 10
var timer = evolve_time
var evolve_string = "Breeding in... "
#var file = File.new()

func _ready():
	$timer.set_text(evolve_string + str(int(timer)))
	# Make only one player write the parameters to file
#	if file.open("res://gun_log.csv", File.READ_WRITE) != 0:
#    	print("Error opening file")
#	else:
#		file.seek_end()
#		var param_str = ""
#		var i = 0
#		for param in $player1/gun.max_data:
#			if i != 0:
#				param_str = param_str + ","
#			param_str = param_str + str(param)
#			i += 1
#		file.store_line(param_str)
#		file.close()

func _physics_process(delta):
	timer -= delta
	if timer <= 0:
		$player1.evolution()
		$player2.evolution()
		timer = evolve_time

	$timer.set_text(evolve_string + str(int(timer)))
