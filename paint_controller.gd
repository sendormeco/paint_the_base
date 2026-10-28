extends Node

@onready var viewport: SubViewport = $SubViewport
@onready var paint_canvas: Node2D = $SubViewport/PaintCanvas

@export var brush_texture: Texture2D
@export var brush_size: float = 64.0

func _ready():
	paint_canvas.brush_texture = brush_texture
	paint_canvas.brush_size = brush_size

func paint(global_position: Vector2):
	var local_pos = paint_canvas.to_local(global_position)
	paint_canvas.draw_brush(local_pos)

func get_mask_texture() -> Texture2D:
	return viewport.get_texture()
