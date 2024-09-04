extends Node2D
signal game_ready()

#this will be true when the player locks in their choice
var user_disabled = false

#listens for mouse click then calls the method to set those cells as alive
func _input(event):
	if not user_disabled:
		if event is InputEventMouseButton and event.pressed:
			get_node("TileMapLayer").cell_pressed(event.position)
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_SPACE:
				user_disabled = true
				game_ready.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
