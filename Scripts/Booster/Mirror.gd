extends Area2D
class_name Mirror

var is_coll:bool
var x = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Mirror_body_entered(body: Node) -> void:
	if body is Ball and !body.is_mirrored:
		is_coll = true
		body.is_mirrored = true
		body.start(deg2rad(-45 + x * -90 ))
		if x == 0: x = 1
		else: x = 0
