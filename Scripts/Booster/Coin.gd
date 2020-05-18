extends Area2D
class_name Coin

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Coin_body_entered(body: Node) -> void:
	if body is Ball:
		LocalSettings.load()
		LocalSettings.set_setting("coins", LocalSettings.get_setting("coins", 0) + 1)
		LocalSettings.save()
		get_tree().current_scene.emit_signal("coins_updated")
		queue_free()
#		var coins = LocalSettings.get_setting("coins", 0) + 1
#		LocalSettings.set_setting("coins", coins)
#		LocalSettings.save()
