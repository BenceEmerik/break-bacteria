extends Area2D
class_name TwoDirections

enum directions {H, V}
export(directions) var direct

var is_coll
var colextents
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colextents = $Line/CollisionShape2D.shape.extents
	$Line/CollisionShape2D.shape.extents = Vector2.ZERO
	match direct:
		directions.H:
			pass
		
		directions.V:
			$Line.rotation_degrees = 90
			$Sprite.rotation_degrees = 90


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_TwoDirections_body_entered(body: Node) -> void:
	if body is Ball:
		is_coll = true
		$Line/CollisionShape2D.shape.extents = colextents
		$Line/line.visible = true



func _on_Line_body_entered(body: Node) -> void:
	print(body)
	if body is Bricket:
		body.emit_signal("health_state")


func _on_TwoDirections_body_exited(body: Node) -> void:
	if body is Ball:
		$Line/CollisionShape2D.shape.extents = Vector2.ZERO
		$Line/line.visible = false
