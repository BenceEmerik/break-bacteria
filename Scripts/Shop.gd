extends Control


onready var scroll = $MarginContainer/ScrollContainer
onready var back_button = $Back/MarginContainer/BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/Main.tscn")
