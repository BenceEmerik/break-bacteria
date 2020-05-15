extends Area2D
class_name Shield



var is_coll:bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Shield_body_entered(body: Node) -> void:
	if body is Ball and not body.is_shield_used:
		body.is_shielded = true
		body.is_shield_used = true
		is_coll = true
