extends TextureButton


export(bool) var selected

onready var tween:Tween = $Tween
onready var animation:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if selected:
		animation.play("bounce")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
