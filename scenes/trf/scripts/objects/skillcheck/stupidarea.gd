extends Area2D

var inMarker = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	inMarker = false
	for area in get_overlapping_areas():
		if "a" in area.name:
			inMarker = true
