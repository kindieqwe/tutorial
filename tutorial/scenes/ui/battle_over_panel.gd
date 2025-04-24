class_name BattleOverPanel
extends Panel

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continue_button: Button = %ContinueButton
@onready var restart_button: Button = %RestartButton


func _ready() -> void:
	# 场景树的 quit 方法，调用后会关闭 Godot 引擎，结束游戏进程
	continue_button.pressed.connect(get_tree().quit)   
	restart_button.pressed.connect(get_tree().reload_current_scene)  #重启按钮连接到 重新加载当前场景
	Events.battle_over_screen_requested.connect(show_screen)
	
#在别的地方实现这个函数 text：文本 type：输赢类型	
func show_screen(text: String, type: Type) -> void:
	label.text = text
	continue_button.visible = type == Type.WIN
	restart_button.visible = type == Type.LOSE
	show()
	#get_tree()返回场景树的根节点  即 “Battle” 节点
	get_tree().paused = true  #设置场景树的 暂停属性  为 true  :实现游戏暂停  #后续需要开启
	print(get_tree())
