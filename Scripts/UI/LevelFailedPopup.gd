extends Control

export(int) var level:int = 1

onready var title:Label = $Window/Title

signal ok

func _ready() -> void:
	title.text = "Level %d"%level


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_CloseButton_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_HomeButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/UI/Main.tscn")


func _on_RetryButton_pressed() -> void:
	get_tree().reload_current_scene()


func _on_ContinueButton_pressed() -> void:
	get_tree().current_scene.emit_signal("ad_popup")
	queue_free()
