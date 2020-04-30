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

signal health_state
signal death

var square_shape:PoolVector2Array = PoolVector2Array([Vector2(-60, -60), Vector2(60, -60), Vector2(60, 60), Vector2(-60, 60)])
var triangle_shape:PoolVector2Array = PoolVector2Array([Vector2(-60, -60), Vector2(60, 60), Vector2(-60, 60)])


func _ready() -> void:
	randomize()
	connect("health_state", self, "_on_Health_Status")
	connect("death", self, "queue_free")
	
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
