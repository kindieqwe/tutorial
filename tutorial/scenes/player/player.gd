class_name Player
extends Node2D

@export var stats: CharacterStats : set = set_character_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI


func _ready() -> void:
	
	#await  get_tree().create_timer(4).timeout   #创建一个两秒的计时器
	#take_damage(21)     #受到21点伤害
	#stats.block += 17   #护盾值增加17
	pass

func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)   #信号连接，由于状态会改变多次，故只连接一次就可以
		
	update_player()
	

func update_player() -> void:
	if not stats is CharacterStats:
		return
	if not is_inside_tree():    #检查是否在树中，否则等待ready信号
		await ready
		
	sprite_2d.texture = stats.art 
	update_stats()
	
func update_stats() -> void:
	stats_ui.update_stats(stats)
		
#玩家收到伤害
func take_damage(damage: int) -> void:
	if stats.health <= 0:    #检查玩家角色是否已经死亡
		return
	
	stats.take_damage(damage)
	
	if stats.health <= 0:
		Events.player_died.emit()
		queue_free()   #删除？
		
	
