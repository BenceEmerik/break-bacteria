extends KinematicBody2D
class_name Ball

var speed:int = 2500
var velocity:Vector2 = Vector2.ZERO

onready var tween:Tween = $Tween

export(Texture) var texture

var is_shielded:bool
var is_shield_used:bool
var is_mirrored:bool

# Called when the node enters the scene tree for the first time.
func _ready(): 
	$Sprite.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start(dir:float) -> void:
	rotation = dir
	velocity = Vector2(speed, 0).rotated(rotation)

func _process(delta:float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		var reflect = collision.remainder.bounce(collision.normal)
		velocity = velocity.bounce(collision.normal)
		move_and_collide(reflect)
		if collision.collider is Bricket:
			collision.collider.emit_signal("health_state")
		
		if collision.collider.get_name() == "Ground" and not is_shielded:
			var pos = global_position
			set_process(false)
			get_tree().current_scene.emit_signal("ground_collision", pos)
			tween.interpolate_property(self, "position", position, get_tree().current_scene.new_spawn.position,
									0.4, Tween.TRANS_SINE, Tween.EASE_IN)
			tween.interpolate_property(self, "rotation_degrees", rotation_degrees, 0, 0.4, Tween.TRANS_SINE,
									Tween.EASE_IN)
			tween.start()
			yield(tween, "tween_all_completed")
			queue_free()
		
		elif collision.collider.get_name() == "Ground":
			is_shielded = false

func go_home() -> void:
	collision_layer = 4
	self.start(deg2rad(90))
