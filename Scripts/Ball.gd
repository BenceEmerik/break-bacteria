extends KinematicBody2D


var speed:int = 2000
var velocity:Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready(): 
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start(dir:float) -> void:
	rotation = dir
	velocity = Vector2(speed, 0).rotated(rotation)

func _process(delta:float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		
		
		if collision.collider.has_method("is_bricket"):
			print()
			collision.collider.emit_signal("health_state")
			
