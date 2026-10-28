extends CharacterBody2D

@export var speed: float = 200.0
var target_position: Vector2
var is_moving: bool = false

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			target_position = get_global_mouse_position()
			is_moving = true

func _physics_process(delta):
	if !is_moving:
		return
	
	var direction = global_position.direction_to(target_position)
	var distance = global_position.distance_to(target_position)

	if distance < 10.0:
		is_moving = false
		velocity = Vector2.ZERO
		return
	
	velocity = direction * speed
	move_and_slide()

	# Закрашиваем под юнитом
	$"../PaintController".paint(global_position)
