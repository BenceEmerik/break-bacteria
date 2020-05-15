extends Area2D
class_name TwoDirections

enum directions {H, V}
export(directions) var direct

var is_coll
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_TwoDirections_body_entered(body: Node) -> void:
	if body is Ball:
		is_coll = true
		match direct:
			directions.H:
				pass
			
			directions.V:
				pass # yöne göre her temas da o yöndeki briketlerin canını 1 düşürecek
