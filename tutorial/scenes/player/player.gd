class_name Player
extends Node2D

const WHITE_SPRITE_MATERIAL = preload("res://art/white_sprite_material.tres")
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
	
	sprite_2d.material = WHITE_SPRITE_MATERIAL  #设置玩家精灵材质为白色
	
	var tween := create_tween()
	#在指定的持续时间（duration）内，定期调用指定的回调函数（callback）
	#绑定到当前实例（self）的回调函数，调用Shaker类的shake方法，并传递参数16和0.15  bind:绑定
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))  #调用stats的take_damage 传入damage的值
	tween.tween_interval(0.17)    #0.2秒间隔
	#Events.player_hit.emit()      #发出角色受伤信号，响应 颜色矩形为红色
	#动画完成后 检查玩家是否死亡
	tween.finished.connect(
		func():
			sprite_2d.material = null  #设置玩家精灵材质为空
			if stats.health <= 0:  
				Events.player_died.emit()    #事件总线发出玩家死亡信号
				queue_free()     #把玩家放入待释放队列，并在下一帧释放内存
	)
	#stats.take_damage(damage)
	
	if stats.health <= 0:
		Events.player_died.emit()
		queue_free()   #删除？
		
	
