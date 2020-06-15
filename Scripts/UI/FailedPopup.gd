extends Control


signal ok

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_HomeButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/UI/Main.tscn")


func _on_WatchButton_pressed() -> void:
	var parent = get_tree().current_scene
	if parent.is_ads_ready:
		parent.get_node("Admob").show_rewarded_video()
	parent.emit_signal("admob_type", "continue")
	emit_signal("ok")
	queue_free()

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
