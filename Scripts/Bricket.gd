tool
extends KinematicBody2D
class_name Bricket

export(int) var health = 30
export(String, "Triangle", "Square") var bricket_type = "Square"
export(Color) var bricket_color = Color(1, 1, 1)

onready var sprite:Sprite = $Sprite
onready var collision:CollisionPolygon2D = $Collision
onready var animation:AnimationPlayer = $AnimationPlayer
onready var timer:Timer = $Timer
onready var tween:Tween = $Tween
onready var label:Label = $Label
onready var particles:CPUParticles2D = preload("res://Scenes/Particles.tscn").instance()

signal health_state
signal death

var square_shape:PoolVector2Array = PoolVector2Array([Vector2(-60, -60), Vector2(60, -60), Vector2(60, 60), Vector2(-60, 60)])
var triangle_shape:PoolVector2Array = PoolVector2Array([Vector2(-60, -60), Vector2(60, 60), Vector2(-60, 60)])


func _ready() -> void:
	randomize()
	connect("health_state", self, "_on_Health_Status")
	connect("death", self, "_on_Death")
	
	if bricket_type == "Square":
		sprite.texture = load("res://Sprites/square.png")
		collision.polygon = square_shape
		
	else:
		sprite.texture = load("res://Sprites/triangle.png")
		collision.polygon = triangle_shape
	
	sprite.modulate = bricket_color
	label.text = str(health)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
#	print(health)
	if health <= 0:
		emit_signal("death")


func is_bricket() -> bool:
	return true

func _on_Health_Status() -> void:
	health -= 1
	label.text = str(health)
	tween.interpolate_property(label, "rect_scale", Vector2(1, 1), Vector2(1.5, 1.5), 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(label, "rect_scale", label.rect_scale, Vector2(1, 1), 0.1, Tween.TRANS_SINE, Tween.EASE_OUT, 0.1)
	tween.start()

func _on_Death() -> void:
	get_node("/root/Game").add_child(particles)
	particles.position = position
	particles.color = bricket_color
	particles.emitting = true
#	yield(particles, "completed")
	queue_free()
