extends KinematicBody2D
class_name TestBall

var speed:int = 50000
var velocity:Vector2 = Vector2.ZERO

var collision_points:Array

func _ready(): 
	pass

func start(dir:float) -> void:
#	set_process(true)
	rotation = dir
	velocity = Vector2(speed, 0).rotated(rotation)

func _process(delta:float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		collision_points.append(global_position)
		var reflect = collision.remainder.bounce(collision.normal)
		velocity = velocity.bounce(collision.normal)
		move_and_collide(reflect)
		if len(collision_points) == 3:
			get_tree().current_scene.emit_signal("collision_lines", collision_points)
			collision_points.clear()
			position = Vector2.ZERO
			rotation = 0
			queue_free()
#			set_process(false)
		


