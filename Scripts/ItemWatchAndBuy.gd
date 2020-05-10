extends Control


export(String) var title
export(Texture) var ball

onready var window_title = $Window/Title
onready var sprite = $Window/ShopItem/Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window_title.text = title
	sprite.texture = ball


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_CloseButton_pressed() -> void:
	queue_free()


func _on_BuyButton_pressed() -> void:
	var admob := get_parent().get_node("Admob")
	admob.show_rewarded_video()
	get_parent().watched_ball = title
	queue_free()
