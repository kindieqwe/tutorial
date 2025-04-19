#用于绘制瞄准曲线
extends Node2D 

const ARC_POINTS := 8

#area_2d： 用于碰撞检测 
@onready var area_2d: Area2D = $Area2D
@onready var card_arc: Line2D = $CanvasLayer/CardArc

#targeting : 跟踪是否处于瞄准过程； current_UI ：？ 是干什么的？
var current_card: CardUI
var targeting = false

func _ready() -> void:
	#事件总线EventBus 连接到瞄准的两个函数  使这两个函数与状态机解耦
	Events.card_aim_ended.connect(_on_card_aim_ended)
	Events.card_aim_started.connect(_on_card_aim_started)
	
func _process(delta: float) -> void:
	#不是瞄准中 则直接返回，不用接下来的操作
	if not targeting:
		return
	
	area_2d.position = get_local_mouse_position()  #计算鼠标的位置
	card_arc.points = _get_points()				   #计算弧线的点数
	
	
func _get_points() -> Array:
	var points := []
	var start := current_card.global_position   #start 是一个二维的点，赋值卡牌的位置（UI的左上角）
	start.x += (current_card.size.x / 2)		#加上卡牌的一半宽度，使起点位于卡牌正中上点
	var target := get_local_mouse_position()    #target 终点， 赋值鼠标位置
	var distance := (target - start)
	
	for i in range(ARC_POINTS):
		var t := (1.0 / ARC_POINTS) * i
		var x := start.x + (distance.x / ARC_POINTS) * i
		var y := start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x,y))
		
	points.append(target)
	
	return points
	

func ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)
	
func _on_card_aim_started(card: CardUI) -> void:
	if not card.card.is_single_targeted():
		return
		
	targeting = true
	area_2d.monitorable = true
	area_2d.monitoring = true
	current_card = card

#使started中做的操作复原
func _on_card_aim_ended(card: CardUI) -> void:
	targeting = false
	card_arc.clear_points()   #清楚弧线的点
	area_2d.position = Vector2.ZERO
	area_2d.monitorable = false
	area_2d.monitoring = false
	current_card = null
	
#进入瞄准
func _on_area_2d_area_entered(area: Area2D) -> void:
	#如果没有卡牌或不是瞄准，返回
	if not current_card or not targeting:
		return
	#如果正在瞄准但目标区域中没有传递进来的敌人区域，则添加的目标区域
	if not current_card.targets.has(area):
		current_card.targets.append(area)
	
#离开瞄准
func _on_area_2d_area_exited(area: Area2D) -> void:
	if not current_card or not targeting:
		return
		
	current_card.targets.erase(area)   #离开后清除
	
	
	
	
