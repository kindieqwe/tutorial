class_name CardUI
extends Control

#信号，拖拽卡片时，重新父化卡牌，不然拖不出来
signal reparent_requested(which_card_ui: CardUI)

const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/card_ui/card_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")

@export var card: Card : set = _set_card
@export var char_stats: CharacterStats : set = _set_char_stats

#@onready var panel: Panel = $Panel
#@onready var cost: Label = $Cost
#@onready var icon: TextureRect = $Icon
@onready var card_visuals: CardVisuals = $CardVisuals

@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
#节点数组，用于存储当前卡牌的所有目标 进入释放区域或手牌区域， 在目标列表中添加释放区域or手牌区域  真的有手牌区域吗？
@onready var targets: Array[Node] = []

var original_index := self.get_index()   #获得手牌的索引

var parent : Control
var tween : Tween
var playable := true : set = _set_playable   #判断是否可以打出卡牌
var disable := false


func _ready() -> void:
	card_state_machine.init(self)
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
#duration: 持续时间  new_position:动画的新位置
func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"global_position", new_position, duration)
	

func play() -> void:
	if not card:
		return
	card.play(targets, char_stats)
	queue_free()
	
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
	#cost.text = str(card.cost)
	#icon.texture = card.icon
	card_visuals.card = card
#用于设置卡牌是否能被打出
func _set_playable(value: bool) -> void:
	playable = value
	if not playable:    #不能打出为cost标签添加红色标识， 并且icon透明 （卡片图标）
		card_visuals.cost.add_theme_color_override("font_color", Color.RED)
		card_visuals.icon.modulate = Color(1, 1, 1, 0.5)
	else:   #可以打出就移除cost标签的主题
		card_visuals.cost.remove_theme_color_override("font_color")
		card_visuals.icon.modulate = Color(1, 1, 1, 1)


func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)
	
	
#卡片进入悬停区域时需要进行哪些操作
func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	#检查当前区域是否被目标列表包含,没有就加到目标列表中
	if not targets.has(area):
		targets.append(area)
		
		
#如果从当前区域退出去时，就将当前区域 从 目标列表中删除
func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
	
	
func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	disable = true
	
	
func _on_card_drag_or_aim_ended(_card: CardUI) -> void:
	disable = false
	self.playable = char_stats.can_play_card(card)
	
	
#func _on_char_stats_changed(used_card: CardUI) -> void:
	#self.playable = char_stats.can_play_card(card)
func _on_char_stats_changed() -> void:
	self.playable = char_stats.can_play_card(card)
