extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var shader_mat: ShaderMaterial = self.material
	shader_mat.set_shader_parameter("base_texture", $"../Map".texture)
	shader_mat.set_shader_parameter("mask_texture", $"../PaintController".get_mask_texture())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
