tool
extends Node2D


#signal two_direct

export(int) var column:int = 9
export(int) var row:int = 11
export(int) var turn:int = 0
export(int) var cell_length:int = 120
export(int) var offset:int = 60

var grid = []

func _ready() -> void:
#	print(grid_to_world(5, 5))
#	print(world_to_grid(Vector2(250, 360)))
	var size:Vector2 = Vector2(cell_length*column, cell_length*row)
	
	for r in range(row):
		var col = []
		for c in range(column):
			col.append(null)
		grid.append(col)
	
	print(grid)
	pass



func _process(_delta: float) -> void:
	if Input.is_action_just_released("left_click"):
		pass
		#turn complete -> deleted_item_clear()
#	print(world_to_grid(get_local_mouse_position()))
#	if Engine.editor_hint:
#		update()

func _input(event:InputEvent):
	pass
	
	

func add_bricket() -> void:
	pass


func add_row(level:int) -> void:
	# null, ball+, bricket[tri][rot] level < 5 square > random %20
	var brickets:int = 1
	var booster_count:int
	var coin:bool
	var double:bool
	
	
	if level > 3:
		brickets = 2
	
	if level > 7:
		coin = true
		booster_count = 1
	
	if level > 15:
		brickets = 3
		booster_count = 2
	
	if level > 29:
		brickets = 4
		booster_count = 3
	
	if level > 50:
		double = true
		booster_count = 4
	
	if level > 75:
		brickets = 5
		booster_count = 5
	
	if level > 90:
		pass
	
	
	var row_list:Array = []
	for index in range(brickets):
		var bricket = preload("res://Scenes/Bricket.tscn").instance()
		bricket.health = level
		if !index and double and randi()%100 < 33:
			bricket.health = level * 2
		row_list.append(bricket)
	
	var ballplus = preload("res://Scenes/Booster/BallPlus.tscn").instance()
	row_list.append(ballplus)
	
	if coin and randi()%100 < 33: #%25 ihtimal ile diye düşünüyorum.
		var coins = preload("res://Scenes/Booster/Coin.tscn").instance()
		add_child(coins)
		row_list.append(coins)
	
	var booster_list = []
	match booster_count:
		1: 
			var mirror = preload("res://Scenes/Booster/Mirror.tscn").instance()
			booster_list.append(mirror)
		2: 
			var two_directions = preload("res://Scenes/Booster/TwoDirections.tscn").instance()
			booster_list.append(two_directions)
		3: 
			var four_directions = preload("res://Scenes/Booster/FourDirections.tscn").instance()
			booster_list.append(four_directions)
		4: 
			var triple = preload("res://Scenes/Booster/Triple.tscn").instance()
			booster_list.append(triple)
		5: 
			var shield = preload("res://Scenes/Booster/Coin.tscn").instance()
			booster_list.append(shield)
	
	if booster_count and randi()%100 < 33:
		booster_list.shuffle()
		var booster = booster_list.pop_front()
		add_child(booster)
		row_list.append(booster)
	
	var random_index = range(column)
	random_index.shuffle()
	var insert_row:Array = []
	insert_row.resize(9)
	
	for index in random_index:
		
		if !row_list.empty():
			var item = row_list.pop_front()
			add_child(item)
			item.position = Vector2((index+1)*cell_length-offset, 2*cell_length-offset)
			insert_row[index] = item

	grid.insert(1, insert_row)

func row_down() -> void:
	for bricket in self.get_children():
		bricket.position.y += cell_length
	#pirketler hücre boyu kadar aşağı kayar
	
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
		print(grid_index, grid[grid_index])
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
	var last_row = grid.pop_back()
	for i in last_row:
		if i is KinematicBody2D:
			print("oyun biter!")
			get_tree().current_scene.emit_signal("challenge_failed")
		
		if i is Area2D:
			i.queue_free()


func draw_update(lvl:int):
	deleted_item_clear()
	if is_grid_empty():
		get_parent().emit_signal("screen_clear")
	erase_row()
	row_down()
	add_row(lvl)
	bricket_control()
	

func grid_to_world(column:int, row:int) -> Vector2:
	# dönen pozisyon hücrenin merkez noktasını verir.
	return Vector2(column * cell_length + offset, row * cell_length + offset)

func world_to_grid(position:Vector2) -> Vector2:
	return Vector2(int(position.x / cell_length + 1), int(position.y / cell_length + 1))




func _notification(what: int) -> void:
#	print("notify: %d"%what)
	match what:
		NOTIFICATION_PROCESS:
			update()

func _draw() -> void:
	if "Engine.editor_hint":
		draw_rect(Rect2(Vector2.ZERO, Vector2(column*cell_length, row*cell_length)),
					  Color.purple, false, 1.0, true)
			
		for r in range(1, row):
			draw_line(Vector2(0, r*cell_length),
					  Vector2(column*cell_length, r*cell_length), Color.purple, 1.0, true)
			
		for c in range(1, column):
			draw_line(Vector2(c*cell_length, 0),
					  Vector2(c*cell_length, row*cell_length), Color.purple, 1.0, true)
					
		update()

