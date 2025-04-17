class_name CardState
extends Node
#枚举类型 储存卡片的所有状态
enum State {BASE, CLICKED, DRAGGING, AIMING, RELEASED}
#信号：状态转换
signal transition_requested(from: CardState, to: State)
#导出变量 state：可以在编辑器中编辑状态
@export var state :State

var card_ui: CardUI

func enter() ->void:
	pass

func exit() ->void:
	pass

func on_input(_event: InputEvent) -> void:
	pass
	
#处理按钮点击事件
func on_gui_input(_event:InputEvent) -> void:
	pass
	
func on_mouse_entered() -> void:
	pass

func on_mouse_exited() -> void:
	pass
	
	
