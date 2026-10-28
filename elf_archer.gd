extends CharacterBody2D

# Настройки
@export var speed: float = 200.0
@export var rotation_speed: float = 8.0
@export var stopping_distance: float = 10.0

# Состояние
var target_position: Vector2
var is_selected: bool = false
var is_moving: bool = false

@onready var sprite: Sprite2D = $Sprite2D
func _ready():
	var paint_controller: Node2D = $"../PaintController"
	paint_controller.register_painter(self)

func _input(event):
	if is_selected and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Устанавливаем новую цель
			target_position = get_global_mouse_position()
			is_moving = true

func _physics_process(delta):
	if !is_moving:
		return
	$"../PaintController".paint(global_position)
	# Рассчитываем направление
	var direction = global_position.direction_to(target_position)
	var distance = global_position.distance_to(target_position)
	
	# Проверяем достижение цели
	if distance <= stopping_distance:
		stop_moving()
		return
	
	# Плавный поворот (без переворота вверх ногами)
	var target_angle = direction.angle()
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)  # Корректный расчет разницы углов
	
	rotation += angle_diff * rotation_speed * delta
	
	# Движение с плавным ускорением/торможением
	var current_speed = speed
	if distance < speed * 0.5:  # Начинаем тормозить заранее
		current_speed = speed * (distance / (speed * 0.5))
	
	# Применяем движение
	velocity = direction * current_speed
	move_and_slide()

func stop_moving():
	is_moving = false
	velocity = Vector2.ZERO

func select():
	is_selected = true
	sprite.modulate = Color(1.2, 1.2, 0.8)  # Подсветка

func deselect():
	is_selected = false
	sprite.modulate = Color.WHITE
