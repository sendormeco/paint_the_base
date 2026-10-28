extends Node2D

var brush_texture: Texture2D
var brush_size: float = 64.0
var paint_positions: Array[Vector2] = []

func draw_brush(pos: Vector2):
	paint_positions.append(pos)
	queue_redraw()

func _draw():
	for pos in paint_positions:
		var offset = Vector2(brush_size / 2, brush_size / 2)
		draw_texture(brush_texture, pos - offset)
