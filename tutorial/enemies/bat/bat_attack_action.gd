extends EnemyAction

@export var damage := 4
#覆盖 父类的虚方法
func perform_action() -> void:
	if not enemy or not target:   #检查是否存在 enemy 和 目标
		return
	
	#set_trans用于设置Tween实例的过渡类型。
	#Tween.TRANS_QUINT是一种缓动函数，表示五次方缓动，用于创建平滑的加速和减速效果
	var tween := create_tween().set_trans(Tween.TRANS_QUINT) #创建新的动画
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target]
	damage_effect.amount = damage
	damage_effect.sound = sound 
	SFXPlayer.play(sound)
	
	#让敌人缓动到玩家位置 并攻击两次 
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(damage_effect.execute.bind(target_array)) #第一次伤害效果
	tween.tween_interval(0.35)
	
	tween.tween_callback(damage_effect.execute.bind(target_array))  #第二次伤害效果
	tween.tween_interval(0.25)
	tween.tween_property(enemy, "global_position", start, 0.4)  #返回原来的位置
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
	
