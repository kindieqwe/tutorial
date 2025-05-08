# Player turn order:
# 1. START_OF_TURN Relics   #启用遗物
# 2. START_OF_TURN Statuses  状态实现
# 3. Draw Hand            抽牌
# 4. End Turn        结束回合
# 5. END_OF_TURN Relics    遗物
# 6. END_OF_TURN Statuses  状态
# 7. Discard Hand          弃牌
class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.25  #每抽一张卡牌 设置0.25的时间 防止所有卡牌一瞬间出现在手牌中
const HAND_DISCARD_INTERVAL := 0.25 

@export var relics: RelicHandler
@export var player: Player
@export var hand: Hand

var character: CharacterStats

func _ready() -> void:
	Events.card_played.connect(_on_card_played)
	
 
func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()  #新建一个卡牌堆 设置为弃牌堆
	
	#if not relics.relics_activated.connect(_on_relics_activated):
	relics.relics_activated.connect(_on_relics_activated)
	#if not player.status_handler.statuses_applied.connect(_on_statuses_applied):
	player.status_handler.statuses_applied.connect(_on_statuses_applied)
	start_turn()
	
	
func start_turn() -> void:
	character.block = 0
	character.reset_mana()
	#player.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
	#relics.relics_activated.connect(_on_relics_activated)
	relics.activate_relics_by_type(Relic.Type.START_OF_TURN)


func end_turn() -> void:
	hand.disable_hand()  #防止弃牌时产生交互
	#player.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)
	relics.activate_relics_by_type(Relic.Type.END_OF_TURN)
	
	
func draw_card() -> void:
	reshuffle_deck_from_discard()  #洗牌
	hand.add_card(character.draw_pile.draw_card())
	reshuffle_deck_from_discard()
	
	
func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):   #用循环多次抽取卡牌
		#tween_callback是在每个动画步骤完成后调用的回调 每个动画完成就再次调用抽牌函数 draw_card
		tween.tween_callback(draw_card)   #调用上面的函数是什么意思？
		tween.tween_interval(HAND_DRAW_INTERVAL)   #等待间隔时间
	#匿名函数连接	
	tween.finished.connect(
		func(): Events.player_hand_drawn.emit()
	)
	
	
func discard_cards() -> void:
	if hand.get_child_count() == 0:
		Events.player_hand_discarded.emit()
		return
		
	var tween := create_tween()
	for card_ui: CardUI in hand.get_children():
		 #只是把回合结束时把未出的卡牌放入弃牌堆 ，但打出的牌没有放入弃牌堆
		tween.tween_callback(character.discard.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	tween.finished.connect(
		func():
			Events.player_hand_discarded.emit()
	)
	
#洗牌功能
func reshuffle_deck_from_discard() -> void:
	if not character.draw_pile.empty():   #如果抽卡堆不为空 则不需要操作
		return
	
	while not character.discard.empty():  #一直循环到弃牌堆为空
		character.draw_pile.add_card(character.discard.draw_card())  #抽牌堆种每循环一次加入一张弃牌堆里的卡牌
		
	character.draw_pile.shuffle()  #shuffle()  打乱顺序

#把打出的卡牌加入到弃牌堆
func _on_card_played(card: Card) -> void:
	#实现消耗的逻辑？ 不加入弃牌堆就是消耗？ 消失了？
	if card.exhausts or card.type == Card.Type.POWER:
		return
		
	character.discard.add_card(card)
	

func _on_statuses_applied(type: Status.Type) -> void:
	match type:
		Status.Type.START_OF_TURN:
			draw_cards(character.cards_per_turn)
		Status.Type.END_OF_TURN:
			discard_cards()
			
			
func _on_relics_activated(type: Relic.Type) -> void:
	match type:
		Relic.Type.START_OF_TURN:
			player.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
		Relic.Type.END_OF_TURN:
			player.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)
