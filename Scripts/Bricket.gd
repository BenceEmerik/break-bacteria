tool
extends StaticBody2D
class_name Bricket

export(int) var health = 30
export(String, "Triangle", "Square") var bricket_type = "Square"
export(int, "0", "90", "180", "270") var degress = 0
export(Color, RGB) var color = Color.darkslategray


onready var sprite:Sprite = $Sprite
onready var collision:CollisionPolygon2D = $Collision
onready var animation:AnimationPlayer = $AnimationPlayer
onready var timer:Timer = $Timer
onready var tween:Tween = $Tween
onready var label:Label = $Label

signal health_state()
signal death()
signal danger()
signal halved()

var square_shape:PoolVector2Array = PoolVector2Array([Vector2(-58, -58), Vector2(58, -58), Vector2(58, 58), Vector2(-58, 58)])
var triangle_shape:PoolVector2Array = PoolVector2Array([Vector2(-58, -58), Vector2(58, 58), Vector2(-58, 58)])


func _ready() -> void:
	randomize()
	connect("health_state", self, "_on_health_status")
	connect("death", self, "_on_death")
	connect("danger", self, "_on_danger")
	connect("halved", self, "_on_halved")

	if bricket_type == "Square":
		sprite.texture = load("res://Sprites/square.png")
		collision.polygon = square_shape
		
	else:
		sprite.texture = load("res://Sprites/triangle.png")
		collision.polygon = triangle_shape
		$Sprite.rotation_degrees = degress * 90
		$Collision.rotation_degrees = degress * 90
	
#	sprite.modulate = bricket_color
	sprite.modulate = color
	label.text = str(health)


func _process(delta:float):
#	print(health)
	if health <= 0:
		emit_signal("death")


func _on_health_status() -> void:
	health -= 1
	label.text = str(health)
	tween.interpolate_property(label, "rect_scale", Vector2(1, 1), Vector2(1.5, 1.5), 0.1,
				Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(label, "rect_scale", label.rect_scale, Vector2(1, 1), 0.1,
				Tween.TRANS_SINE, Tween.EASE_OUT, 0.1)
	tween.start()

func _on_danger() -> void:
	tween.interpolate_property(label, "rect_scale", label.rect_scale, Vector2(1.5, 1.5), .5,
				Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(label, "rect_scale", label.rect_scale, Vector2(1.0, 1.0), .5,
				Tween.TRANS_ELASTIC, Tween.EASE_IN, .5)
	tween.start()
	yield(tween, "tween_all_completed")
	self._on_danger()

func _on_halved() -> void:
	var particles:CPUParticles2D = preload("res://Scenes/Particles.tscn").instance()
	health /= 2
	label.text = str(health)
	tween.interpolate_property(label, "rect_scale", Vector2(1, 1), Vector2(1.5, 1.5), 0.1,
				Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(label, "rect_scale", label.rect_scale, Vector2(1, 1), 0.1,
				Tween.TRANS_SINE, Tween.EASE_OUT, 0.1)
	tween.start()
	get_tree().current_scene.add_child(particles)
	particles.position = global_position
	particles.color = color
	particles.emitting = true

func _on_death() -> void:
	var particles:CPUParticles2D = preload("res://Scenes/Particles.tscn").instance()
	get_tree().current_scene.add_child(particles)
	particles.position = global_position
	particles.color = color
	particles.emitting = true
	if get_tree().current_scene.get_name() == "Game":
		get_tree().current_scene.emit_signal("score_updated", 10)
	queue_free()
