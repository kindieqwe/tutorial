class_name Card
extends Resource

enum Type {ATTACK, SKILL, POWER}
enum Rarity {COMMON, UNCOMMON, RARE} #卡牌的稀有度
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

const RARITY_COLORS := {
	Card.Rarity.COMMON: Color.GRAY,
	Card.Rarity.UNCOMMON: Color.CORNFLOWER_BLUE,
	Card.Rarity.RARE: Color.GOLD
}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var rarity: Rarity
@export var target: Target
@export var cost: int #卡牌消耗的法力

@export_group("Card Visuals")
@export var icon: Texture             #卡牌图标
@export_multiline var tooltip_text: String     #文本提示字符串  多行形式
@export var sound: AudioStream    #导出变量 音效

#判断卡牌是否为单一目标
func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY

#获取目标数组，包含自身，敌人，所有敌人，所有人			
func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []

	var tree := targets[0].get_tree()   #tree赋值为 目标数组中的第一个元素
	
	match target:    #match 匹配目标 可用目标的枚举值
		Target.SELF:
			return tree.get_nodes_in_group("player") 
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies") #场景树？
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []
			
func play(targets: Array[Node], char_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	char_stats.mana -= cost
	
	if is_single_targeted():    #检测为单一目标
		apply_effects(targets)
	else:                        #检测为多个目标
		apply_effects(_get_targets(targets))

#由子类覆写
func apply_effects(_targets: Array[Node]) -> void:
	
	pass
			
