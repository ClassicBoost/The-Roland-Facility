extends Node2D

@onready var player = get_owner().get_node("player")
@onready var the_floor = get_owner().get_node("the_floor")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if the_floor.gonnaDie > 2:
		position += ((player.position - position).normalized()) * (1.5 + (the_floor.gonnaDie * 0.05))


func _on_area_2d_area_entered(area):
	if area.name == 'PlayerCollision' and the_floor.panicMode:
		player.health = -99
