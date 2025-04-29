class_name CardMenuUI
extends CenterContainer

signal tooltip_requested(card: Card)  #提示请求信号，点击卡牌时发出信号

#预加载样式 基础样式，悬停样式
const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")
#期望外部设置一个 卡牌属性 ，有自动响应函数
@export var card: Card : set = set_card
#对卡牌的基础属性引用 以便可以改变卡牌的样式框
@onready var visuals: CardVisuals = $Visuals

#鼠标点击事件处理 
func _on_visuals_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		tooltip_requested.emit(card)   #发出卡牌提示请求，并使拥有的卡牌作为参数传递
		print("tooltip_requested %s" % card.id)

func _on_visuals_mouse_entered() -> void:
	visuals.panel.set("theme_override_styles/panel", HOVER_STYLEBOX)


func _on_visuals_mouse_exited() -> void:
	visuals.panel.set("theme_override_styles/panel", BASE_STYLEBOX)
	
	
func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
		
	card = value
	visuals.card = card
