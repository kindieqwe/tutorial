extends EnemyAction

@export var block := 4
#覆盖 父类的虚方法
func perform_action() -> void:
	if not enemy or not target:   #检查是否存在 enemy 和 目标
		return
	var block_effect := BlockEffect.new() 
	block_effect.amount = block   #设置护盾数量
	block_effect.sound = sound  	#设置护盾音效
	block_effect.execute([enemy])   #执行护盾效果
	#true，定时器只会触发一次；如果为false，定时器会重复触发
	get_tree().create_timer(0.6, false).timeout.connect(  
		func():
			Events.enemy_action_completed.emit(enemy)
	)
	
