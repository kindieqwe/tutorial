extends EnemyAction

@export var block := 15      #获得的护盾值
@export var hp_threshold := 6  #触发阈值——hp
 
var already_used := false  #检测是否已经执行 true之后不再执行


func is_performable() -> bool:
	if not enemy or already_used:
		return false
		
	var is_low := enemy.stats.health <= hp_threshold
	already_used = is_low
	
	return is_low


func perform_action() -> void:
	#安全检查
	if not enemy or not target:
		return
	
	var block_effect := BlockEffect.new()
	block_effect.amount = block
	block_effect.exectue([enemy])
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)   #enemy 对敌人自己释放
	)
	
