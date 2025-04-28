class_name CardPileView
extends Control

const CARD_MENU_UI_SCENE = preload("res://scenes/ui/card_menu_ui.tscn")
#一个可以外部设置的属性 牌堆
@export var card_pile: CardPile

@onready var title: Label = %Title
@onready var cards: GridContainer = %Cards
@onready var back_button: Button = %Button
@onready var card_tooltip_popup: CardTooltipPopup = %CardTooltipPopup


func _ready() -> void:
	back_button.pressed.connect(hide)  #退出按钮 按下时 响应hide函数
	
	for card: Node in cards.get_children():  #删除所有的占位符
		card.queue_free()
	
	card_tooltip_popup.hide_tooltip()
	
	
	
#处理键盘输入事件 按下ESC 隐藏提示
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if card_tooltip_popup.visible:
			card_tooltip_popup.hide_tooltip()
		else:
			hide()
			
#展示牌堆
func show_current_view(new_title: String, randomized: bool = false) -> void:
	for card: Node in cards.get_children():
		card.queue_free()
		
	card_tooltip_popup.hide_tooltip()
	title.text = new_title
	_update_view.call_deferred(randomized)  #帧末尾调用 更新视图的函数 
	
#更新视图
func _update_view(randomized: bool) -> void:
	if not card_pile:   #安全检查
		return
		
	var all_cards := card_pile.cards.duplicate()  #从牌堆中复制一份
	if randomized:   #如果 变量 randomized == false
		all_cards.shuffle()   #打乱复制后的牌堆顺序
	
	for card: Card in all_cards:  #遍历复制后的牌堆中 的卡牌
		var new_card := CARD_MENU_UI_SCENE.instantiate() as CardMenuUI  #每次实例一个卡牌菜单
		cards.add_child(new_card)          #在网格容器（cards）中 添加 刚新实例的卡牌菜单
		new_card.card = card				#每次把遍历的卡牌 赋值给 新实例的卡牌菜单
		new_card.tooltip_requested.connect(card_tooltip_popup.show_tooltip)  #信号连接
		
	show()  #展示 牌堆
