extends Camera2D

# Настройки движения
@export var max_scroll_speed: float = 800.0    # Максимальная скорость
@export var min_scroll_speed: float = 100.0     # Минимальная скорость у края зоны
@export var edge_margin: float = 100.0          # Зона у края, где начинается движение
@export var smooth_speed: float = 10.0          # Плавность перемещения (1-10)
@export var joystick_deadzone: float = 0.2      # Мёртвая зона джойстика

var target_position: Vector2
var joystick_input := Vector2.ZERO

func _ready() -> void:
	target_position = position
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	# Получаем ввод с джойстика
	joystick_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Вектор направления движения
	var move_direction := Vector2.ZERO
	
	# 1. Приоритет: джойстик (если есть ввод)
	if joystick_input.length() > joystick_deadzone:
		move_direction = joystick_input.normalized()
	# 2. Движение при приближении к краям (ПК)
	elif OS.has_feature("pc"):
		move_direction = _get_edge_scroll_direction()
	
	# Обновляем позицию с плавным ускорением
	target_position += move_direction * max_scroll_speed * delta
	target_position.x = clamp(target_position.x, limit_left, limit_right)
	target_position.y = clamp(target_position.y, limit_top, limit_bottom)
	
	# Плавное перемещение камеры
	position = position.lerp(target_position, smooth_speed * delta)

func _get_edge_scroll_direction() -> Vector2:
	var mouse_pos := get_viewport().get_mouse_position()
	var viewport_size := get_viewport().get_visible_rect().size
	var direction := Vector2.ZERO
	var intensity := Vector2.ZERO  # Интенсивность (0-1)
	
	# Горизонтальное движение
	if mouse_pos.x < edge_margin:
		intensity.x = 1.0 - (mouse_pos.x / edge_margin)
		direction.x = -1.0
	elif mouse_pos.x > viewport_size.x - edge_margin:
		intensity.x = 1.0 - ((viewport_size.x - mouse_pos.x) / edge_margin)
		direction.x = 1.0
	
	# Вертикальное движение
	if mouse_pos.y < edge_margin:
		intensity.y = 1.0 - (mouse_pos.y / edge_margin)
		direction.y = -1.0
	elif mouse_pos.y > viewport_size.y - edge_margin:
		intensity.y = 1.0 - ((viewport_size.y - mouse_pos.y) / edge_margin)
		direction.y = 1.0
	
	# Комбинируем направление с интенсивностью
	var speed_factor = max(intensity.x, intensity.y)
	var current_speed = lerp(min_scroll_speed, max_scroll_speed, speed_factor)
	
	return direction.normalized() * (current_speed / max_scroll_speed)

func _input(event: InputEvent) -> void:
	# Позволяем двигать камеру при зажатой средней кнопке мыши
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		target_position -= event.relative * (max_scroll_speed / 500.0)
