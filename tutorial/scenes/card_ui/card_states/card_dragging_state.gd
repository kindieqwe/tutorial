extends CardState

const  DRAG_MINIMUN_THRESHOLD := 0.02

var minimum_drag_time_elapsed := false


func enter() -> void:
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
		
	card_ui.color.color = Color.NAVY_BLUE
	card_ui.state.text = "DRAGGING"
	
	#创建一次性计时器（false参数表示不自动重复）
	#设置计时时长为DRAG_MINIMUN_THRESHOLD（假设为常量）
	#计时结束后标记minimum_drag_time_elapsed为true
	minimum_drag_time_elapsed = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUN_THRESHOLD,false)
	threshold_timer.timeout.connect(func() : minimum_drag_time_elapsed = true)
	


func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	#bug提示：如果短时间内同时满足两个条件，会出bug
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	if mouse_motion:
		#卡牌的位置设置为鼠标的位置
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
		
	if cancel:
		transition_requested.emit(self,CardState.State.BASE)
	elif confirm:
		#将输入标记为已处理，以免意外立即拾取新的卡片
		get_viewport().set_input_as_handled()
		transition_requested.emit(self,CardState.State.RELEASED)
		
		
		
		
