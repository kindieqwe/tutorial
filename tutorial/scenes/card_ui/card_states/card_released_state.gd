extends CardState
#played：用于记录卡牌是否被打出
var played: bool	

func enter() -> void:
		
		#设为未打出
		played = false
		#检测 卡牌的目标区域是否为空，不为空则可以进行下一步操作
		if not card_ui.targets.is_empty():
			#设为打出
			played = true
			print("played card for targets(s)",card_ui.targets)
			

#处理用户的输入  ：已打出则不处理  ，未打出，如卡牌在手牌区  则需要处理卡牌返回至基础状态
func on_input(_event: InputEvent) -> void:
	if played:
		return
	
	transition_requested.emit(self,CardState.State.BASE)		
