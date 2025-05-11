extends Node2D

var canEnter = false
var doingThisMachine = false
@export var machineProgress:float = 0
@onready var player = get_owner().get_node("player")
@onready var the_floor = get_owner().get_node("the_floor")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str(int(machineProgress)) + '%'
	if Input.is_action_just_pressed("interact") and canEnter:
		interactMachine()
	
	if player.onMachine and doingThisMachine:
		if player.extraction == 1:
			machineProgress += 1.2 * delta
		if player.extraction == 2:
			machineProgress += 2.5 * delta
		if player.extraction == 3:
			machineProgress += 3.2 * delta
		if player.extraction == 4:
			machineProgress += 4.1 * delta
		if player.extraction == 5:
			machineProgress += 5 * delta
	
	if machineProgress >= 100 and doingThisMachine:
		completeMachine()

func interactMachine():
	if player.onMachine:
			player.onMachine = false
			doingThisMachine = false
			print('getoff')
			pass
	if not player.onMachine:
		if machineProgress < 100:
			player.onMachine = true
			doingThisMachine = true
			print('geton')
			pass

func _on_enter_thing_area_entered(area):
	if area.name == 'PlayerCollision':
		canEnter = true
		print('can enter')

func _on_enter_thing_area_exited(area):
	if area.name == 'PlayerCollision':
		canEnter = true
		print('cannot enter')

func completeMachine():
	doingThisMachine = false
	player.onMachine = false
	$complete.play()
	the_floor.machinesComplete += 1
	player.money += 30
	player.happiness += 2
