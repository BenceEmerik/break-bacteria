extends Control

signal ok

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_CloseButton_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_BuyButton_pressed() -> void:
	var parent = get_tree().current_scene
	if parent.is_ads_ready:
		parent.get_node("Admob").show_rewarded_video()
	parent.emit_signal("admob_type", "buy")
	emit_signal("ok")
	queue_free()
