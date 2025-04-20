class_name Enemy
extends Area2D

const ARROW_OFFSET := 5   #设置箭头与不同体型敌人的偏移量

@export var stats: EnemyStats : set = set_enemy_stats  #在检查器界面为敌人设置一个初始状态

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var stats_ui: StatsUI = $StatsUI


func _ready() -> void:
	#await  get_tree().create_timer(2).timeout   #创建一个两秒的计时器
	#take_damage(6)
	#stats.block += 8
	pass
#更新敌人的状态
func update_stats() -> void:
	stats_ui.update_stats(stats)
	
func set_enemy_stats(value: EnemyStats) -> void:
	print(value.max_health)
	stats = value.create_instance()   #创建一个新的实例，实例的值为设定的导出变量

	print(stats.max_health)
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		
	update_enemy()
		

func update_enemy() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.art
	arrow.position = Vector2.RIGHT * (sprite_2d.get_rect().size.x / 2 + ARROW_OFFSET)
	update_stats()
	
	
#敌人收到伤害
func take_damage(damage: int) -> void:
	if stats.health <= 0:    #检查玩家角色是否已经死亡
		return
	
	stats.take_damage(damage)
	
	if stats.health <= 0:
		queue_free()   #删除？
			
	

#箭头碰撞体进入敌人碰撞体时时，显示箭头
func _on_area_entered(_area: Area2D) -> void:
	#arrow.visible = true
	arrow.show()
	

#箭头碰撞体离开敌人碰撞体时时，隐藏箭头
func _on_area_exited(_area: Area2D) -> void:
	#arrow.visible = false
	arrow.hide()
	
