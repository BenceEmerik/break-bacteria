extends Area2D
class_name Triple

var is_coll:bool
var x:int
var degress:Array = [-135, -90, -45]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Triple_body_entered(body: Node) -> void:
	if body is Ball:
		is_coll = true
	if body is Ball and !body.is_tripled:
		is_coll = true
		body.is_tripled = true
		if x == 0: x = 1
		elif x == 1: x = 2
		else: x = 0
		body.start(deg2rad(degress[x]))
