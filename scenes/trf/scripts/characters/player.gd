extends CharacterBody2D

@onready var scthing = get_owner().get_node("HUD/skillcheck")
var input_direction = Vector2(0,0)

@export var toonName:String = ""

var moveSpeed:float = 15
var sprinting = 0

#region Stats
@export var main = false
var maxHealth = 3
@export var skillcheck = 3
@export var movement = 3
@export var stamina = 3
@export var breathing = 3 # like stealth, but through certain objects ig. 5 is like no breath radius or somethin.
@export var extraction = 3
var breathRadius = [2, 1.5, 1.2, 1, 0.65, 0.3]
@export var health = 3
var actualStam:float = 150
var actualmaxStam = 150
var curStam:float = 150
var maxStam = 150

@export var activeAbility:Array = ['','',1]
@export var passiveAbility:Array = ['','']
#endregion
#region Multipliers
@export var stamMultiplier = 1.0
@export var stamregenMultiplier = 1.0
@export var extractMultiplier = 1.0
@export var skillcheckwindowMultiplier = 1.0
@export var skillcheckChance = 0.25
var skillcheckValue = 1.0
@export var walkMultiplier = 1.0
@export var runMultiplier = 1.0
#endregion

var disableSprint = false
@export var money:int = 0
var coolDownTimer = 1.0

var bitchDead = false
var deathTimer = 1

var skillChanceTimer = 1

@onready var breatheRange = $breath/breathingRadius
@export var onMachine:bool = false

func _ready():
	loadToon(toonName)

func _physics_process(delta):
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if main:
		maxHealth = 2
	else:
		maxHealth = 3
		
	if onMachine and not scthing.activateSkillCheck:
		skillChanceTimer -= 1 * delta
		if skillChanceTimer < 0:
			var rng = randf_range(0, 1)
			if rng <= skillcheckChance:
				scthing.popupSkill()
			skillChanceTimer = 1
		
	if Input.is_action_just_pressed("interact") and onMachine:
		onMachine = false
		if scthing.activateSkillCheck:
			scthing.hit_skillcheck()
	
	if health <= 0:
		hide()
		deathTimer -= 1 * delta
		if deathTimer < 0:
			get_tree().change_scene_to_file("res://scenes/trf/gameover.tscn")
		return
	
	if health > maxHealth:
		health = maxHealth
	
	if coolDownTimer > 0:
		coolDownTimer -= 1 * delta
	
	breatheRange.scale = Vector2(breathRadius[breathing],breathRadius[breathing])
	
	moveSpeed = 7.5 + (movement * 2.5)
	actualmaxStam = 75 + (stamina * 25)
	
	maxStam = actualmaxStam * stamMultiplier
	
	
	if (Input.get_action_strength("sprint") and !disableSprint) and (self.velocity.x != 0 or self.velocity.y != 0):
		velocity = (input_direction * (((moveSpeed+10) * 10)) * runMultiplier) * (delta * 90)
		curStam = curStam - (8*delta)
		if (curStam <= 0):
			disableSprint = true
	else:
		velocity = (input_direction * ((moveSpeed * 10)) * walkMultiplier) * (delta * 90)
		if (curStam < maxStam):
			if (self.velocity.x == 0 and self.velocity.y == 0):
				curStam = curStam + ((3.8*delta)*stamregenMultiplier)
			else:
				curStam = curStam + ((1.2*delta)*stamregenMultiplier)
			
			if (curStam > (maxStam * 0.15)):
				disableSprint = false
	
	if curStam > maxStam:
		curStam = maxStam
		
	if not onMachine:
		move_and_slide()
	
	funnyAbility(delta)
	breathe(delta)

func _on_test_area_lol_area_entered(_area):
	print('ahhh')

#region breathing
var breatheTimer:float = 0
func breathe(delta):
	breatheTimer -= 1 * delta
	
	if breatheTimer < 0 and not onMachine:
		breatheRange.disabled = false # Breathe Audio
		if breatheTimer <= -1:
			if (curStam/maxStam) > 0.2: # Under 20% Stamina.
				breatheTimer = 2
			else:
				breatheTimer = 0 # HEAVY ASS BREATHING
	else:
		breatheRange.disabled = true # No Audio
#endregion

#region ability spam
var floatydashability = [0, false]
func funnyAbility(delta):
	if Input.is_action_just_pressed("activeability") and coolDownTimer < 0:
		match activeAbility[0]:
			'Self-Die':
				health = -99
			'Floaty Dash':
				#effectApply('walk', 0.5, 2)
				#effectApply('run', 0.5, 2)
				floatydashability[0] = 1
				walkMultiplier += 2
				runMultiplier += 2
				floatydashability[1] = true
				breatheTimer = 0
		
		coolDownTimer = activeAbility[2]
	
	floatydashability[0] -= 1 * delta
	if floatydashability[0] < 0 and floatydashability[1] == true:
		walkMultiplier -= 2
		runMultiplier -= 2
		floatydashability[1] = false
	
	match passiveAbility[0]:
		'Glutton':
			breathing = 0
#endregion

#region effects
func effectApply(_length, _type, _ampifier):
	pass
#endregion

#region Toon Data
func loadToon(nam):
	var toonInfo:String
	if nam != "":
		toonInfo = "res://packages/toons/data/" + nam.to_lower() + ".json"
	else:
		toonInfo = "res://packages/toons/data/template.json"
	
	if FileAccess.file_exists(toonInfo):
		var file = FileAccess.open(toonInfo, FileAccess.READ)
		var json = file.get_as_text()
		
		var saved_data = JSON.parse_string(json)
		
		toonName = saved_data["name"]
		
		main = saved_data["main"]
		skillcheck = saved_data["skillcheck"]
		movement = saved_data["movement"]
		stamina = saved_data["stamina"]
		breathing = saved_data["breath"]
		extraction = saved_data["extraction"]
		skillcheckChance = saved_data["skillchance"]
		
		activeAbility[0] = saved_data["active"][0]
		activeAbility[1] = saved_data["active"][1]
		activeAbility[2] = saved_data["active"][2]
		passiveAbility[0] = saved_data["passive"][0]
		passiveAbility[1] = saved_data["passive"][1]
		
		file.close()
#endregion
