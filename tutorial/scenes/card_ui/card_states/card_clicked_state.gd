extends CardState

func enter() -> void:
	#检查父节点是否准备好
	#if not card_ui.is_node_ready():
		#await card_ui.ready
	
		#card_ui.reparent_requested.emit(card_ui)
	card_ui.original_index = card_ui.get_index()   #得到出牌时的索引，以便放弃出这张牌时回到原来的位置
	card_ui.drop_point_detector.monitoring = true
		

func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self,CardState.State.DRAGGING)
		
