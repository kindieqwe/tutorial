extends Node2D

@export var char_stats: CharacterStats  

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var end_turn_button: Button = $BattleUI/EndTurnButton
@onready var player: Player = $Player


func _ready() -> void:
	#Events.player_hand_drawn.connect(_on_player_hand_draw)
	#end_turn_button.pressed.connect(_on_end_turn_button_pressed)  #按钮按下与函数连接
	
	var new_stats: CharacterStats = char_stats.creat_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(player_handler.start_turn)
	
	start_battle(new_stats)
	
	
func start_battle(stats: CharacterStats) -> void:
	player_handler.start_battle(stats)
	
