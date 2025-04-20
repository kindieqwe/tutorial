class_name StatsUI
extends HBoxContainer
#定义四个变量 对状态UI做出事件响应
@onready var block: HBoxContainer = $Block
@onready var block_label: Label = %BlockLabel
@onready var health: HBoxContainer = $Health
@onready var health_label: Label = %HealthLabel

#stats :新的状态
func update_stats(stats: Stats) -> void:
	block_label.text = str(stats.block)
	health_label.text = str(stats.health)
	
	block.visible = stats.block >0  #护盾的可见性，有护盾就显现图标
	health.visible = stats.health > 0
	
	
	
