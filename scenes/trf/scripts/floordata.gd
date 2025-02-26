extends Panel
# I'm lazy
@export var game_lunaticMode:bool = false

@export var floorNumber:int = 1

#region Events
@export var blackout:bool = false
var blackoutPre:int = 0
@export var gasleak:bool = false
@export var redlights:bool = false
@export var notwisteds:bool = false # always set to true on first floor

@export var blackoutChance:float = 0
@export var gasleakChance:float = 0
@export var redlightsChance:float = 0
@export var notwistedsChance:float = 0

var blackoutTimer:float = 30
var blackoutFailedAttempts:int = 0

var chanceValue = [
		[5, 2.5],
		[1, 0.5],
	]
var chanceCap = [
		[100, 75],
		[20, 10],
]

@export var repairSet:bool = false
#endregion

@export var machinesComplete:int = 0
@export var machinesTotal:int = 2
@export var panicMode:bool = false
var panictimeLeft:float = 60
var timeint:int = 60
var gonnaDie:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if floorNumber == 1:
		notwisteds = true
	
#region Panic Mode
	if machinesComplete >= machinesTotal:
		panicMode = true
	else:
		panicMode = false
	
	if panicMode:
		panictimeLeft -= 1 * delta
		if panictimeLeft < 0:
			panictimeLeft = 1
			gonnaDie += 1
		if int(panictimeLeft) != timeint and gonnaDie < 2:
			timeint = int(panictimeLeft)
			$ping.play()
	else:
		panictimeLeft = 60
#endregion
	
	if OS.is_debug_build() and Input.is_action_just_pressed("debug2"):
		newFloor()
	
#region Blackout
	if blackoutPre >= 1 and not blackout:
		blackoutTimer -= 1 * delta
		if blackoutTimer < 0:
			var rng = randf_range(0, 1)
			if blackoutPre == 1:
				if (rng > 0.5 or blackoutFailedAttempts > 5):
					print('blackoutchanceSucceed')
					if blackoutPre == 1:
						$blackout_uhoh.play()
					blackoutPre = 2
				else:
					blackoutTimer = 30
					blackoutFailedAttempts += 1
					print('blackoutchanceFailed')
			
			if blackoutTimer < -10:
				blackout = true
				$lights_shut.play()
	else:
		blackoutTimer = 30
#endregion
	
	
func newFloor():
#region New Floor
	blackoutPre = 0
	blackout = false
	gasleak = false
	redlights = false
	notwisteds = false
	floorNumber += 1
	
	if floorNumber > 2:
		blackoutChance += chanceValue[0][int(repairSet)] * (int(game_lunaticMode)+1)
	if floorNumber > 9:
		gasleakChance += chanceValue[1][int(repairSet)] * (int(game_lunaticMode)+1)
		redlightsChance += 0.25 * (int(game_lunaticMode)+1)
		notwistedsChance += 0.1 / (int(game_lunaticMode)+1)
	
	if blackoutChance > chanceCap[0][int(repairSet)]:
		blackoutChance = chanceCap[0][int(repairSet)]
	if gasleakChance > chanceCap[1][int(repairSet)]:
		gasleakChance = chanceCap[1][int(repairSet)]
	var maxChanceLol:int = 1 + (int(game_lunaticMode)*9)
	if redlightsChance > maxChanceLol:
		redlightsChance = maxChanceLol
	if notwistedsChance > 0.5:
		notwistedsChance = 0.5
	
	print('Blackout Chance:' + str(blackoutChance) + '%\nGas Leak Chance:' + str(gasleakChance) + '%\nRed Lights Chance:' + str(redlightsChance) + '%\nNo Twisteds Chance:' + str(notwistedsChance) + '%')
	
	var bkoRNG = randf_range(0, 100)
	var gslRNG = randf_range(0, 100)
	var rdlRNG = randf_range(0, 100)
	var ntwRNG = randf_range(0, 100)
	
	if bkoRNG < blackoutChance:
		blackoutPre = 1
		print('blackout incoming!')
	if gslRNG < gasleakChance:
		gasleak = true
		print('gas leak incoming!')
	if rdlRNG < redlightsChance and blackoutPre == 0: # no point having them be red if it's a blackout.
		redlights = true
		print('lights shall be red!')
	if ntwRNG < notwistedsChance:
		notwisteds = true
		print('no twisteds!')
#endregion
