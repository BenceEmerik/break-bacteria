extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().connect("screen_resized", self, "_hebele")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _hebele() -> void:
	var yy = get_viewport_rect().size.y
	print(yy - 1920)
	$Wall/Ground.position.y = yy - 1920
	$Level.position.y = 180 + yy - 1920
	$Spawn.position.y = 1535 + yy - 1920
	$NewSpawn.position.y = 1535 + yy - 1920
