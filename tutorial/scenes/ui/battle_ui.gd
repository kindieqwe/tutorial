class_name BattleUI
extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var hand: Hand = $Hand as Hand
@onready var mana_ui: ManaUI = $ManaUI as ManaUI
@onready var end_turn_button: Button = $EndTurnButton

@onready var draw_pile_view: CardPileView = %DrawPileView
@onready var discard_pile_view: CardPileView = %DisardPileView
@onready var draw_pile_button: CardPileOpener = %DrawPileButton
@onready var discard_pile_button: CardPileOpener = %DiscardPileButton

func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_draw)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)  #按钮按下与函数连接
	#抽牌堆按钮按下时 调用 抽排堆视图显示 传入 标题 和 洗牌顺序
	draw_pile_button.pressed.connect(draw_pile_view.show_current_view.bind("Draw Pile", true))
	discard_pile_button.pressed.connect(discard_pile_view.show_current_view.bind("Discard Pile"))
	
#初始化牌堆UI	
func initialize_card_pile_ui() -> void:
	draw_pile_button.card_pile = char_stats.draw_pile
	draw_pile_view.card_pile = char_stats.draw_pile
	discard_pile_button.card_pile = char_stats.discard
	discard_pile_view.card_pile = char_stats.discard
	
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
