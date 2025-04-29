class_name CharacterStats
extends Stats

@export_group("Visuals")   #将下方声明的变量归类到名为 "Visuals" 的折叠组中
#导出 角色名字，描述（多行），图形纹理
@export var character_name: String
@export_multiline var description: String
@export var portrait: Texture

@export_group("Gameplay Data")   #将下方声明的变量归类到名为 "Gameplay Data" 的折叠组中
@export var starting_deck: CardPile    #牌堆
@export var draftable_cards: CardPile    #牌堆
@export var cards_per_turn: int			#每回合能抽取多少牌
@export var max_mana: int    	#法力值

var mana: int : set = set_mana
var deck: CardPile   #手牌
var discard: CardPile  #弃牌堆
var draw_pile: CardPile   #抽排堆

#设置法力值 法力值可以超出限制
func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()


func take_damage(damage: int) -> void:
	var initial_health := health
	super.take_damage(damage)  #super 调用父类的函数
	if initial_health > health:   #如果在take_damage() 之后 初始生命值更高，则发出受伤信号，响应屏幕变红
		Events.player_hit.emit()
	
#每回合重置法力值 
func reset_mana() -> void:
	self.mana = max_mana
	
#检测是否可以打出当前的牌，返回一个布尔值，card：想要打出的牌
func can_play_card(card: Card) -> bool:
	return mana >= card.cost
	
#创建玩家实例 设置对应的属性
func creat_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
