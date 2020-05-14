extends Control


onready var grid_container = $MarginContainer/ScrollContainer/GridContainer
onready var coins_label = $HUD/Coins/MarginContainer/HBoxContainer/Coins

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LocalSettings.load()
	coins_label.text = str(LocalSettings.get_setting("coins", 0))
	var last_level = LocalSettings.get_setting("last_completed_level", 0)
	for i in range(last_level + 1):
		var level = i+1
		var item = grid_container.get_child(i)
		if item.level == level:
			item.lock = false
		# tamamlanmış levellerin puanına göre daireler aktif olacak
		item.state_update()
		


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
