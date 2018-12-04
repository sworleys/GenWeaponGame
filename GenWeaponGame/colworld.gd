extends Node2D


# Evolve timer
export var evolve_time = 10
var timer = evolve_time
var evolve_string = "Breeding in... "

func _ready():
	$timer.set_text(evolve_string + str(int(timer)))


func _physics_process(delta):
	timer -= delta
	if timer <= 0:
		$player1.evolution()
		$player2.evolution()
		timer = evolve_time

	$timer.set_text(evolve_string + str(int(timer)))
