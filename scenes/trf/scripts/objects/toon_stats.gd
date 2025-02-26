extends Control

@onready var healthStat = $"Stats Array/Health/level"
@onready var skillStat = $"Stats Array/Skill Check/level"
@onready var speedStat = $"Stats Array/Movement/level"
@onready var staminaStat = $"Stats Array/Stamina/level"
@onready var breathStat = $"Stats Array/Breathing/level"
@onready var extractStat = $"Stats Array/Extraction/level"

#region Stats
@export var main = false
@export var skillcheck = 3
@export var movement = 3
@export var stamina = 3
@export var breathing = 3
@export var extraction = 3
@export var activeAbility:Array = ['','',1]
@export var passiveAbility:Array = ['','']
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !main:
		healthStat.visible_ratio = 1
	else:
		healthStat.visible_ratio = 0.67
	skillStat.visible_ratio = 0.2 * skillcheck
	speedStat.visible_ratio = 0.2 * movement
	staminaStat.visible_ratio = 0.2 * stamina
	breathStat.visible_ratio = 0.2 * breathing
	extractStat.visible_ratio = 0.2 * extraction
