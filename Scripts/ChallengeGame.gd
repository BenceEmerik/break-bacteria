extends Node2D

enum State {
	ACTION,
	DELETED_ITEM_CLEAR,
	ERASE
	ROW_DOWN,
	ADD_ROW,
	IDLE
}



signal screen_clear()
signal turn_completed()
signal challenge_failed()
signal ball_plus()
signal coins_updated()
signal balls_updated()

signal ground_collision(position)

const Ball = preload("res://Scenes/Ball.tscn")

onready var score_label:Label = $HUD/Top/MarginContainer2/ScoreLabel
onready var coins_label:Label = $HUD/Top/MarginContainer3/HBoxContainer/CoinsLabel
onready var bricketgrid := $BricketGrid

onready var spawn:Position2D = $Spawn
onready var new_spawn:Position2D = $NewSpawn
onready var first_line:Line2D = $Spawn/FirstLine
onready var end_line:Line2D = $Spawn/EndLine
onready var first_ray:RayCast2D = $Spawn/FirstRay
onready var end_ray:RayCast2D = $Spawn/EndRay
onready var balls_count:Label = $Spawn/BallsCount
onready var timer:Timer = $Timer
onready var speed_timer:Timer = $SpeedTimer
onready var tween:Tween = $Tween
onready var animation:AnimationPlayer = $AnimationPlayer

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

#her turda bir tane kesin top artırıcı olacak
#arada leveldan yüksek değerde bricket çıkabilir
#özel itemler çıkabilir
# yanlara ışın, 4 yana ışın, kalkan, top küçültücü, üç yöne dağıtıcı, top+
func _ready() -> void:
	LocalSettings.load()
	level = LocalSettings.get_setting("challenge_checkpoints", 1)
	total_balls = level
	score_label.text = str(level)
	coins_label.text = str(LocalSettings.get_setting("coins", 0))
	balls_count.text = "x%d"%(total_balls)
	
	connect("challenge_failed", self, "_on_challenge_failed")
	connect("screen_clear", self, "_on_screen_clear")
	connect("ball_plus", self, "_on_ball_plus")
	connect("coins_updated", self, "_on_coins_updated")
	connect("balls_updated", self, "_on_balls_updated")
	
	first_line.points[0] = first_line.position
	timer.connect("timeout", self, "_on_Ball_Shooting")
	speed_timer.wait_time = 8
	speed_timer.connect("timeout", self, "_on_engine_speed")
	self.connect("ground_collision", self, "_on_Ground_Collision")
	self.connect("turn_completed", self, "_on_Turn_Completed")
	
	bricketgrid.draw_update(level)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _input(event: InputEvent) -> void:
	if turn_complete and event.position.y > 180 and event.position.y < $Spawn.position.y: #burası top ui height boyutu olacak
		if event is InputEventScreenDrag or event is InputEventScreenTouch:
			if has_node("Tutorial"):
				$Tutorial.queue_free()
			var direction = event.position - $Spawn.position
			first_ray.cast_to = direction.normalized() * 2000
			first_ray.force_raycast_update()
			end_ray.clear_exceptions()

			is_angle_valid = direction.angle() < -0.1 and direction.angle() > -3.04

			if first_ray.is_colliding() and is_angle_valid:
				first_line.visible = true
				var collider = first_ray.get_collider()
				end_line.visible = true # tavana değen ilk line da end_line visible false olacağı için bunu yazdık.
				# line pointi yerel olduğundan global olarak nerede olacağının hesabını yapıyoruz
				first_line.points[1] = first_ray.get_collision_point() - first_line.global_position
				end_ray.global_position = first_ray.get_collision_point()
				end_ray.cast_to = first_ray.cast_to.bounce(first_ray.get_collision_normal())
				end_ray.add_exception(first_ray.get_collider())
				end_ray.force_raycast_update()
				
				end_line.points[0] = first_line.points[1]
				end_line.points[1] = end_ray.get_collision_point() - first_line.global_position

			else:
				first_line.visible = false
				end_line.visible = false

		if event is InputEventScreenTouch and not event.pressed and is_angle_valid:
			first_line.visible = false
			end_line.visible = false
			angle = (get_global_mouse_position() - $Spawn.position).angle()
			timer.start()
			turn_complete = false
			animation.play("turn")
			speed_timer.start()

func _on_Ball_Shooting() -> void:
	thrown_balls += 1
	var ball = Ball.instance()
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
	
	if falling_balls >= total_balls or is_extra50:
		tween.interpolate_property(spawn, "position", spawn.position, new_spawn.position, 0.3,
		Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_all_completed")
		emit_signal("turn_completed")
		
#	if $Balls.get_child_count() < 1:
#		emit_signal("turn_completed")
		
func _on_Turn_Completed() -> void:
	if is_extra50:
		total_balls -= 50
		is_extra50 = false
	animation.play("turn_completed")
	speed_timer.stop()
	Engine.time_scale = 1
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
	
func _on_ball_plus() -> void:
	ball_enhancer += 1

func _on_balls_updated() -> void:
	balls_count.text = "x%d"%total_balls

func _on_screen_clear() -> void:
	print("Checkpoint")
	LocalSettings.load()
	LocalSettings.set_setting("challenge_checkpoints", level)
	var best_score = LocalSettings.get_setting("best_challenge_level", 0)
	if level > best_score:
		LocalSettings.set_setting("best_challenge_level", level)
	
	LocalSettings.save()

func _on_challenge_failed() -> void:
	print("oyun bittiiii!!!")
	get_tree().paused = true

func _on_coins_updated() -> void:
	var up_coins = LocalSettings.get_setting("coins", 0)
	coins_label.text = str(up_coins)

func _on_engine_speed() -> void:
	Engine.time_scale *= 2

func _on_ChallengeGame_tree_exited() -> void:
	LocalSettings.load()
	var checkpoint = LocalSettings.get_setting("challenge_checkpoints", 1)
	if level != checkpoint:
		LocalSettings.set_setting("challenge_checkpoints", 1)
	
	LocalSettings.save()


func _on_TakeButton_pressed() -> void:
	timer.stop()
	for ball in $Balls.get_children():
		ball.go_home()

func _on_PauseButton_pressed() -> void:
	pass # Replace with function body.


func _on_AimingButton_pressed() -> void:
	pass # Replace with function body.


func _on_Extra50Button_pressed() -> void:
	var coins =  LocalSettings.get_setting("coins", 0)
	if coins > 20:
		var popup = preload("res://Scenes/UI/SingleBoostBuy.tscn").instance()
#		popup.rect_position = Vector2(540, 960)
		$HUD.add_child(popup)
		get_tree().paused = true
		yield(popup, "ok")
		get_tree().paused = false
		LocalSettings.load()
		LocalSettings.set_setting("coins", LocalSettings.get_setting("coins", 0) - 20)
		LocalSettings.save()
		total_balls += 50
		is_extra50 = true
		emit_signal("coins_updated")
		emit_signal("balls_updated")
	else:
		pass
	print("extra")
	


func _on_BreakBottomButton_pressed() -> void:
	pass # Replace with function body.


func _on_HalveButton_pressed() -> void:
	pass # Replace with function body.
