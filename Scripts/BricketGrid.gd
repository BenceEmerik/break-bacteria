tool
extends Node2D
class_name BricketGrid

const column:int = 9
const row:int = 11
const cell_length:int = 120
const offset:int = 60
export(int) var turn:int
export(int) var bricket_health:int = 30
export(int) var default_balls:int = 30
export(int) var targeted_score:int

export(int) var ball_plus_booster:int #?
export(bool) var two_directions_booster:bool
export(bool) var four_directions_booster:bool
export(bool) var mirror_booster:bool
export(bool) var shild_booster:bool
export(bool) var triple_booster:bool


signal all_halved()
signal break_bottom()
signal extra_ball()
signal gold_aiming()


onready var bricket_area:Node2D = $Brickets


var grid:Array = []

func _ready() -> void:
	for r in range(row):
		var col:Array = []
		col.resize(column)
		grid.append(col)
		
	if bricket_area.get_child_count():
		for bricket in bricket_area.get_children():
			var cell = world_to_grid(bricket.position)
			print(cell)
			grid[cell.y-1][cell.x-1] = bricket as Bricket


func _process(delta: float) -> void:
	pass

func _input(event:InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		
		if has_node("Tutorial"):
			$Tutorial.queue_free()
	

func add_row() -> void:
	var brickets:int = 1
	var booster_count:int
	var double:bool
	
	
	var row_list:Array = []
	var color:Array = Globals.colors
	color.shuffle()
	for index in range(brickets):
		var bricket = preload("res://Scenes/Bricket.tscn").instance()
		bricket.color = color.front()
		bricket.health = 12#level
		if !index and double and randi()%100 < 33:
			if randi()%100 < 35:
				bricket.bricket_type = "Triangle"
				bricket.degress = randi()%4
			bricket.color = color.back()
			bricket.health = 12 * 2
		row_list.append(bricket)
	
#	var ballplus = preload("res://Scenes/Booster/BallPlus.tscn").instance()
#	row_list.append(ballplus)
	
	
	var booster_list = []
	if mirror_booster:
		var mirror = preload("res://Scenes/Booster/Mirror.tscn").instance()
		booster_list.append(mirror)
	
	if two_directions_booster: 
		var two_directions = preload("res://Scenes/Booster/TwoDirections.tscn").instance()
		booster_list.append(two_directions)
	
	if four_directions_booster:
		var four_directions = preload("res://Scenes/Booster/FourDirections.tscn").instance()
		booster_list.append(four_directions)
	
	if triple_booster:
		var triple = preload("res://Scenes/Booster/Triple.tscn").instance()
		booster_list.append(triple)
	
	if shild_booster:
		var shield = preload("res://Scenes/Booster/Shield.tscn").instance()
		booster_list.append(shield)
	
	if booster_count and randi()%100 < 33:
		booster_list.shuffle()
		var booster = booster_list.pop_front()
#		add_child(booster)
		row_list.append(booster)
	
	var random_index = range(column)
	random_index.shuffle()
	var insert_row:Array = []
	insert_row.resize(9)
	
	var tw:Tween = Tween.new()
	add_child(tw)
	for index in random_index:
		if !row_list.empty():
			var item = row_list.pop_front()
			item.scale = Vector2.ZERO 
			bricket_area.add_child(item)
			item.position = Vector2((index+1)*cell_length-offset, 2*cell_length-offset)
			tw.interpolate_property(item, "scale", Vector2(0, 0), Vector2(1, 1), 0.5,
						Tween.TRANS_CUBIC, Tween.EASE_IN)    
			insert_row[index] = item

	tw.start()
	grid.insert(1, insert_row)
	yield(tw, "tween_all_completed")
	tw.queue_free()
	
	#######

func row_down() -> void:
	var tw := Tween.new()
	add_child(tw)
	for bricket in bricket_area.get_children():
		tw.interpolate_property(bricket, "position:y", bricket.position.y, bricket.position.y+cell_length,
		0.2, Tween.TRANS_CIRC, Tween.EASE_IN)
	tw.start()
	yield(tw, "tween_all_completed")
	tw.queue_free()
	
func deleted_item_clear() -> void:
	for i in range(grid.size()):
		for j in range(grid[i].size()):
			if !is_instance_valid(grid[i][j]):
				grid[i][j] = null
				
			if grid[i][j] is Area2D and grid[i][j].get("is_coll") and grid[i][j].is_coll:
				grid[i][j].queue_free()
				grid[i][j] = null

func bricket_control() -> void:
	for grid_index in range(-3, 0):
		for i in grid[grid_index]:
			if i is Bricket:
				i.emit_signal("danger")

func is_grid_empty() -> bool:
	for i in grid:
		for j in i:
			if j is Bricket:
				return false
	return true

func erase_row() -> void:
	var last_row = grid[-1]
	for i in last_row:
		if i is Bricket:
			get_tree().current_scene.emit_signal("level_failed")
			#tree paused
			print("failed")
			return
		if i is Area2D:
			i.queue_free()
	grid.pop_back() #veya end_row_bricks_kills()

func draw_update() -> void:
	deleted_item_clear()
	if is_grid_empty() and not turn:
		get_tree().current_scene.emit_signal("level_completed")
		print("level complete")
	erase_row()
	row_down()
	if turn:
		add_row()
		turn -= 1
	bricket_control()

func end_row_clear() -> void:
	end_row_bricks_kills()
	grid.pop_back()
	bricket_control()

func end_row_bricks_kills() -> void:
	deleted_item_clear()
	if is_grid_empty():
		get_tree().current_scene.emit_signal("screen_clear")
	bricket_control()
	for r in range(-1, -row, -1):
		var ok := false
		for i in grid[r]:
			if i is Bricket:
				i.emit_signal("death")
				ok = true
		if ok: break

func all_bricks_halved() -> void:
	for row in grid:
		for col in row:
			if col is Bricket:
				col.emit_signal("halved")

func grid_to_world(column:int, row:int) -> Vector2:
	return Vector2(column * cell_length + offset, row * cell_length + offset)

func world_to_grid(position:Vector2) -> Vector2:
	return Vector2(int(position.x / cell_length + 1), int(position.y / cell_length + 1))

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PROCESS:
			update()

func _draw() -> void:
	if Engine.editor_hint:
		draw_rect(Rect2(Vector2.ZERO, Vector2(column*cell_length, row*cell_length)),
					  Color.purple, false, 1.0, true)
			
		for r in range(1, row):
			draw_line(Vector2(0, r*cell_length),
					  Vector2(column*cell_length, r*cell_length), Color.purple, 1.0, true)
			
		for c in range(1, column):
			draw_line(Vector2(c*cell_length, 0),
					  Vector2(c*cell_length, row*cell_length), Color.purple, 1.0, true)
					
		update()

