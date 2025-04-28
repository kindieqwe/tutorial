class_name CardTooltipPopup
extends Control

const CARD_MENU_UI_SCENE := preload("res://scenes/ui/card_menu_ui.tscn")

@onready var card_description: RichTextLabel = %CardDescription
@onready var tooltip_card: CenterContainer = %TooltipCard


func _ready() -> void:
	#遍历 tooltip_card 节点下的所有类型为 CardMenuUI的子节点  并删除他们
	for card: CardMenuUI in tooltip_card.get_children():
		card.queue_free()
		

	
#处理鼠标输入， 点击 就隐藏工具提示	
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		hide_tooltip()
	


func hide_tooltip() -> void:
	if not visible:
		return
		
	for card: CardMenuUI in tooltip_card.get_children():
		card.queue_free()
	
	hide()
	
	
func show_tooltip(card: Card) -> void:
	var new_card := CARD_MENU_UI_SCENE.instantiate() as CardMenuUI
	tooltip_card.add_child(new_card)
	new_card.card = card
	new_card.tooltip_requested.connect(hide_tooltip.unbind(1))  #?
	card_description.text = card.tooltip_text
	show()
