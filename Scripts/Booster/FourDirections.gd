extends Area2D
class_name FourDirections


var is_coll:bool
var colplus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colplus = $Plus/CollisionPolygon2D.polygon
	$Plus/CollisionPolygon2D.polygon = PoolVector2Array([])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_FourDirections_body_entered(body: Node) -> void:
	if body is Ball:
		is_coll = true
		$Plus/CollisionPolygon2D.polygon = colplus
		$Plus/H.visible = true
		$Plus/V.visible = true


func _on_FourDirections_body_exited(body: Node) -> void:
	if body is Ball:
		$Plus/CollisionPolygon2D.polygon = PoolVector2Array([])
		$Plus/H.visible = false
		$Plus/V.visible = false


func _on_Plus_body_entered(body: Node) -> void:
	if body is Bricket:
		body.emit_signal("health_state")
