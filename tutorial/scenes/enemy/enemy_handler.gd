class_name EnemyHandler
extends Node

func _ready() -> void:
	Events.enemy_action_completed.connect(_on_enemy_action_completed)
	

#func reset_enemy_actions() -> void:
	#var enemy: Enemy
	#for child in get_children():
		#enemy = child as Enemy
		#enemy.current_action = null
		#enemy.update_action()
		
func setup_enemies(battle_stats: BattleStats) -> void:
	if not battle_stats:
		return
		
	for enemy: Enemy in get_children():
		enemy.queue_free()	
		
	var all_new_enemies := battle_stats.enemies.instantiate()
	
	for new_enemy: Node2D in all_new_enemies.get_children():
		var new_enemy_child := new_enemy.duplicate() as Enemy
		add_child(new_enemy_child)
		
	all_new_enemies.queue_free()
	
	
func reset_enemy_actions() -> void:
	for enemy: Enemy in get_children():
		enemy.current_action = null
		enemy.update_action()


#回合开始
func start_turn() -> void:
	if get_child_count() == 0:   #判断又没有字节点; 说明敌人全部被击败
		return
		  
	var first_enemy: Enemy = get_child(0) as Enemy  #抓取索引为 0 的第一个敌人
	first_enemy.do_turn()
	
	
func _on_enemy_action_completed(enemy: Enemy) -> void:
	if enemy.get_index() == get_child_count() -1:  #敌人节点的最后一个节点 
		Events.enemy_turn_ended.emit()
		return
		
	var next_enemy: Enemy = get_child(enemy.get_index() + 1) as Enemy #下一个敌人节点
	next_enemy.do_turn()
	
