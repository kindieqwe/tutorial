class_name CardPile
extends Resource

signal card_pile_size_changed(cards_amount) #卡堆大小发生变化时触发 cards_amount : 变化后卡堆的数量

@export var cards: Array[Card] = []  #数据结构：卡片数组

#检查卡堆数量是否为空，洗牌？
func empty() -> bool:
	return cards.is_empty()
	
#抽一张牌，抽出牌堆最前面的牌，并改变牌堆的大小
func draw_card() -> Card:
	var card = cards.pop_front()    #移除并返回数组中第一个元素
	card_pile_size_changed.emit(cards.size())  #发出数组大小改变的信号
	return card
	
#添加卡牌到牌堆中 card：新获得的卡牌
func add_card(card: Card):
	cards.append(card)            #在cards数组末尾添加卡牌
	card_pile_size_changed.emit(cards.size())  #发出信号
	
#洗牌
func shuffle() -> void:
	cards.shuffle()       #shuffle() 方法打乱顺序  
	
#清空卡牌堆
func clear() -> void:
	cards.clear()         #clear() 清空数组
	card_pile_size_changed.emit(cards.size())  #发出信号
	
#	将卡牌数组转换为可读字符串的工具方法
func _to_string() -> String:
	var _card_strings: PackedStringArray = []
	for i in range(cards.size()):
		_card_strings.append("%s: %s" % [i+1,cards[i].id])
	return "\n".join(_card_strings)
	
