tool
extends Node2D
class_name BricketGrid


export(int) var column:int = 9
export(int) var row:int = 12
export(int) var extra_row:int = 0
export(int) var cell_length:int = 120
export(int) var bricket_health:int = 30
export(int) var ball_plus:int = 0
export(bool) var h_bonus:bool = false
export(bool) var hv_bonus:bool = false
export(bool) var random_bonus:bool = false
#export(Array, Array, PackedScene) var hebele:Array = []
export(String, FILE) var level

signal cell_clicked(column, row)


var grid:Array = Array()

func _init() -> void:
	
	for c in range(row):
		grid.append([])
		for r in range(column):
			grid[c].append(null)


func _ready() -> void:
#	print(grid_to_world(5, 5))
#	print(world_to_grid(Vector2(250, 360)))
	connect("cell_clicked", self, "_on_Add_Bricket")
	pass



func _process(_delta: float) -> void:
	pass
#	if Engine.editor_hint:
#		update()

func _input(event:InputEvent):
	if Engine.editor_hint:
		if event is InputEventMouseButton and event.pressed:
			var cell = world_to_grid(event.position)
			emit_signal("cell_clicked", cell.x, cell.y)

func add_bricket(bricket:Node2D) -> void:
	pass

func _on_Add_Bricket(column, row) -> void:
	print(column, row)

func _add_row() -> void:
	_erase_row()
	grid.insert(0, [null, "123", null, null, null, null, "dsa", "ertew", null])
	# ilk sıraya yeni pirketler eklenir.
	

func row_down() -> void:
	_add_row()
	for bricket in self.get_children():
		bricket.position.y += cell_length
	#pirketler hücre boyu kadar aşağı kayar

func _erase_row() -> void:
	grid.remove(grid.size()-1)


func grid_to_world(column:int, row:int) -> Vector2:
	# dönen pozisyon hücrenin merkez noktasını verir.
	return Vector2(column*cell_length+cell_length/2, row*cell_length+cell_length/2)

func world_to_grid(position:Vector2) -> Vector2:
	return Vector2(int(position.x/cell_length+1), int(position.y/cell_length+1))




func _notification(what: int) -> void:
#	print("notify: %d"%what)
	match what:
		NOTIFICATION_PROCESS:
			if Engine.editor_hint:
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

func _enter_tree() -> void:
	print("enter tree")
#	if Engine.editor_hint:
#		draw_rect(Rect2(position, Vector2(column*cell_length, row*cell_length)),
#				  Color.purple, true, 1.0, true)


func _exit_tree() -> void:
	print("exit tree")
