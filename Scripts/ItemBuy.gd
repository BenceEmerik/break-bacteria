extends Control


export(String) var title
export(Texture) var ball
export(int) var coins

onready var window_title = $Window/Title
onready var sprite = $Window/ShopItem/Sprite
onready var coins_label = $Window/BuyButton/Container/Container/Coins


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_title.text = title
	sprite.texture = ball
	coins_label.text = str(coins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_CloseButton_pressed() -> void:
	queue_free()


func _on_BuyButton_pressed() -> void:
	LocalSettings.load()
	var total_coins = LocalSettings.get_setting("coins", 0)
	LocalSettings.set_setting("coins", total_coins-coins)
	LocalSettings.save()
	get_parent().emit_signal("coins_changed")
	queue_free()

