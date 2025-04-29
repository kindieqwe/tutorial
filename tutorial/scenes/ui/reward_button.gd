class_name RewardsButton
extends Button

@export var reward_icon: Texture : set = set_reward_icon  #用于设置奖励图标 金币 or 卡牌
@export var reward_text: String : set = set_reward_text	  #设置奖励文本

@onready var custom_icon: TextureRect = %CustomIcon  
@onready var custom_text: Label = %CustomText

#改变奖励图标 的 setter函数
func set_reward_icon(new_icon: Texture) -> void:
	reward_icon = new_icon
	
	if not is_node_ready():
		await ready
	
	custom_icon.texture = reward_icon


func set_reward_text(new_text: String) -> void:
	reward_text = new_text
	
	if not is_node_ready():
		await ready
	
	custom_text.text = reward_text

#奖励按钮按下时 ，响应  ： 删除这个奖励对象 一次性 
func _on_pressed() -> void:
	queue_free()
