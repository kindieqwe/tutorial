class_name Card
extends Resource

enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int #卡牌消耗的法力

@export_group("Card Visuals")
@export var icon: Texture             #卡牌图标
@export_multiline var tooltip_text: String     #文本提示字符串  多行形式


#判断卡牌是否为单一目标
func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


	
