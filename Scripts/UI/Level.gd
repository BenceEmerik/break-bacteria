extends Control


onready var grid_container:GridContainer = $MarginContainer/ScrollContainer/GridContainer
onready var coins_label:Label = $HUD/Coins/MarginContainer/HBoxContainer/Coins
onready var subtitle:Label = $HUD/Title/MarginContainer/VBoxContainer/SubTitle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_label.text = str(LocalSettings.get_setting("coins", 0))
	var last_level = LocalSettings.get_setting("last_completed_level", 0)
	subtitle.text = "%d/%d"%[last_level, grid_container.get_child_count()]
	for i in range(1, last_level + 1):
		print(i)
		var level = i
		var item = grid_container.get_child(i-1)
		if item.level == level:
			item.lock = false
		# tamamlanmış levellerin puanına göre daireler aktif olacak
		item.state_update()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/UI/Main.tscn")


func _notification(what: int) -> void:
	match what:
		MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
			self._on_BackButton_pressed()
			
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			self._on_BackButton_pressed()
