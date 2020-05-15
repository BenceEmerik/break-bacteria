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
	var row:Array = []
	for cell in column:
		row.append(null)
	
	var bricket = preload("res://Scenes/Bricket.tscn").instance()
	bricket.health = level
	bricket.position = Vector2(4*cell_length-offset, 2*cell_length-offset)
	add_child(bricket)
	var ballplus = preload("res://Scenes/Booster/BallPlus.tscn").instance()
	ballplus.position = Vector2(5*cell_length-offset, 2*cell_length-offset)
	add_child(ballplus)
	var twodirect = preload("res://Scenes/Booster/TwoDirections.tscn").instance()
	twodirect.position = Vector2(6*cell_length-offset, 2*cell_length-offset)
	add_child(twodirect)
	var coin = preload("res://Scenes/Booster/Coin.tscn").instance()
	coin.position = Vector2(1*cell_length-offset, 2*cell_length-offset)
	add_child(coin)
	var fourdirect = preload("res://Scenes/Booster/FourDirections.tscn").instance()
	fourdirect.position = Vector2(8*cell_length-offset, 2*cell_length-offset)
	add_child(fourdirect)
	var shield = preload("res://Scenes/Booster/Shield.tscn").instance()
	shield.position = Vector2(2*cell_length-offset, 2*cell_length-offset)
	add_child(shield)
	grid.insert(1, [coin, shield, null, bricket, ballplus, twodirect, null, fourdirect, null])

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

