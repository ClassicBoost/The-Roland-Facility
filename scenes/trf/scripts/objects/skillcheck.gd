extends Control

#region Variables
@onready var player = get_owner().get_node("player")
@export var activateSkillCheck:bool = false
@onready var stupidarealul = get_node("bar/collabarea/collabarea/stupidarea")
var moveTimer:float = 0.75
var moveBar:bool = false

var inMarker:bool = false

var setSkillSize:int = 150

@export var tempSC:int = 3

var lengthinSkillCheck:float = 0

@onready var marker = $bar/marker
@onready var collabarea = $bar/collabarea/collabarea/stupidarea/c2
@onready var collab = $bar/collabarea
@onready var hitText = $skillcheckhit

@onready var audio = $audio

var annoyingAss = [12, 25, 38, 51, 63]
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	marker.position.x = 320
	hitText.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activateSkillCheck:
		moveTimer -= 1 * delta
	
	setSkillSize = player.skillcheck * 25
	
	collab.size = Vector2(setSkillSize, 48)
	collab.scale.x = 1
	collabarea.shape.size = Vector2(setSkillSize, 48)
	
	if hitText.modulate.a > 0:
		hitText.modulate.a -= 1 * delta
	else:
		hitText.hide()
	
	if activateSkillCheck:
		lengthinSkillCheck += 1 * delta
		$SkillCheck.show()
		$bar.show()
		if moveTimer > 0.25:
			$bar.position.y -= 100 * delta
			$bar.modulate.a += 2 * delta
	else:
		$SkillCheck.hide()
		$bar.hide()
		$bar.position.y = 50
		$bar.modulate.a = 0
	
	if lengthinSkillCheck > 3.9:
		hit_skillcheck()
	
	if moveTimer < 0 and activateSkillCheck:
		moveBar = true
	else:
		marker.position.x = 317
	
	if moveBar:
		marker.position.x += 200 * delta
	
	$bar/collabarea/collabarea/stupidarea.position.x = annoyingAss[player.skillcheck-1]
	
	if Input.is_action_just_pressed("accept") and moveBar and activateSkillCheck:
		hit_skillcheck()
	
	if Input.is_action_just_pressed("debug1") and OS.is_debug_build():
		popupSkill()

func popupSkill():
	audio.stream = load("res://assets/audio/sounds/skillcheck/popup.ogg")
	audio.play()
	hitText.hide()
	activateSkillCheck = true
	var stupid = randi_range(400, 700)
	collab.position.x = stupid

func hit_skillcheck():
	activateSkillCheck = false
	moveTimer = 0.75
	hitText.modulate.a = 2
	hitText.show()
	moveBar = false
	if stupidarealul.inMarker:
		audio.stream = load("res://assets/audio/sounds/skillcheck/hit.ogg")
		hitText.text = 'Nice'
		hitText.set("theme_override_colors/font_color",Color(1.0,1.0,1.0,1.0))
		print('hit!')
	else:
		audio.stream = load("res://assets/audio/sounds/skillcheck/fail.ogg")
		hitText.text = 'Careful they can hear you.'
		hitText.set("theme_override_colors/font_color",Color(1.0,0.0,0.0,1.0))
		print('miss')
	inMarker = false
	audio.play()
	lengthinSkillCheck = 0
