extends Area2D
class_name FourDirections


var is_coll:bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_FourDirections_body_entered(body: Node) -> void:
	if body is Ball:
		is_coll = true
		print("four") #dört yöne atış
