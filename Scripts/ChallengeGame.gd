extends Node2D


signal screen_clear()
signal turn_completed()
signal challenge_failed()
signal ball_plus()
signal coins_updated()
signal balls_updated()
signal ground_collision(pos)
signal collision_lines(points)
signal retry_level()
signal admob_type(type)

const Ball = preload("res://Scenes/Ball.tscn")

onready var score_label:Label = $HUD/Top/MarginContainer2/ScoreLabel
onready var coins_label:Label = $HUD/Top/MarginContainer3/HBoxContainer/CoinsLabel
onready var extra_button:TextureButton = $HUD/Down/MarginContainer/HBoxContainer/Extra50Button
onready var aiming_button:TextureButton = $HUD/Down/MarginContainer/HBoxContainer/AimingButton
onready var bricketgrid := $BricketGridChallenge

onready var spawn:Position2D = $Spawn
onready var new_spawn:Position2D = $NewSpawn
onready var first_line:Line2D = $Spawn/FirstLine
onready var end_line:Line2D = $Spawn/EndLine
onready var booster_line:Line2D = $Spawn/BoosterLine
onready var balls_count:Label = $Spawn/BallsCount
onready var timer:Timer = $Timer
onready var speed_timer:Timer = $SpeedTimer
onready var ad_timer:Timer = $AdTimer
onready var tween:Tween = $Tween
onready var animation:AnimationPlayer = $AnimationPlayer
onready var test_ball = preload("res://Scenes/TestBall.tscn")

onready var spawn_ball:Sprite = $Spawn/Ball
onready var new_spawn_ball:Sprite = $NewSpawn/Ball

var is_angle_valid:bool
var angle:float
var thrown_balls:int
var falling_balls:int
var turn_complete:bool = true
var first_ball:bool = false
var total_balls:int
var ball_enhancer:int
var level:int
var is_extra50:bool
var is_aiming:bool
var is_ads_ready:bool
var is_inter_ready:bool
var what_admob_type:String
var ball_texture

func _ready() -> void:
	$Admob.load_banner()
	$Admob.load_interstitial()
	$Admob.load_rewarded_video()
	level = LocalSettings.get_setting("challenge_checkpoints", 1)
	total_balls = level
	score_label.text = str(level)
	coins_label.text = str(LocalSettings.get_setting("coins", 0))
	balls_count.text = "x%d"%(total_balls)
	
	animation.play("turn_completed")
	bricketgrid.draw_update(level)
	
	ball_texture = load("res://Sprites/Balls/%s.png"%LocalSettings.get_setting("selected_ball", "antikor"))
	spawn_ball.texture = ball_texture
	new_spawn_ball.texture = ball_texture
	
	get_tree().connect("screen_resized", self, "_window_update")
	timer.connect("timeout", self, "_on_Ball_Shooting")
	speed_timer.connect("timeout", self, "_on_engine_speed")
	ad_timer.connect("timeout", self, "_on_ad_show")
	connect("challenge_failed", self, "_on_challenge_failed")
	connect("screen_clear", self, "_on_screen_clear")
	connect("ball_plus", self, "_on_ball_plus")
	connect("coins_updated", self, "_on_coins_updated")
	connect("balls_updated", self, "_on_balls_updated")
	connect("ground_collision", self, "_on_Ground_Collision")
	connect("turn_completed", self, "_on_Turn_Completed")
	connect("collision_lines", self, "_on_collision_lines")
	connect("retry_level", self, "_on_scene_reload")
	connect("admob_type", self, "_on_admob_type")
	
	var yy = get_viewport_rect().size.y
	$Wall/Ground.position.y = yy - 1920
	bricketgrid.position.y = 180 + yy - 1920
	spawn.position.y = 1535 + yy - 1920
	new_spawn.position.y = 1535 + yy - 1920
	$Tutorial.position.y = 240 + yy - 1920

func _window_update() -> void:
	var yy = get_viewport_rect().size.y
	$Wall/Ground.position.y = yy - 1920
	bricketgrid.position.y = 180 + yy - 1920
	spawn.position.y = 1535 + yy - 1920
	new_spawn.position.y = 1535 + yy - 1920
#	$Tutorial.position.y = 240 + yy - 1920

func _process(delta: float) -> void:
	pass
	

func _input(event: InputEvent) -> void:
	if turn_complete:
		if event is InputEventScreenDrag or event is InputEventScreenTouch and \
		event.position.y > 180 and event.position.y < $Spawn.position.y and event.pressed:
			if find_node("Tutorial", true, false):
				find_node("Tutorial", true, false).queue_free()
			var direction = event.position - $Spawn.position

			is_angle_valid = direction.angle() < -0.1 and direction.angle() > -3.04
			
			var tball = test_ball.instance()
			spawn.add_child(tball)
			tball.start(direction.angle())


		elif event is InputEventScreenTouch and not event.pressed and is_angle_valid and \
		event.position.y > 180 and event.position.y < $Spawn.position.y:
			first_line.visible = false
			end_line.visible = false
			booster_line.visible = false
			angle = (get_global_mouse_position() - $Spawn.position).angle()
			timer.start()
			turn_complete = false
			is_aiming = false
			animation.play("turn")
			speed_timer.start()

func _on_collision_lines(points:PoolVector2Array):
	if turn_complete:
		if is_angle_valid and get_global_mouse_position().y > 180 and \
		get_global_mouse_position().y < $Spawn.position.y:
			first_line.visible = true
			end_line.visible = true
			if is_aiming:
				booster_line.visible = true
			first_line.points[0] = Vector2.ZERO
			first_line.points[1] = points[0] - spawn.global_position
			end_line.points[0] = first_line.points[1]
			end_line.points[1] = points[1] - spawn.global_position
			booster_line.points[0] = end_line.points[1]
			booster_line.points[1] = points[2] - spawn.global_position
		else:
			first_line.visible = false
			end_line.visible = false
			booster_line.visible = false
		
func _on_Ball_Shooting() -> void:
	thrown_balls += 1
	var ball = Ball.instance()
	ball.texture = ball_texture
	$Balls.add_child(ball)
	ball.position = $Spawn.position
	ball.start(angle)
	balls_count.text = "x%d"%(total_balls-thrown_balls)
	
	if thrown_balls >= total_balls:
		balls_count.visible = false
		timer.stop()

func _on_Ground_Collision(pos) -> void:
	falling_balls += 1
	if !first_ball:
		new_spawn.position.x = pos.x
		new_spawn.visible = true
		first_ball = true
	
	if falling_balls >= total_balls:
		tween.interpolate_property(spawn, "position", spawn.position, new_spawn.position, 0.3,
					Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_all_completed")
		emit_signal("turn_completed")

func _on_Turn_Completed() -> void:
	if is_extra50:
		total_balls -= 50
		is_extra50 = false
		extra_button.disabled = false
	
	if is_aiming:
		is_aiming = false
		aiming_button.disabled = false
	
	animation.play("turn_completed")
	speed_timer.stop()
	Engine.time_scale = 1
	$HUD/Speed.visible = false
	new_spawn.visible = false
	thrown_balls = 0
	falling_balls = 0
	first_ball = false
	
	level += 1
	score_label.text = str(level)
	total_balls += ball_enhancer
	ball_enhancer = 0
	balls_count.text = "x%d"%(total_balls)
	balls_count.visible = true
	turn_complete = true
	bricketgrid.draw_update(level)
	if is_inter_ready:
		$Admob.show_interstitial()
		is_inter_ready = false
		$Admob.load_interstitial()
	
func _on_ball_plus() -> void:
	ball_enhancer += 1

func _on_balls_updated() -> void:
	balls_count.text = "x%d"%total_balls

func _on_screen_clear() -> void:
	var best_score = LocalSettings.get_setting("best_challenge_level", 0)
	if GPlay.play_game.isSignedIn():
		if level > best_score:
			GPlay.play_game.submitLeaderBoardScore("CgkIzqrC9pwQEAIQAQ", level)
		if level > 10:
			GPlay.play_game.unlockAchievement("CgkIzqrC9pwQEAIQBw")
	$HUD/Center.visible = true
	LocalSettings.set_setting("challenge_checkpoints", level)
	if level > best_score:
		LocalSettings.set_setting("best_challenge_level", level)
	
	yield(get_tree().create_timer(2), "timeout")
	$HUD/Center.visible = false

func _on_challenge_failed() -> void:
	var failed = preload("res://Scenes/UI/FailedPopup.tscn").instance()
	$HUD.add_child(failed)
	get_tree().paused = true
	yield(failed, "ok")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	get_tree().paused = false
	emit_signal("coins_updated")

func _on_coins_updated() -> void:
	var up_coins = LocalSettings.get_setting("coins", 0)
	coins_label.text = str(up_coins)

func _on_engine_speed() -> void:
	Engine.time_scale *= 2
	$HUD/Speed.visible = true

func _on_ChallengeGame_tree_exited() -> void:
	if Globals.reload_level:
		return
	
	var checkpoint = LocalSettings.get_setting("challenge_checkpoints", 1)
	if level != checkpoint:
		LocalSettings.set_setting("challenge_checkpoints", 1)
	Globals.reload_level = 0


func _on_TakeButton_pressed() -> void:
	timer.stop()
	for ball in $Balls.get_children():
		ball.go_home()
	
	falling_balls += total_balls - thrown_balls
	if Engine.time_scale > 1:
		Engine.time_scale = 1
		$HUD/Speed.visible = false

func _on_PauseButton_pressed() -> void:
	var popup = preload("res://Scenes/UI/PausePopup.tscn").instance()
	$HUD.add_child(popup)
	get_tree().paused = true
	yield(popup, "ok")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	get_tree().paused = false
	emit_signal("coins_updated")
	emit_signal("balls_updated")

func _on_scene_reload():
	Globals.reload_level = level
	get_tree().reload_current_scene()

func _on_AimingButton_pressed() -> void:
	var coins =  LocalSettings.get_setting("coins", 0)
	if coins > 9:
		var popup = preload("res://Scenes/UI/SingleBoostBuy.tscn").instance()
		popup._subtitle = "AIMING"
		popup.coin = 10
		$HUD.add_child(popup)
		get_tree().paused = true
		yield(popup, "ok")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		get_tree().paused = false
		LocalSettings.set_setting("coins", LocalSettings.get_setting("coins", 0) - 10)
		is_aiming = true
		aiming_button.disabled = true
		emit_signal("coins_updated")
		emit_signal("balls_updated")
	else:
		var missing = preload("res://Scenes/UI/CoinsMissing.tscn").instance()
		$HUD.add_child(missing)
		get_tree().paused = true
		yield(missing, "ok")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		get_tree().paused = false
		emit_signal("coins_updated")


func _on_Extra50Button_pressed() -> void:
	var coins =  LocalSettings.get_setting("coins", 0)
	if coins > 19:
		var popup = preload("res://Scenes/UI/SingleBoostBuy.tscn").instance()
		popup.coin = 20
		popup._subtitle = "EXTRA"
		$HUD.add_child(popup)
		get_tree().paused = true
		yield(popup, "ok")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		get_tree().paused = false
		LocalSettings.set_setting("coins", LocalSettings.get_setting("coins", 0) - 20)
		total_balls += 50
		is_extra50 = true
		extra_button.disabled = true
		emit_signal("coins_updated")
		emit_signal("balls_updated")
	else:
		var missing = preload("res://Scenes/UI/CoinsMissing.tscn").instance()
		$HUD.add_child(missing)
		get_tree().paused = true
		yield(missing, "ok")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		get_tree().paused = false
		emit_signal("coins_updated")


func _on_BreakBottomButton_pressed() -> void:
	var coins =  LocalSettings.get_setting("coins", 0)
	if coins > 29:
		var popup = preload("res://Scenes/UI/SingleBoostBuy.tscn").instance()
		popup.coin = 30
		popup._subtitle = "BREAK"
#		popup.rect_position = Vector2(540, 960)
		$HUD.add_child(popup)
		get_tree().paused = true
		yield(popup, "ok")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		get_tree().paused = false
		LocalSettings.set_setting("coins", LocalSettings.get_setting("coins", 0) - 30)
		emit_signal("coins_updated")
		emit_signal("balls_updated")
		bricketgrid.end_row_bricks_kills()
	else:
		var missing = preload("res://Scenes/UI/CoinsMissing.tscn").instance()
		$HUD.add_child(missing)
		get_tree().paused = true
		yield(missing, "ok")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		get_tree().paused = false
		emit_signal("coins_updated")


func _on_HalveButton_pressed() -> void:
	var coins =  LocalSettings.get_setting("coins", 0)
	if coins > 49:
		var popup = preload("res://Scenes/UI/SingleBoostBuy.tscn").instance()
		popup._subtitle = "HALVE"
		popup.coin = 50
		$HUD.add_child(popup)
		get_tree().paused = true
		yield(popup, "ok")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		get_tree().paused = false
		LocalSettings.set_setting("coins", LocalSettings.get_setting("coins", 0) - 50)
		emit_signal("coins_updated")
		bricketgrid.all_bricks_halved()
	else:
		var missing = preload("res://Scenes/UI/CoinsMissing.tscn").instance()
		$HUD.add_child(missing)
		get_tree().paused = true
		yield(missing, "ok")
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		get_tree().paused = false
		emit_signal("coins_updated")

func _notification(what: int) -> void:
	match what:
		MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
			self._on_PauseButton_pressed()
			
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			self._on_PauseButton_pressed()


func _on_ad_show() -> void:
	is_inter_ready = true

func _on_Admob_rewarded_video_failed_to_load(error_code) -> void:
	$Admob.load_rewarded_video()


func _on_Admob_rewarded_video_closed() -> void:
	$Admob.load_rewarded_video()


func _on_Admob_rewarded(currency, ammount) -> void:
	var ty = what_admob_type
	if ty == "continue":
		bricketgrid.end_row_clear()
	if ty == "buy":
		LocalSettings.set_setting("coins", LocalSettings.get_setting("coins", 0) + ammount)
		emit_signal("coins_updated")

func _on_Admob_rewarded_video_loaded() -> void:
	is_ads_ready = true

func _on_admob_type(type:String) -> void:
	what_admob_type = type
