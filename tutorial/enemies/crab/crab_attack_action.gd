extends EnemyAction

@export var damage := 7


func perform_action() -> void:
	if not enemy or not target:  #
		return
	#将敌人的位置从原始位置渐变到玩家位置（攻击动画），并且返回	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT) 
	var start := enemy.global_position  #start 敌人的起始位置，敌人的全局位置
	var end := target.global_position + Vector2.RIGHT * 32  #终点位置：玩家的向右便宜32像素
	var damage_effect := DamageEffect.new()   #伤害效果
	var target_array: Array[Node] = [target]
	damage_effect.sound = sound
	damage_effect.amount = damage  #导出的damage 赋值给伤害效果
	
	# enemy: 目标对象，即需要改变位置的敌人节点。
	#"global_position": 目标属性，即敌人的全局位置。
	#start: 渐变的起始值，通常是敌人当前的全局位置，或者是一个新的起始位置。
	#0.4: 渐变的持续时间，单位为秒
	tween.tween_property(enemy, "global_position", end, 0.4)  #
	tween.tween_callback(damage_effect.execute.bind(target_array)) #动画完成执行伤害
	tween.tween_interval(0.25)  #
	tween.tween_property(enemy, "global_position",start, 0.4) #返回
	
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)   #enemy 多种类型敌人的某一个？
	)
	
	
func update_intent_text() -> void:
	var player := target as Player
	if not player:
		return
	
	var modified_dmg := player.modifier_handler.get_modified_value(damage, Modifier.Type.DMG_TAKEN)
	intent.current_text = intent.base_text % modified_dmg
