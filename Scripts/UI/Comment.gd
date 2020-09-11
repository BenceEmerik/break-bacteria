extends Control


var review_plugin


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.has_singleton("GodotPlayStoreReview"):
		review_plugin = Engine.get_singleton("GodotPlayStoreReview")
		
	else:
		print_debug("PlayStoreReview plugin not available")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func start_review() -> void:
	if not review_plugin:
		return
	
	review_plugin.start_review()


func _on_ExitButton_pressed() -> void:
	queue_free()


func _on_HomeButton_pressed() -> void:
	start_review()
	LocalSettings.set_setting("comment_ok", true)
	queue_free()
