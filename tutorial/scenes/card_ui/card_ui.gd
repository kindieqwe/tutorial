class_name CardUI
extends Control

#信号，拖拽卡片时，重新父化卡牌，不然拖不出来
signal reparent_requested(which_card_ui: CardUI)

const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/card_ui/card_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")

@export var card: Card : set = _set_card

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
#节点数组，用于存储当前卡牌的所有目标 进入释放区域或手牌区域， 在目标列表中添加释放区域or手牌区域  真的有手牌区域吗？
@onready var targets: Array[Node] = []

var parent : Control
var tween : Tween


func _ready() -> void:
	card_state_machine.init(self)
	
	
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
#duration: 持续时间  new_position:动画的新位置
func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"global_position", new_position, duration)
	

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)


func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	

func _set_card(value: Card) -> void:
	if not is_node_ready():    #检查节点是否准备就绪，就绪才能更改法力和文本
		await  ready
		
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
	
#卡片进入悬停区域时需要进行哪些操作
func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	#检查当前区域是否被目标列表包含,没有就加到目标列表中
	if not targets.has(area):
		targets.append(area)
		
		
#如果从当前区域退出去时，就将当前区域 从 目标列表中删除
func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
	
