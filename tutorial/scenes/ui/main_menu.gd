extends Control
#预加载角色选择界面，当按下开始新游戏的时候，跳转到角色选择界面
const CHARACTER_SELECTOR := preload("res://scenes/ui/character_selector.tscn")
const RUN_SCENE = preload("res://scenes/run/run.tscn")

@export var run_startup: RunStartup
@onready var continue_button: Button = %Continue


func _ready() -> void:
	get_tree().paused = false   #设置根节点的暂停属性 为 false （进入主菜单后不再暂停）
	continue_button.disabled = SaveGame.load_data() == null
	
	
#continue 按钮被按下后的响应函数
func _on_continue_pressed() -> void:
	run_startup.type = RunStartup.Type.CONTINUED_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)
	
	
#new run 按钮被按下后的响应函数
func _on_new_run_pressed() -> void:
	#跳转到角色选择界面，packed 是 PackedScene 资源，需提前通过 preload 或 load 加载
	get_tree().change_scene_to_packed(CHARACTER_SELECTOR)

#exit 按钮被按下后的响应函数
func _on_exit_pressed() -> void:
	get_tree().quit()  #退出根节点  即退出游戏
