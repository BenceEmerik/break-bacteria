extends Control


onready var grid_container = $MarginContainer/ScrollContainer/GridContainer
onready var coins_label = $HUD/Coins/MarginContainer/HBoxContainer/Coins

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LocalSettings.load()
	coins_label.text = str(LocalSettings.get_setting("coins", 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/Main.tscn")


func _notification(what: int) -> void:
	match what:
		MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
			self._on_BackButton_pressed()
			
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			self._on_BackButton_pressed()
