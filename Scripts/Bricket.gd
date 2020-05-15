tool
extends KinematicBody2D
class_name Bricket

export(int) var health = 30
export(String, "Triangle", "Square") var bricket_type = "Square"
export(int, "0", "90", "180", "270") var degress = 0
export(Color, RGB) var bricket_color = Color.darkslategray
export(int, "Red", "Blue", "Orange", "Yellow", "YellorGreen", "Aqua") var color
var colors =  [
	Color.red, Color.blue, Color.orange, Color.yellow, Color.yellowgreen, Color.aqua, Color.green,
	Color.purple, Color.brown, Color.darkslategray, Color.coral, Color.fuchsia, Color.dodgerblue,
	Color.firebrick, Color.chocolate, Color.lawngreen, Color.olive, Color.limegreen, Color.snow,
	
]

onready var sprite:Sprite = $Sprite
onready var collision:CollisionPolygon2D = $Collision
onready var animation:AnimationPlayer = $AnimationPlayer
onready var timer:Timer = $Timer
onready var tween:Tween = $Tween
onready var label:Label = $Label
onready var particles:CPUParticles2D = preload("res://Scenes/Particles.tscn").instance()

signal health_state
signal death
signal danger

var square_shape:PoolVector2Array = PoolVector2Array([Vector2(-58, -58), Vector2(58, -58), Vector2(58, 58), Vector2(-58, 58)])
var triangle_shape:PoolVector2Array = PoolVector2Array([Vector2(-60, -60), Vector2(60, 60), Vector2(-60, 60)])


func _ready() -> void:
	randomize()
	connect("health_state", self, "_on_health_status")
	connect("death", self, "_on_death")
	connect("danger", self, "_on_danger")
	
	if bricket_type == "Square":
		sprite.texture = load("res://Sprites/square.png")
		collision.polygon = square_shape
		
	else:
		sprite.texture = load("res://Sprites/triangle.png")
		collision.polygon = triangle_shape
		$Sprite.rotation_degrees = degress * 90
		$Collision.rotation_degrees = degress * 90
	
#	sprite.modulate = bricket_color
	sprite.modulate = colors[color]
	label.text = str(health)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
#	print(health)
	if health <= 0:
		emit_signal("death")


func is_bricket() -> bool:
	return true

func _on_health_status() -> void:
	health -= 1
	label.text = str(health)
	tween.interpolate_property(label, "rect_scale", Vector2(1, 1), Vector2(1.5, 1.5), 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(label, "rect_scale", label.rect_scale, Vector2(1, 1), 0.1, Tween.TRANS_SINE, Tween.EASE_OUT, 0.1)
	tween.start()

func _on_danger() -> void:
	tween.interpolate_property(label, "rect_scale", label.rect_scale, Vector2(1.5, 1.5), .5,
				Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(label, "rect_scale", label.rect_scale, Vector2(1.0, 1.0), .5,
				Tween.TRANS_ELASTIC, Tween.EASE_IN, .5)
	tween.start()
	yield(tween, "tween_all_completed")
	self._on_danger()


func _on_death() -> void:
	get_tree().current_scene.add_child(particles)
	particles.position = position
	particles.color = bricket_color
	particles.emitting = true
	
	queue_free()

