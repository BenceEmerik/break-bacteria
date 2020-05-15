extends KinematicBody2D
class_name Ball

var speed:int = 3000
var velocity:Vector2 = Vector2.ZERO

onready var tween:Tween = $Tween


var is_shielded:bool
var is_shield_used:bool

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
			collision.collider.emit_signal("health_state")
			
		if collision.collider.get_name() == "Ground" and not is_shielded:
			get_node("/root/ChallengeGame").emit_signal("ground_collision", global_position)
			set_process(false)
			tween.interpolate_property(self, "position", position, get_node("/root/ChallengeGame").new_spawn.position, 0.3,
									   Tween.TRANS_SINE, Tween.EASE_IN)
			tween.start()
			yield(tween, "tween_all_completed")
			queue_free()
		
		elif collision.collider.get_name() == "Ground":
			is_shielded = false
