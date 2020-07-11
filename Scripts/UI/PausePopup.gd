extends Control


signal ok()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func _on_CloseButton_pressed() -> void:
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	get_tree().paused = false
	queue_free()


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_HomeButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/UI/Main.tscn")
	get_tree().paused = false


func _on_RetryButton_pressed() -> void:
	get_tree().current_scene.emit_signal("retry_level")
	queue_free()
	get_tree().paused = false
