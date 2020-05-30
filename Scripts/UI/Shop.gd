extends Control


onready var scroll = $MarginContainer/ScrollContainer
onready var container = $MarginContainer/ScrollContainer/GridContainer
onready var coins_label = $HUD/Coins/MarginContainer/HBoxContainer/Coins
onready var back_button = $HUD/Back/MarginContainer/BackButton

var selected_ball
var buyed_balls
var buyed_ball:String

signal balls_state_update()
signal coins_changed()
signal buyed_ball(ballname)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Admob.load_rewarded_video()
	coins_label.text = str(LocalSettings.get_setting("coins", 0))
	selected_ball = LocalSettings.get_setting("selected_ball", "default")
	buyed_balls = LocalSettings.get_setting("buyed_balls", ["default"])
	
	print(selected_ball, buyed_balls)
	self.items_update()
	
	connect("coins_changed", self, "_on_coins_changed")
	connect("balls_state_update", self, "items_update")
	connect("buyed_ball", self, "_on_buyed_ball")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func items_update() -> void:
	selected_ball = LocalSettings.get_setting("selected_ball", "default")
	buyed_balls = LocalSettings.get_setting("buyed_balls", ["default"])
	
	
	for shopitem in container.get_children():
		if shopitem.ball_name == selected_ball:
			shopitem.selected = true
		
		else: shopitem.selected = false
		
		if shopitem.ball_name in buyed_balls:
			shopitem.buyed = true
		
		else: shopitem.buyed = false
		
		shopitem.state_update()


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/UI/Main.tscn")


func _notification(what: int) -> void:
	match what:
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			self._on_BackButton_pressed()
		
		MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
			self._on_BackButton_pressed()

func _on_coins_changed() -> void:
	coins_label.text = str(LocalSettings.get_setting("coins", 0))

func _on_buyed_ball(ballname) -> void:
	var b = LocalSettings.get_setting("buyed_balls", ["antikor"])
	b.append(ballname)
	LocalSettings.set_setting("buyed_balls", b)
	self.items_update()

func _on_Admob_rewarded(currency, ammount) -> void:
	pass
#	var b = LocalSettings.get_setting("buyed_balls", ["antikor"])
#	b.append(buyed_ball)
#	LocalSettings.set_setting("buyed_balls", b)
#	buyed_ball = ""
#	self.items_update()
#	emit_signal("buyed_ball", buyed_ball)
	


func _on_Admob_rewarded_video_failed_to_load(error_code) -> void:
	print("errr %s"%error_code)
	$Admob.load_rewarded_video()


func _on_Admob_rewarded_video_loaded() -> void:
	print("items enabled")


func _on_Admob_rewarded_video_closed() -> void:
	print("kapandı. items disabled")
	$Admob.load_rewarded_video()
