extends Control

const OptionsPopup = preload("res://Scenes/OptionsPopup.tscn")
const FreeCoinsPopup = preload("res://Scenes/FreeCoinsPopup.tscn")
var options_popup
var freecoins_popup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/Level.tscn")


func _on_ShopButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/Shop.tscn")


func _on_OptionButton_pressed() -> void:
	options_popup = OptionsPopup.instance()
	add_child(options_popup)


func _on_FreeButton_pressed() -> void:
	freecoins_popup = FreeCoinsPopup.instance()
	add_child(freecoins_popup)
