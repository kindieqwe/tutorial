class_name Battle
extends Node2D

@export var char_stats: CharacterStats  
@export var battle_stats: BattleStats  
@export var music: AudioStream

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var end_turn_button: Button = $BattleUI/EndTurnButton
@onready var player: Player = $Player
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var label: Label = $BattleUI/Label
@onready var hand: Hand = $BattleUI/Hand




func _ready() -> void:
	##Events.player_hand_drawn.connect(_on_player_hand_draw)
	##end_turn_button.pressed.connect(_on_end_turn_button_pressed)  #按钮按下与函数连接
	#每次都创建新实例 导致 血量不会继承
	#var new_stats: CharacterStats = char_stats.creat_instance()
	#battle_ui.char_stats = new_stats
	#player.stats = new_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	Events.player_turn_ended.connect(player_handler.end_turn)   #发出玩家回合结束信号
	Events.player_hand_discarded.connect(enemy_handler.start_turn) #发出敌人回合开始信号
	Events.player_died.connect(_on_player_died)
	
	#TODO initialize card pile and button stuff
	
func start_battle() -> void:
	get_tree().paused = false     
	MusicPlayer.play(music, true)   #播放音乐，并传递导出变量(music), 标志设置为 true（单一音轨）
	
	battle_ui.char_stats = char_stats
	player.stats = char_stats
	
	player_handler.start_battle(char_stats)
	
	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemy_actions()
	battle_ui.initialize_card_pile_ui()

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("Victory!", BattleOverPanel.Type.WIN)
		

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()
	

func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)
