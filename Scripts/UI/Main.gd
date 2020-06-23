extends Control

#const OptionsPopup = preload("res://Scenes/OptionsPopup.tscn")
var freecoins_popup


onready var coins_label = $CoinsBox/MarginContainer/CoinsBox/CoinsLabel
onready var free_label = $FreeBox/MarginContainer/HBoxContainer/FreeLabel
onready var free_button = $FreeBox/MarginContainer/HBoxContainer/FreeButton
onready var free_coins_timer:Timer = $Timer


signal free_coins_watched()

var count_down_time = 60#2*60*60 # 2 hours
var current_time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Admob.load_banner()
	$Admob.load_rewarded_video()
	$Admob.banner_resize()
	coins_label.text = str(LocalSettings.get_setting("coins", 0))

	connect("free_coins_watched", self, "_on_free_coins_watched")
	free_coins_timer.connect("timeout", self, "_on_count_down")
	
	var time = Globals.prev_time + count_down_time <= OS.get_unix_time()
	if Globals.prev_time and !time:
		free_label.text = Globals.time_to_string(Globals.prev_time, count_down_time)
#		free_button.disabled = true
		free_coins_timer.start()
	
	else:
		free_label.text = "FREE_COINS"
#		free_button.disabled = false
		Globals.prev_time = 0


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/UI/Level.tscn")


func _on_ShopButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/UI/Shop.tscn")


func _on_FreeButton_pressed() -> void:
	if $Admob.is_rewarded_video_loaded():
		freecoins_popup = preload("res://Scenes/UI/FreeCoinsPopup.tscn").instance()
		add_child(freecoins_popup)

func _on_free_coins_watched() -> void:
	free_button.disabled = true
	free_coins_timer.start()
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
#		free_button.disabled = false
		$Admob.load_rewarded_video()
		free_label.text = "FREE_COINS"
		LocalSettings.set_setting("prev_time", 0)
		Globals.prev_time = 0


func _on_ChallengeButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/ChallengeGame.tscn")


func _on_Admob_rewarded(currency, ammount) -> void:
	var coins = LocalSettings.get_setting("coins", 0) + 25
	var pt = OS.get_unix_time()
	
	LocalSettings.set_setting("coins", coins)
	LocalSettings.set_setting("prev_time", pt)
	
	Globals.prev_time = pt
	emit_signal("free_coins_watched")


func _on_Admob_rewarded_video_loaded() -> void:
	if free_coins_timer.is_stopped():
		free_button.disabled = false
	print("rewarded load")


func _on_Admob_rewarded_video_failed_to_load(error_code) -> void:
	$Admob.load_rewarded_video()


func _on_Admob_rewarded_video_closed() -> void:
	$Admob.load_rewarded_video()
