class_name Enemy
extends Area2D

const ARROW_OFFSET := 5   #设置箭头与不同体型敌人的偏移量
const WHITE_SPRITE_MATERIAL = preload("res://art/white_sprite_material.tres")
@export var stats: EnemyStats : set = set_enemy_stats  #在检查器界面为敌人设置一个初始状态

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var stats_ui: StatsUI = $StatsUI
@onready var intent_ui: IntentUI = $IntentUI
@onready var status_handler: StatusHandler = $StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler

var enemy_action_picker: EnemyActionPicker
var current_action: EnemyAction : set = set_current_action


func _ready() -> void:
	#await  get_tree().create_timer(2).timeout   #创建一个两秒的计时器
	#take_damage(6)
	#stats.block += 8
	pass
	
	
func set_current_action(value: EnemyAction) -> void:  #value 为外部current_value所赋的值
	current_action = value
	update_intent()

	
#更新敌人的状态
func update_stats() -> void:
	stats_ui.update_stats(stats)
	
func set_enemy_stats(value: EnemyStats) -> void:
	#print(value.max_health)
	stats = value.create_instance()   #创建一个新的实例，实例的值为设定的导出变量

	#print(stats.max_health)
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		stats.stats_changed.connect(update_action)
		
	update_enemy()


func setup_ai() -> void:
	if enemy_action_picker:   #self.enemy_action_picker? 检查是否存在enemy_action_picker
		enemy_action_picker.queque_free()
	
	var new_action_picker: EnemyActionPicker = stats.ai.instantiate()
	add_child(new_action_picker)
	enemy_action_picker = new_action_picker
	enemy_action_picker.enemy = self
		
func update_action() -> void:
	if not enemy_action_picker:
		return
		
	if not current_action:  #如果当前没有行为，则安排一个行为
		#get_action() 会根据情况选择一个条件行为 或者 常规行为
		current_action = enemy_action_picker.get_action()
		return
		
	var new_conditional_action := enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action
		
func update_enemy() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.art
	arrow.position = Vector2.RIGHT * (sprite_2d.get_rect().size.x / 2 + ARROW_OFFSET)
	setup_ai()
	update_stats()


func update_intent() -> void:
	if current_action:
		current_action.update_intent_text()
		intent_ui.update_intent(current_action.intent)
		
		
func do_turn() -> void:
	stats.block = 0
	
	if not current_action:
		return
		
	current_action.perform_action()
	
#敌人收到伤害
func take_damage(damage: int, which_modifier: Modifier.Type) -> void:
	if stats.health <= 0:    #检查玩家角色是否已经死亡
		return
		
	sprite_2d.material = WHITE_SPRITE_MATERIAL  #在启动渐变动画之前，设置敌人材质为白色精灵材质，动画完成时改回
	var modified_damage := modifier_handler.get_modified_value(damage, which_modifier)
	
	var tween := create_tween()
	#在指定的持续时间（duration）内，定期调用指定的回调函数（callback）
	#绑定到当前实例（self）的回调函数，调用Shaker类的shake方法，并传递参数16和0.15  bind:绑定
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage))  #调用stats的take_damage 传入damage的值
	tween.tween_interval(0.17)    #设置0.17秒间隔
	#动画完成后 检查敌人是否死亡
	tween.finished.connect(
		func():
			sprite_2d.material = null  #设置精灵材质为空 ， 精灵变回原本样子
			
			if stats.health <= 0:  
				Events.enemy_died.emit(self)
				queue_free()     #把敌人放入待释放队列，并在下一帧释放内存
	)
	
	
#箭头碰撞体进入敌人碰撞体时时，显示箭头
func _on_area_entered(_area: Area2D) -> void:
	#arrow.visible = true
	arrow.show()
	
#箭头碰撞体离开敌人碰撞体时时，隐藏箭头
func _on_area_exited(_area: Area2D) -> void:
	#arrow.visible = false
	arrow.hide()
	
