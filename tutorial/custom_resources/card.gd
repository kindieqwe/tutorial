class_name Card
extends Resource

enum Type {ATTACK, SKILL, POWER}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target

#判断卡牌是否为单一目标
func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


	
