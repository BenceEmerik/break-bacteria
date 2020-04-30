extends Node2D


const Ball = preload("res://Scenes/Ball.tscn")
onready var spawn:Position2D = $Spawn
onready var first_line:Line2D = $Spawn/FirstLine
onready var end_line:Line2D = $Spawn/EndLine
onready var first_ray:RayCast2D = $Spawn/FirstRay
onready var end_ray:RayCast2D = $Spawn/EndRay
onready var timer:Timer = $Timer

var is_angle_valid:bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	first_line.points[0] = first_line.position
	timer.connect("timeout", self, "_on_Ball_Shooting")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	pass
#	if Input.is_action_just_released("left_click") and is_angle_valid:
#		var balli = ball.instance()
#		balli.position = $Spawn.position
#		add_child(balli)
#		var angle = get_global_mouse_position() - $Spawn.global_position
#		balli.start(angle.angle())
#		line.hide()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or event is InputEventScreenTouch:
		var direction = event.position - $Spawn.position
		first_ray.cast_to = direction.normalized() * 2000
		first_ray.force_raycast_update()
		end_ray.clear_exceptions()
		
		is_angle_valid = abs(direction.angle()) > 0.1 and abs(direction.angle()) < 3.04
		print(direction.angle())
		
		if first_ray.is_colliding() and is_angle_valid:
			first_line.visible = true
			var collider = first_ray.get_collider()
			if not collider.name == "Ceil":
				end_line.visible = true # tavana değen ilk line da end_line visible false olacağı için bunu yazdık.
				# line pointi yerel olduğundan global olarak nerede olacağının hesabını yapıyoruz
				first_line.points[1] = first_ray.get_collision_point() - first_line.global_position
				end_ray.global_position = first_ray.get_collision_point()
				end_ray.cast_to = first_ray.cast_to.bounce(first_ray.get_collision_normal())
				end_ray.add_exception(first_ray.get_collider())
				end_ray.force_raycast_update()
				
				end_line.points[0] = first_line.points[1]
				end_line.points[1] = end_ray.get_collision_point() - first_line.global_position
				print(end_ray.get_collision_point(), first_line.global_position, first_line.points[1])
			
			else:
				first_line.points[1] = first_ray.get_collision_point() - first_line.global_position
				end_line.visible = false
		
		else:
			first_line.hide()
	
	if event is InputEventScreenTouch and not event.pressed:
		timer.start()
		first_line.visible = false
		end_line.visible = false

func _on_Ball_Shooting() -> void:
	var ball = Ball.instance()
	add_child(ball)
	ball.position = $Spawn.position
	ball.start((get_global_mouse_position() - $Spawn.position).angle())
