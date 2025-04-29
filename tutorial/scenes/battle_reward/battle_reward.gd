class_name BattleReward
extends Control

enum Type {GOLD, NEW_CRAD, RELIC}

#预加载场景 可以在代码中实现对其实例化
const CARD_REWARDS = preload("res://scenes/ui/card_rewards.tscn")
const REWARD_BUTTON := preload("res://scenes/ui/reward_button.tscn")
const GOLD_ICON := preload("res://art/gold.png")
const GOLD_TEXT := "%s gold"  #GOLD_TEXT是一个模板，amount的值会被插入到%s的位置，生成类似“100 gold”的字符串
const CARD_ICON := preload("res://art/rarity.png")
const CARD_TEXT := "Add New Card"
#运行统计的导出变量
@export var run_stats: RunStats
@export var character_stats: CharacterStats
@onready var rewards: VBoxContainer = %Rewards

var card_reward_total_weight := 0.0
var card_rarity_weights := {
	Card.Rarity.COMMON: 0.0,
	Card.Rarity.UNCOMMON: 0.0,
	Card.Rarity.RARE: 0.0	
}
#启动前 先删除掉场景中的占位符  再重新从统计数据中创建新的实例
func _ready() -> void:
	for node: Node in rewards.get_children():
		node.queue_free()
		
	#测试代码
	#run_stats = RunStats.new()
	#run_stats.gold_changed.connect(func(): print("gold: %s" % run_stats.gold))		
	#character_stats = preload("res://characters/warrior/warrior.tres").creat_instance()
	#add_gold_reward(77)
	#add_card_reward()
	#add_card_reward()
	#var gold_reward:= REWARD_BUTTON.instantiate() as RewardsButton
	#gold_reward.reward_icon = GOLD_ICON
	#gold_reward.reward_text = GOLD_TEXT % 55
	#gold_reward.pressed.connect(func(): run_stats.gold += 55)
	#rewards.add_child.call_deferred(gold_reward)   # 在容器中 rewards 中添加 金币奖励 gold_reward作为子节点
	
func add_gold_reward(amount: int) -> void:
	var gold_reward:= REWARD_BUTTON.instantiate() as RewardsButton
	gold_reward.reward_icon = GOLD_ICON
	gold_reward.reward_text = GOLD_TEXT % amount
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(amount))
	rewards.add_child.call_deferred(gold_reward)   # 在容器中 rewards 中添加 金币奖励 gold_reward作为子节点 
	

func add_card_reward() -> void:
	var card_reward := REWARD_BUTTON.instantiate() as RewardsButton
	card_reward.reward_icon = CARD_ICON
	card_reward.reward_text = CARD_TEXT
	card_reward.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(card_reward)


func _show_card_rewards() -> void:
	if not run_stats or not character_stats:
		return
	
	var card_rewards := CARD_REWARDS.instantiate() as CardRewards
	add_child(card_rewards)
	card_rewards.card_reward_selected.connect(_on_card_reward_taken)
	
	var card_reward_array: Array[Card] = []
	var available_cards: Array[Card] = character_stats.draftable_cards.cards.duplicate(true)
	
	for i in run_stats.card_rewards:
		_setup_card_chances()
		var roll := randf_range(0.0, card_reward_total_weight)
		
		for rarity: Card.Rarity in card_rarity_weights:
			if card_rarity_weights[rarity] > roll:
				_modify_weights(rarity)
				var picked_card := _get_random_available_card(available_cards, rarity)
				card_reward_array.append(picked_card)
				available_cards.erase(picked_card)
				break

	card_rewards.rewards = card_reward_array
	card_rewards.show()
	
	
func _setup_card_chances() -> void:
	card_reward_total_weight = run_stats.common_weight + run_stats.uncommon_weight + run_stats.rare_weight
	card_rarity_weights[Card.Rarity.COMMON] = run_stats.common_weight
	card_rarity_weights[Card.Rarity.UNCOMMON] = run_stats.common_weight + run_stats.uncommon_weight
	card_rarity_weights[Card.Rarity.RARE] = card_reward_total_weight


func _modify_weights(rarity_rolled: Card.Rarity) -> void:
	if rarity_rolled == Card.Rarity.RARE:
		run_stats.rare_weight = RunStats.BASE_RARE_WEIGHT
	else:
		run_stats.rare_weight = clampf(run_stats.rare_weight + 0.3, run_stats.BASE_RARE_WEIGHT, 5.0)


func _get_random_available_card(available_cards: Array[Card], with_rarity: Card.Rarity) -> Card:
	var all_possible_cards := available_cards.filter(
		func(card: Card):
			return card.rarity == with_rarity
	)
	return all_possible_cards.pick_random()


func _on_card_reward_taken(card: Card) -> void:
	if not character_stats or not card:
		return
	print("拿卡之前卡牌数量: \n%s\n" % character_stats.deck)
	character_stats.deck.add_card(card)
	print("拿卡之后卡牌数量: \n%s\n" % character_stats.deck)

func _on_gold_reward_taken(amount: int) -> void:
	if not run_stats:
		return
		
	run_stats.gold += amount
	 
	
func _on_back_button_pressed() -> void:
	Events.battle_reward_exited.emit()
