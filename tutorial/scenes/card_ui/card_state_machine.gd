class_name CardStateMachine
extends Node

@export var initial_state: CardState

var current_state : CardState
var states := {}

func init(card :CardUI) -> void:
	for child in get_children():
		if child is CardState:
			states[child.state] = child
			#_on_transition_requested 状态机中的处理转换请求的函数
			#transition_requested 是转态发送信号
			child.transition_requested.connect(_on_transition_requested)
			child.card_ui = card
	#如果有初始状态，就进入那个状态，并将当前状态设置为初始状态		
	if initial_state:
		initial_state.enter()
		current_state = initial_state
#回调函数用于输入事件，处理物理输入事件（如键盘/鼠标移动）
func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)
#处理GUI控件输入事件（如按钮点击），将事件转发给当前状态对象处理
func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)
		
func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()
		
func on_mouse_exited() -> void:
	if current_state:
		#下面的 on_mouse_exited() 是 CardState的函数
		current_state.on_mouse_exited()
#处理状态转换
func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	#检查两个状态是否相等
	if from != current_state:
		return
	#检查新状态是否存在于状态库中，不存在则返回	
	var new_state: CardState = states[to]
	if not new_state:
		return
	#如果有，先退出当前状态
	if current_state:
		current_state.exit()
	#进入新状态，并将新状态设置为当前状态（完成状态转换）
	new_state.enter()
	current_state = new_state


		
		
		
		
		
		
		
		
		
		
		
		
