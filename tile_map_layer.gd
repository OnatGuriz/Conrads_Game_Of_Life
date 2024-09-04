extends TileMapLayer
# The variables of the tilemaps on the atlas
const alive_cell = Vector2i(1,1)
const dead_cell = Vector2i(4,1)
var cells_to_be_killed = []
var cells_to_be_spawned = []
var candidate_cells = []

# Atlas coordinates of every alive cell on the grid
var alive_cell_ids = []
var time_elapsed:float = 0;
var game_ready = false
var alive_neighbours
const neighbour_index = [Vector2i(-1,-1), Vector2i(0,-1), Vector2i(-1,0), Vector2i(1,-1),
						Vector2i(-1,1), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1) ]

#checks how many alive cells are near a position
func get_alive_neighbor_count(pos) -> int:
	var alive_count: int = 0
	for vec in neighbour_index:
		if((pos + vec) in alive_cell_ids):
			alive_count += 1
	return alive_count

#gets the dead cells that can possibly become alive with reproduction
func get_candidate_dead_cells():
	for pos in alive_cell_ids:
		for vec in neighbour_index:
			if ((pos + vec) not in  alive_cell_ids):
				if (not (candidate_cells.has(pos +vec))) :
					candidate_cells.append(pos+vec)
	return candidate_cells

func kill_cell(pos):
	set_cell(pos,1,dead_cell)
	alive_cell_ids.erase(pos)
	
func spawn_cell(pos):
	set_cell(pos, 1 , alive_cell)
	alive_cell_ids.append(pos)


func run_game():
	candidate_cells = get_candidate_dead_cells()
	for pos in alive_cell_ids:
		alive_neighbours = get_alive_neighbor_count(pos)
		#death by underpopulation
		if(alive_neighbours < 2):
			cells_to_be_killed.append(pos)
		#death by overpopulation
		elif(alive_neighbours > 3):
			cells_to_be_killed.append(pos)
	for candidate in candidate_cells:
		if(get_alive_neighbor_count(candidate) == 3):
			cells_to_be_spawned.append(candidate)
	for cell in cells_to_be_killed:
		kill_cell(cell)
	for cell in cells_to_be_spawned:
		spawn_cell(cell)
	cells_to_be_killed.clear()
	cells_to_be_spawned.clear()
	candidate_cells.clear()

# Method to update cell type it will flip the cell type
func cell_pressed(pos):
	var grid_pos = local_to_map(pos)
	var cell_type = get_cell_atlas_coords(grid_pos)
	if (cell_type == dead_cell):
		spawn_cell(grid_pos)
	else:
		kill_cell(grid_pos)

func _on_node_2d_game_ready():
	game_ready = true
	
# runs one step of the game every 0.1 seconds
func _process(delta: float) -> void:
	if  game_ready:
		if(time_elapsed < 0.25):
			time_elapsed += delta
		if time_elapsed > 0.25:
			run_game()
			time_elapsed = 0
