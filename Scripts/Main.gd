extends Control

#const OptionsPopup = preload("res://Scenes/OptionsPopup.tscn")
var freecoins_popup


onready var coins_label = $CoinsBox/MarginContainer/CoinsBox/CoinsLabel
onready var free_label = $FreeBox/MarginContainer/HBoxContainer/FreeLabel
onready var free_button = $FreeBox/MarginContainer/HBoxContainer/FreeButton


signal free_coins_watched()

var free_coins_timer:Timer = Timer.new()
var count_down_time = 60#2*60*60 # 2 hours
var current_time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Admob.load_banner()
	$Admob.load_rewarded_video()
	
	add_child(free_coins_timer)
	free_coins_timer.wait_time = 1
	
	LocalSettings.load()
	coins_label.text = str(LocalSettings.get_setting("coins", 0))

	connect("free_coins_watched", self, "_on_free_coins_watched")
	free_coins_timer.connect("timeout", self, "_on_count_down")
#	free_coins_timer.start()

	if Globals.prev_time:
		free_label.text = Globals.time_to_string(Globals.prev_time, count_down_time)
		free_button.disabled = true
		free_coins_timer.start()
	
	else:
		free_label.text = "Free Coins"
		free_button.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/UI/Level.tscn")


func _on_ShopButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/UI/Shop.tscn")


#func _on_OptionButton_pressed() -> void:
#	options_popup = OptionsPopup.instance()
#	add_child(options_popup)


func _on_FreeButton_pressed() -> void:
	if $Admob.is_rewarded_video_loaded():
		freecoins_popup = preload("res://Scenes/UI/FreeCoinsPopup.tscn").instance()
		add_child(freecoins_popup)

func _on_free_coins_watched() -> void:
	LocalSettings.load()
	free_coins_timer.start()
	free_button.disabled = true
	freecoins_popup.queue_free()
	coins_label.text = str(LocalSettings.get_setting("coins", 0))

func _notification(what: int) -> void:
	match what:
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			get_tree().quit()
		
		MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
			get_tree().quit()

func _on_count_down() -> void:
	var current_time = OS.get_unix_time()
	free_label.text = Globals.time_to_string(Globals.prev_time, count_down_time)
	
	if Globals.prev_time + count_down_time <= current_time:
		free_coins_timer.stop()
		free_button.disabled = false
		free_label.text = "Free Coins"
		LocalSettings.set_setting("prev_time", 0)
		Globals.prev_time = 0
		LocalSettings.save()


func _on_ChallengeButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/ChallengeGame.tscn")


func _on_Admob_rewarded(currency, ammount) -> void:
	print(currency, ammount)
	LocalSettings.load()
	var coins = LocalSettings.get_setting("coins", 0) + 25
	var pt = OS.get_unix_time()
	
	LocalSettings.set_setting("coins", coins)
	LocalSettings.set_setting("prev_time", pt)
	LocalSettings.save()
	
	Globals.prev_time = pt
	emit_signal("free_coins_watched")


func _on_Admob_rewarded_video_loaded() -> void:
	print("rewarded load")


func _on_Admob_rewarded_video_failed_to_load(error_code) -> void:
	print("err %s"%error_code)
