class_name Run
extends Node

#预加载所有的场景
const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
const BATTLE_REWARD_SCENE := preload("res://scenes/battle_reward/battle_reward.tscn")
const CAMPFIRE_SCENE := preload("res://scenes/campfire/campfire.tscn")
const SHOP_SCENE := preload("res://scenes/shop/shop.tscn")
const TREASURE_SCENE = preload("res://scenes/treasure/treasure.tscn")
const MAP_SCENE := preload("res://scenes/map/map.tscn")
const MAIN_MENU_PATH := "res://scenes/ui/main_menu.tscn"

@export var run_startup: RunStartup

#加载所有的按钮变量引用 实现在按钮被按下时 进行一些响应
@onready var current_view: Node = $CurrentView
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView


@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var treasure_button: Button = %TreasureButton
@onready var rewards_button: Button = %RewardButton
@onready var campfire_button: Button = %CampfireButton

var character: CharacterStats

#首先检查run_startup是否存在，如果不存在就直接返回。
#然后使用match语句根据run_startup.type的值来决定执行新游戏还是继续之前的游戏
func _ready() -> void:
	if not run_startup:
		return
		
	match run_startup.type:
		RunStartup.Type.NEW_RUN:  #新游戏就创建一个新的实例
			character = run_startup.picked_character.creat_instance()
			_start_run()  #调用_start_run()初始化游戏
		RunStartup.Type.CONTINUED_RUN:
			print("T0D0: load previous Run")	
			
				
func _start_run() -> void:
	_setup_event_connections()
	_setup_top_bar()
	print("T0D0: procedurally generate map")
	#deck_view.show()
	
#scence： 预加载的场景  
func _change_view(scene: PackedScene) -> void:
	#检查当前视图是否有节点，有就把那个节点删除  用其他的视图场景代替 实现场景的切换
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		
	get_tree().paused = false   #取消游戏暂停
	var new_view := scene.instantiate() #实例化场景 并添加到当前场景的子节点中
	current_view.add_child(new_view)

#事件连接函数，确保可以在不同的视图之间切换
func _setup_event_connections() -> void:
	Events.battle_won.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	Events.battle_reward_exited.connect(_change_view.bind(MAP_SCENE))
	Events.campfire_exited.connect(_change_view.bind(MAP_SCENE))
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_change_view.bind(MAP_SCENE))
	Events.treasure_room_exited.connect(_change_view.bind(MAP_SCENE))

	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	#map_button.pressed.connect(_show_map)
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))


func _setup_top_bar():
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))
	
	
func _on_map_exited() -> void:
	print("T0D0: from the MAP, change the view based on room type")
	
