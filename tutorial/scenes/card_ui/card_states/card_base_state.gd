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
	
	card_ui.card_visuals.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	card_ui.reparent_requested.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO
	Events.tooltip_hide_requested.emit()
	
func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disable:  #检查卡牌能否打出，或被禁用
		return
		
	if event.is_action_pressed("left_mouse"):
		#计算旋转中心偏移量
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		#从当前状态过度到点击转态
		transition_requested.emit(self,CardState.State.CLICKED)
		
#func on_mouse_enterded() -> void:         “BUG 拼写错误    ”
func on_mouse_entered() -> void:      
	if not card_ui.playable or card_ui.disable:  #检查卡牌能否打出，或被禁用
		return
			
	card_ui.card_visuals.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)
	Events.card_tooltip_requested.emit(card_ui.card.icon, card_ui.card.tooltip_text)
	

func on_mouse_exited() -> void:
	if not card_ui.playable or card_ui.disable:  #检查卡牌能否打出，或被禁用
		return
			
	card_ui.card_visuals.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()
