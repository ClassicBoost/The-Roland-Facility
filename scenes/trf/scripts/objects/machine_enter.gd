extends Area2D

var canEnter = true
@onready var player = get_owner().get_node("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area == player:
		canEnter = true
		print('dumbass')
