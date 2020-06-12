tool
extends Node2D
class_name BricketGridChallenge


signal all_halved()
signal break_bottom()
signal extra_ball()
signal gold_aiming()

export(int) var column:int = 9
export(int) var row:int = 11
export(int) var cell_length:int = 120
export(int) var offset:int = 60

onready var bricket_area:Node2D = Node2D.new()

var grid:Array = []

func _ready() -> void:
	add_child(bricket_area)
	var size:Vector2 = Vector2(cell_length*column, cell_length*row)
	
	#boş 9x11 lik array oluşturuyoruz
	for r in range(row):
		var col:Array = []
		col.resize(column)
		grid.append(col)


func _process(_delta: float) -> void:
	pass


func add_bricket() -> void:
	pass


func add_row(level:int) -> void:
	# null, ball+, bricket[tri][rot] level < 5 square > random %20
	var brickets:int = 1
	var booster_count:int
	var double_booster:bool
	var coin:bool
	var double:bool
	
	
	if level > 4:
		brickets = 2
	
	if level > 9:
		coin = true
		booster_count = 1
	
	if level > 19:
		brickets = 3
		booster_count = 2
	
	if level > 29:
		booster_count = 3
	
	if level > 49:
		brickets = 4
		booster_count = 4
	
	if level > 75:
		booster_count = 5
	
	if level > 99:
		brickets = 5
	
	if level > 124:
		double = true
		double_booster = true
	
	var row_list:Array = []
	var color:Array = Globals.colors
	color.shuffle()
	for index in range(brickets):
		var bricket = preload("res://Scenes/Bricket.tscn").instance()
		bricket.color = color.front()
		bricket.health = level
		if randi()%100 < 10:
			bricket.bricket_type = "Triangle"
			bricket.degress = randi()%4
			
		if !index and double and randi()%100 < 33:
			bricket.color = color.back()
			bricket.health = level * 2
			
		row_list.append(bricket)
	
	var ballplus = preload("res://Scenes/Booster/BallPlus.tscn").instance()
	row_list.append(ballplus)
	
	if coin and randi()%100 < 30: #%25 ihtimal ile diye düşünüyorum.
		var coins = preload("res://Scenes/Booster/Coin.tscn").instance()
		row_list.append(coins)
	
	var booster_list = []
	if booster_count > 4:
		var shield = preload("res://Scenes/Booster/Shield.tscn").instance()
		booster_list.append(shield)
	if booster_count > 3:
		var triple = preload("res://Scenes/Booster/Triple.tscn").instance()
		booster_list.append(triple)
	if booster_count > 2:
		var four_directions = preload("res://Scenes/Booster/FourDirections.tscn").instance()
		booster_list.append(four_directions)
	if booster_count > 1:
		var two_directions = preload("res://Scenes/Booster/TwoDirections.tscn").instance()
		booster_list.append(two_directions)
	if booster_count > 0:
		var mirror = preload("res://Scenes/Booster/Mirror.tscn").instance()
		booster_list.append(mirror)
	
	if booster_count and randi()%100 < 30:
		booster_list.shuffle()
		var booster = booster_list.pop_front()
		row_list.append(booster)
		if double_booster and randi()%100 > 40:
			var boosterd = booster_list.pop_front()
			row_list.append(boosterd)
	
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
			get_tree().current_scene.emit_signal("challenge_failed")
			return
		if i is Area2D:
			i.queue_free()
	grid.pop_back()

func draw_update(lvl:int) -> void:
	deleted_item_clear()
	if is_grid_empty():
		get_parent().emit_signal("screen_clear")
	erase_row()
	row_down()
	add_row(lvl)
	bricket_control()

func end_row_clear() -> void:
	end_row_bricks_kills()
	grid.pop_back()
	bricket_control()

func end_row_bricks_kills() -> void:
	deleted_item_clear()
	if is_grid_empty():
		get_parent().emit_signal("screen_clear")
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
#	print("notify: %d"%what)
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

