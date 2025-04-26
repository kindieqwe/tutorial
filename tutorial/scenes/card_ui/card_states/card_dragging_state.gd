extends CardState

const  DRAG_MINIMUN_THRESHOLD := 0.05

var minimum_drag_time_elapsed := false


func enter() -> void:
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
		
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.DRAG_STYLEBOX)
	Events.card_drag_started.emit(card_ui)
	
	#创建一次性计时器（false参数表示不自动重复）
	#设置计时时长为DRAG_MINIMUN_THRESHOLD（假设为常量）
	#计时结束后标记minimum_drag_time_elapsed为true
	minimum_drag_time_elapsed = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUN_THRESHOLD,false)
	threshold_timer.timeout.connect(func() : minimum_drag_time_elapsed = true)
	

func exit() -> void:
	Events.card_drag_ended.emit(card_ui)  #发出卡牌退出拖动状态信号

func on_input(event: InputEvent) -> void:
	# 变量signal_targeted 赋值bool类型函数，用于检测是否为单一目标卡牌
	var signal_targeted := card_ui.card.is_single_targeted()
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	#bug提示：如果短时间内同时满足两个条件，会出bug
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	#同时满足三个条件才进入瞄准状态，单一目标，鼠标移动，卡牌有目标区域（即卡牌到了释放区域，如果还在手牌区则返回base）
	if signal_targeted and mouse_motion and card_ui.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return
		
	if mouse_motion:
		#卡牌的位置设置为鼠标的位置
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
		
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif confirm:
		#将输入标记为已处理，以免意外立即拾取新的卡片
		get_viewport().set_input_as_handled()
		transition_requested.emit(self,CardState.State.RELEASED)
		
		
		
		
