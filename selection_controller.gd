extends Node

var selected_units: Array = []  # Массив выделенных юнитов

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Снимаем выделение со всех юнитов
			for unit in selected_units:
				if is_instance_valid(unit):
					unit.deselect()
			selected_units.clear()
			
			# Проверяем, кликнули ли по юниту
			var mouse_pos = get_viewport().get_mouse_position()
			var space_state = get_viewport().world_2d.direct_space_state
			var query = PhysicsPointQueryParameters2D.new()
			query.position = get_viewport().get_camera_2d().get_screen_center_position() + (mouse_pos - get_viewport().size * 0.5)
			query.collision_mask = 1  # Убедитесь, что юнит на этом слое
			
			var result = space_state.intersect_point(query)
			
			# Если кликнули по юниту — выделяем его
			if result.size() > 0:
				for collider in result:
					if collider.collider.has_method("select"):
						collider.collider.select()
						selected_units.append(collider.collider)
						break
