class_name EnemyAction
extends Node

enum Type {CONDITIONAL, CHANCE_BASED}  #枚举数据 记录敌人的释放技能类型？

@export var type: Type  #类型
@export_range(0.0, 10.0) var chance_weight := 0   #权重 expoet_range 可以在检查器中给出区间

@onready var accumlated_weight := 0.0     #基于几率的敌人 

var enemy: Enemy               #目标用于敌人自己
var target: Node2D	           #目标用于玩家

#条件型敌人使用这个，并子类覆盖这个函数  给定一个状态下，某个行动是否可以执行
func is_performable() -> bool:
	return false

#执行行动，实现敌人的攻击逻辑 实现攻击动画效果
func perform_action() -> void:
	pass
	
