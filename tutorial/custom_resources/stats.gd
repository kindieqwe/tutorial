class_name Stats
extends Resource
#:此脚本用于跟踪角色的 血量，防御，攻击等属性
signal stats_changed   #发出状态改变信号，通知UI做出响应

@export var max_health := 1   #导出，   用于在检查器中设置最大生命值
@export var art : Texture	 #角色的图像纹理
#@export var art := Texture	 #角色的图像纹理   “BUG ：= 是赋值并且声明 不用赋值只需要 ：”

#当health或block的值被修改时，自动调用set_health或set_block函数 自动发出信号
var health: int : set = set_health
var block: int : set = set_block     

#value: 新的血量数值
func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)  #clampi(value, min, max) 并返回限制后的值
	stats_changed.emit()
	
#value: 新的防御数值 
func set_block(value: int) -> void:
	block = clampi(value, 0, 999)  #999 ： 角色能拥有的最大防御值
	stats_changed.emit()
	
#damage： 伤害量
func take_damage(damage: int) -> void:
	if damage <= 0:
		return  
	var initial_damage = damage
	damage = clampi(damage - block, 0, damage)  #限制伤害在0~damage之间：排除负值，和超出
	self.block = clampi(block - initial_damage, 0, block)  #收到伤害后的护盾值
	self.health -= damage                       #收到伤害后的生命值，会自动发出信号
	
#治疗一定生命值 ： amount
func heal(amount: int) -> void:
	self.health += amount
		
#创建新资源 ： 在战斗场景中设置多个敌人，防止攻击一个敌人，由于共享资源导致其他敌人也收到伤害
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()  #self.duplicate() ： 复制
	instance.health = max_health
	instance.block = 0
	return instance
	
	
