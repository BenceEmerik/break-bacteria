tool
extends TextureButton


export(int) var level = 1
export(bool) var lock = true

onready var level_label = $Level
onready var lock_texture = $Lock
onready var circle1 = $MarginContainer/HBoxContainer/circle1
onready var circle2 = $MarginContainer/HBoxContainer/circle2
onready var circle3 = $MarginContainer/HBoxContainer/circle3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_label.text = str(level)
	state_update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func state_update() -> void:
	if !lock:
		lock_texture.visible = false
		level_label.visible = true
		disabled = false
		var stat:Dictionary = LocalSettings.get_setting("completed_levels", {})
		
		if stat.has(str(level)):
			stat = stat[str(level)]
			var circle
			if stat.has("circle"):
				circle = int(stat["circle"])
				match circle:
					1:
						circle1.texture = load("res://UI/star-yes48.png")
					2:
						circle1.texture = load("res://UI/star-yes48.png")
						circle2.texture = load("res://UI/star-yes48.png")
					3:
						circle1.texture = load("res://UI/star-yes48.png")
						circle2.texture = load("res://UI/star-yes48.png")
						circle3.texture = load("res://UI/star-yes48.png")
	
	else:
		lock_texture.visible = true
		level_label.visible = false
		self.disabled = true

	

func _on_LevelItem_pressed() -> void:
	Globals.level = level
	get_tree().change_scene("res://Scenes/Game.tscn")


