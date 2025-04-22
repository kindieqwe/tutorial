extends EnemyAction

@export var block := 6


func perform_action() -> void:
	if not enemy or not target:
		return
		
	var block_effect := BlockEffect.new()
	block_effect.amount = block
	block_effect.exectue([enemy])
	
	#创建一个定时器，延迟时间为0.6秒，false表示这是一个一次性定时器（只触发一次）。
	#timeout: 定时器的超时信号，当定时器结束时发出。
	#connect(...): 将timeout信号连接到一个函数，当信号发出时，执行该函数
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
	
	
