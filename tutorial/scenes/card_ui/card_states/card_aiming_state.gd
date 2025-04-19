extends CardState

const MOUSE_Y_SNAPBACK_THRESHOLD := 138


func enter() -> void:
	card_ui.color.color = Color.WEB_PURPLE    
	#card_ui.state.text = "AIMING"        “BUG 拼写错误”
	card_ui.state.text = "AIMING"
	#进入瞄准后， 要确保目标只有敌人 故需要清空
	card_ui.targets.clear()
	
	var offset := Vector2(card_ui.parent.size.x / 2, - card_ui.size.y / 2)
	offset.x -= card_ui.size.x / 2
	card_ui.animate_to_position(card_ui.parent.global_position + offset, 0.2)
	#关闭卡牌的落点监视
	card_ui.drop_point_detector.monitoring = false
	Events.card_aim_started.emit(card_ui)
	
	
func exit() -> void:
	Events.card_aim_ended.emit(card_ui)
	
#处理玩家输入事件
func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var mouse_at_bottom := card_ui.get_global_mouse_position().y > MOUSE_Y_SNAPBACK_THRESHOLD
	
	if (mouse_motion and mouse_at_bottom) or event.is_action_pressed("right_mouse"):
		transition_requested.emit(self, CardState.State.BASE)
	elif event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse"):
		#将输入标记为已处理，以免意外立即拾取新的卡片
		get_viewport().set_input_as_handled()
		transition_requested.emit(self,CardState.State.RELEASED)
	
	
		
		
	
	
	
