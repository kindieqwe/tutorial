class_name Hand
extends HBoxContainer

@export var char_stats: CharacterStats

@onready var card_ui = preload("res://scenes/card_ui/card_ui.tscn")

var cards_played_this_turn := 0  #跟踪这回合可以打出多少张牌


	
func add_card(card: Card) -> void:
	var new_card_ui := card_ui.instantiate()
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.parent = self
	new_card_ui.char_stats = char_stats
	

func discard_card(card: CardUI) -> void:
	card.queue_free()
	
#结束回合 隐藏手牌区
func disable_hand() -> void:
	for card: CardUI in get_children():
		card.disable = true
		
	#for child in get_children():
		#var card_ui := child as CardUI
		#card_ui.parent = self
		#card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)


func _on_card_played(_card: Card) -> void:
	cards_played_this_turn += 1
	

func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.disable = true  #避免回到手牌过程中，被鼠标悬停而触发其他不该出现的事件
	child.reparent(self)
	var new_index := clampi(child.original_index - cards_played_this_turn, 0, get_child_count())
	move_child.call_deferred(child, new_index)  #把 child 索引位置设置为new_index
	child.set_deferred("disable", false)

	
