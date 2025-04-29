class_name CardVisuals
extends Control

@export var card: Card : set = set_card   #card 变量 指定set_card（）函数

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var rarity: TextureRect = $Rarity


func set_card(value: Card) -> void:
	if not is_node_ready():
		await  ready
		
	card = value  #设置card 为传入的新变量
	cost.text = str(card.cost)
	icon.texture = card.icon
	rarity.modulate = Card.RARITY_COLORS[card.rarity]   #Godot引擎中控制节点颜色的属性
	
	
