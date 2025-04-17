class_name StateMachine
extends Node


# 当前状态变量
var current_state:int =-1 :
	# 设置当前状态的方法
	set(v):
		owner.transition_state(current_state,v)
		current_state =v
# 节点准备好时调用		
func _ready()-> void:
	# 确保 owner 存在并已准备好
	await owner.ready
	current_state =0  # 初始状态设置为 0
# 物理帧处理	
func _physics_process(delta: float) -> void:
	while true:
		
		var next := owner.get_next_state(current_state) as int
		if  current_state == next:
			break
		current_state = next    # 更新状态
	owner.tick_physics(current_state, delta) # 调用 tick_physics 方法
