class_name BattleUI
extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var hand: Hand = $Hand as Hand
@onready var mana_ui: ManaUI = $ManaUI as ManaUI
@onready var end_turn_button: Button = $EndTurnButton


func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_draw)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)  #按钮按下与函数连接
	
	
#传入一个资源
func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	mana_ui.char_stats = char_stats   #mana_ui.char_stats 是资源类 角色资源
	hand.char_stats = char_stats
	

func _on_player_hand_draw() -> void:
	end_turn_button.disabled = false   #触发抽牌动作时，把结束按钮功能设为不可见 ，防止抽牌过程被按下结束

#结束按钮被触发时 功能
func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true     #设置 结束按钮可见
	Events.player_turn_ended.emit()     #发出玩家回合结束信号
