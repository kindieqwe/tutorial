# meta-name: EnemyAction
# meta-description: An action which can be performed by an enemy during its turn.
extends EnemyAction

#覆盖 父类的虚方法
func perform_action() -> void:
	if not enemy or not target:   #检查是否存在 enemy 和 目标
		return
	
	#set_trans用于设置Tween实例的过渡类型。
	#Tween.TRANS_QUINT是一种缓动函数，表示五次方缓动，用于创建平滑的加速和减速效果
	var tween := create_tween().set_trans(Tween.TRANS_QUINT) #创建新的动画
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	
	SFXPlayer.play(sound)
	
	Events.enemy_action_completed.emit(enemy)
