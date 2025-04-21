class_name  Tooltip
extends PanelContainer

@export var fade_seconds := 0.2  #用于制定淡入淡出的时间

@onready var tooltip_icon: TextureRect = %TooltipIcon
@onready var tooltip_text_label: RichTextLabel = %TooltipText

var tween: Tween  #Tween 是 Godot 中用于创建平滑动画的节点，可控制属性（如位置、透明度、缩放）的渐变过渡
var is_visable := false

func _ready() -> void:
	Events.card_tooltip_requested.connect(show_tooltip)
	Events.tooltip_hide_requested.connect(hide_tooltip)
	modulate = Color.TRANSPARENT
	hide()
	
	
func show_tooltip(icon: Texture, text: String) -> void:
	is_visable = true
	if tween:
		tween.kill()
		
	tooltip_icon.texture = icon
	tooltip_text_label.text = text
	#创建tween动画
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	#从透明“modulate" 渐变时间 fade_seconds 渐变到 白色
	tween.tween_property(self, "modulate", Color.WHITE, fade_seconds) 
	
	
func hide_tooltip() -> void:
	is_visable = false   #
	if tween:
		tween.kill()
	#计时器，0.2秒后连接hide_animate()  若在0.2秒之前 则不会播放淡出动画
	get_tree().create_timer(fade_seconds, false).timeout.connect(hide_animation)
	
	#hide_animation()
	
	
func hide_animation() -> void:
	if not is_visable:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
		tween.tween_callback(hide)
	
	
