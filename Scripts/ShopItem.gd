tool
extends TextureButton

export(Texture) var ball_texture 
export(String) var ball_name = ""
export(bool) var rewarded = false
export(int) var coins = 0
export(bool) var selected = false
export(bool) var buyed = false


onready var buy_type = $Rect/HBoxContainer/BuyType
onready var value = $Rect/HBoxContainer/Value
onready var buyed_texture = $Buyed
onready var selected_texture = $Selected

onready var tween:Tween = $Tween
onready var animation:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = ball_texture
	self.state_update()
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func state_update() -> void:
	if selected:
		selected_texture.visible = true
		buyed_texture.visible = false
		$Rect/HBoxContainer.visible = false
		animation.play("bounce")
		
	elif buyed:
		selected_texture.visible = false
		buyed_texture.visible = true
		$Rect/HBoxContainer.visible = false
		animation.stop()

	else:
		if rewarded:
			buy_type.texture = load("res://UI/FreeCoins/videoplayer48.png")
			value.text = "Free"
			
		else:
			value.text = str(coins)

func _on_ShopItem_pressed() -> void:
	LocalSettings.load()
	var total_coins = LocalSettings.get_setting("coins", 0)
	if !selected and buyed:
		selected = true
		LocalSettings.set_setting("selected_ball", ball_name)
		LocalSettings.save()
#		self.state_update()
		get_node("/root/Shop").emit_signal("balls_state_update")
		return
	
	if rewarded and !buyed:
		if !get_node("/root/Shop/Admob").is_rewarded_video_loaded():
			print("reklam yüklü değil")
			return
		var watchbuy = preload("res://Scenes/UI/ItemWatchAndBuy.tscn").instance()
		watchbuy.ball = $Sprite.texture
		watchbuy.title = ball_name
		get_node("/root/Shop").add_child(watchbuy)
		return

	if total_coins >= coins and !buyed:
		var coinsbuy = preload("res://Scenes/UI/ItemBuy.tscn").instance()
		coinsbuy.ball = $Sprite.texture
		coinsbuy.title = ball_name
		coinsbuy.coins = coins
		get_node("/root/Shop").add_child(coinsbuy)
		return
	
	else:
		print("paran yok")
	

