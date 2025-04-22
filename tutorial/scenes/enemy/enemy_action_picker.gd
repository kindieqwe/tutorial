class_name EnemyActionPicker
extends Node
#导出变量 ，一个用于敌人自己，一个用于玩家 并设置自动向因函数
@export var enemy: Enemy: set = _set_enemy
@export var target: Node2D: set = _set_target

@onready var total_weight := 0.0  #记录敌人所有攻击手段的总权重

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")  #设置目标为玩家
	setup_chances()
	
#返回一个敌人攻击手段
func get_action() -> EnemyAction:
	var action := get_first_conditional_action()  #如果触发了某个条件型手段的条件，立即使用该技能，不使用别的技能
	if action:
		return action
		
	return  get_chance_based_action()
	
#返回可执行的条件性技能	
func get_first_conditional_action() -> EnemyAction:
	var action: EnemyAction
	
	for child in get_children():     #遍历所有攻击手段
		action = child as EnemyAction  
		#（not action）或动作类型不是 CONDITIONAL 
		if not action or action.type != EnemyAction.Type.CONDITIONAL:
			continue   #跳过当前子节点
			
		if action.is_performable():
			return action 
	return null


func get_chance_based_action() -> EnemyAction:
	var action: EnemyAction
	var roll := randf_range(0.0, total_weight)  #掷筛子，骰出一个0-总权重的 数字
	
	for child in get_children():     #遍历所有攻击手段
		action = child as EnemyAction  
		#（not action）或动作类型不是 CONDITIONAL 
		if not action or action.type != EnemyAction.Type.CHANCE_BASED:
			continue   #跳过当前子节点
			
		if action.accumlated_weight > roll:  #action.accumlated_weight 就是总权重
			return action 
	return null
	

func setup_chances() -> void:
	var action: EnemyAction
	
	for child in get_children():
		action = child as EnemyAction
		if not action or action.type != EnemyAction.Type.CHANCE_BASED:
			continue
			
		total_weight += action.chance_weight
		action.accumlated_weight = total_weight
		
#设置施法目标为敌人自己	
func _set_enemy(value: Enemy) -> void:
	enemy = value
	for action in get_children():
		action.enemy = enemy
		
#设置施法目标为玩家			
func _set_target(value: Node2D) -> void:
	target = value
	for action in get_children():
		action.target = target
