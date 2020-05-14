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

signal ground_collision(position)

const Ball = preload("res://Scenes/Ball.tscn")

onready var score_label = $HUD/Top/MarginContainer2/ScoreLabel
onready var coins_label = $HUD/Top/MarginContainer3/HBoxContainer/CoinsLabel
onready var bricketgrid = $BricketGrid

onready var spawn:Position2D = $Spawn
onready var new_spawn:Position2D = $NewSpawn
onready var first_line:Line2D = $Spawn/FirstLine
onready var end_line:Line2D = $Spawn/EndLine
onready var first_ray:RayCast2D = $Spawn/FirstRay
onready var end_ray:RayCast2D = $Spawn/EndRay
onready var timer:Timer = $Timer
onready var tween:Tween = $Tween

var is_angle_valid:bool
var angle
var thrown_balls = 0
var falling_balls = 0
var turn_complete:bool = true
var first_ball:bool = false

var total_balls:int

var level

#ekran tamamen temizlenince checkpoint oluşacak.
#her turda level artacak
#her turda bir tane kesin top artırıcı olacak
#checkpoint harici çıkarsan checkpointten başlarsın.
#arada leveldan yüksek değerde bricket çıkabilir
#özel itemler çıkabilir
# yanlara ışın, 4 yana ışın, kalkan, top küçültücü, üç yöne dağıtıcı, top+
func _ready() -> void:
	LocalSettings.load()
	level = LocalSettings.get_setting("challenge_checkpoints", 1)
	total_balls = level
	score_label.text = str(level)
	coins_label.text = str(LocalSettings.get_setting("coins", 0))
	
	connect("challenge_failed", self, "_on_challenge_failed")
	connect("screen_clear", self, "_on_screen_clear")
	connect("turn_completed", self, "_on_turn_completed")
	
	first_line.points[0] = first_line.position
	timer.connect("timeout", self, "_on_Ball_Shooting")
	self.connect("ground_collision", self, "_on_Ground_Collision")
	self.connect("turn_completed", self, "_on_Turn_Completed")
	
	bricketgrid.add_row(1)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_turn_completed() -> void:
	level += 1
	score_label.text = str(level)
	
func _input(event: InputEvent) -> void:
	if turn_complete:
		if event is InputEventScreenDrag or event is InputEventScreenTouch:
			var direction = event.position - $Spawn.position
			first_ray.cast_to = direction.normalized() * 2000
			first_ray.force_raycast_update()
			end_ray.clear_exceptions()

			is_angle_valid = direction.angle() < -0.1 and direction.angle() > -3.04

			if first_ray.is_colliding() and is_angle_valid:
				first_line.visible = true
				var collider = first_ray.get_collider()
#				if not collider.name == "Ceil":
				end_line.visible = true # tavana değen ilk line da end_line visible false olacağı için bunu yazdık.
				# line pointi yerel olduğundan global olarak nerede olacağının hesabını yapıyoruz
				first_line.points[1] = first_ray.get_collision_point() - first_line.global_position
				end_ray.global_position = first_ray.get_collision_point()
				end_ray.cast_to = first_ray.cast_to.bounce(first_ray.get_collision_normal())
				end_ray.add_exception(first_ray.get_collider())
				end_ray.force_raycast_update()
				
				end_line.points[0] = first_line.points[1]
				end_line.points[1] = end_ray.get_collision_point() - first_line.global_position

#				else:
#					first_line.points[1] = first_ray.get_collision_point() - first_line.global_position
#					end_line.visible = false

			else:
				first_line.visible = false
				end_line.visible = false

		if event is InputEventScreenTouch and not event.pressed and is_angle_valid:
			first_line.visible = false
			end_line.visible = false
			angle = (get_global_mouse_position() - $Spawn.position).angle()
			timer.start()
			turn_complete = false

func _on_Ball_Shooting() -> void:
	thrown_balls += 1
	var ball = Ball.instance()
	add_child(ball)
	ball.position = $Spawn.position
	ball.start(angle)
	$Spawn/BallCount.text = "x%d"%(total_balls-thrown_balls)
	
	if thrown_balls >= total_balls:
		$Spawn/BallCount.visible = false
		timer.stop()

func _on_Ground_Collision(pos) -> void:
	falling_balls += 1
	if !first_ball:
		print(pos)
		new_spawn.position.x = pos.x
		new_spawn.visible = true
		first_ball = true
	
	if falling_balls >= total_balls:
		tween.interpolate_property(spawn, "position", spawn.position, new_spawn.position, 0.3,
		Tween.TRANS_SINE, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_all_completed")
		emit_signal("turn_completed")
		
func _on_Level_Started() -> void:
	print_debug("level start")

func _on_Level_Completed() -> void:
	print("level complete")

func _on_Level_Failed() -> void:
	print("level failed")

func _on_Turn_Completed() -> void:
	new_spawn.visible = false
	thrown_balls = 0
	falling_balls = 0
	first_ball = false
	$Spawn/BallCount.text = "x%d"%(total_balls-thrown_balls)
	$Spawn/BallCount.visible = true
	turn_complete = true
