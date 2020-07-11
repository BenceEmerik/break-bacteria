extends Control


onready var progress:TextureProgress = $Window/Progress
onready var countdown:Label = $Window/Progress/Label

var count = 6

signal ok
var level_failed = preload("res://Scenes/UI/LevelFailedPopup.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !get_tree().current_scene.get_node("Admob").is_rewarded_video_loaded():
		show_popup()
		queue_free()
	countdown.text = str(count)
	$Tween.interpolate_property(progress, "value", progress.min_value, progress.max_value, 6,
					Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Timer.connect("timeout", self, "_countdown")
	
	$Tween.start()
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _countdown() -> void:
	count -= 1
	countdown.text = str(count)
	if not count:
		show_popup()
		queue_free()

func show_popup() -> void:
	get_parent().add_child(level_failed)
	get_tree().paused = true
	yield(level_failed, "ok")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	get_tree().paused = false

func _on_WatchButton_pressed() -> void:
	get_tree().current_scene.get_node("Admob").show_rewarded_video()
	var parent = get_tree().current_scene
	parent.emit_signal("admob_type", "continue")
	emit_signal("ok")
	queue_free()


