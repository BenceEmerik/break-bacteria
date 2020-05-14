tool
extends TextureButton


export(int) var level = 1
export(bool) var lock = true

onready var level_label = $Level
onready var lock_texture = $Lock

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
		self.disabled = false
	
	else:
		lock_texture.visible = true
		level_label.visible = false
		self.disabled = true

func _on_LevelItem_pressed() -> void:
	Globals.level = level
	get_tree().change_scene("res://Scenes/Game.tscn")


