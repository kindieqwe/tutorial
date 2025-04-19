extends CardState

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	#检查父节点是否准备好
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	#排除BUG 否则卡牌会卡在aiming位置 而不返回手牌区
	#设计意图： 状态机收到装换卡牌为BASE时，检测卡牌是否处于AIMING动画播放，是则主动杀死，再进入Hand父化
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
		
	card_ui.reparent_requested.emit(card_ui)
	card_ui.color.color = Color.WEB_GREEN
	card_ui.state.text = "BASE"
	card_ui.pivot_offset = Vector2.ZERO
		
	
func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		#计算旋转中心偏移量
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		#从当前状态过度到点击转态
		transition_requested.emit(self,CardState.State.CLICKED)
		
