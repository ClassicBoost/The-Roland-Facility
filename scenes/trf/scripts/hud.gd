extends Control

@onready var player = get_owner().get_node("player")
@onready var the_floor = get_owner().get_node("the_floor")

@onready var stamBar = $Stamina/stamBar
@onready var stamTxt = $Stamina/stamTxt
@onready var moneyTxt = $money/text
@onready var activeAbility = $ActiveAbility
@onready var activeCooldown = $ActiveAbility/cooldown

@onready var heart1 = $health/heart1
@onready var heart2 = $health/heart2
@onready var heart3 = $health/heart3

@onready var floorNum = $Floor/floor_number
@onready var machNum = $Floor/machines

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.is_debug_build():
		$Debug/toon.show()
	else:
		$Debug/toon.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	stamBar.value = player.curStam
	stamBar.max_value = player.maxStam
	stamTxt.text = 'Stamina: ' + str(int(player.curStam)) + '/' + str(player.maxStam)
	moneyTxt.text = '$'
	if player.money > 99999:
		moneyTxt.text += '99999+'
	else:
		moneyTxt.text += str(player.money)
	
	if player.activeAbility[0] == '':
		activeAbility.hide()
	else:
		activeAbility.show()
	
	if the_floor.blackout:
		$Blackout.show()
	else:
		$Blackout.hide()
	
	if player.coolDownTimer > 0:
		activeCooldown.show()
		activeCooldown.text = str(int(player.coolDownTimer + 1))
		$ActiveAbility/cooldownBar.max_value = player.activeAbility[2]
		$ActiveAbility/cooldownBar.value = player.coolDownTimer
	else:
		activeCooldown.hide()
	
	floorNum.text = 'FLOOR ' + str(the_floor.floorNumber)
	if (the_floor.panicMode):
		machNum.text = str(int(the_floor.panictimeLeft)) + ' seconds left!'
	else:
		machNum.text = str(the_floor.machinesComplete) + '/' + str(the_floor.machinesTotal) + ' Machines'
	
	
	healthUpdate(player.health, player.main)

func healthUpdate(hp, mc):
	heart3.hide()
	heart2.hide()
	heart1.hide()
	if hp >= 3 or (hp >= 2 and mc):
		heart3.show()
	if hp >= 2 or (hp >= 1 and mc):
		heart2.show()
	if hp >= 1:
		heart1.show()


func toon_name_debug(text):
	player.toonName = text
	player.loadToon(text)
