extends Control
#预加载三个角色的资源
const RUN_SCENE := preload("res://scenes/run/run.tscn")   #启动资源，加载存档？
const ASSASSIN_STATS := preload("res://characters/assassin/assassin.tres")
const WARRIOR_STATS := preload("res://characters/warrior/warrior.tres")
const WIZARD_STATS := preload("res://characters/wizard/wizard.tres")

@export var run_startup: RunStartup  #导出run_startup 变量 以确保其他场景可以访问这个变量

#设置成员变量 按下不同按钮时实现 这些成员变量做出相应的变化
@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var character_portrait: TextureRect = $CharacterPortrait

#设置一个自带更新功能的变量 更新当前的角色
var current_character: CharacterStats : set = set_current_character


func _ready() -> void:
	set_current_character(WARRIOR_STATS)   #设置当前角色为 （战士）
	
#传入新角色  并把当前角色的属性改为这个新角色的
func set_current_character(new_character: CharacterStats) -> void:
	current_character = new_character
	title.text = current_character.character_name
	description.text = current_character.description
	character_portrait.texture = current_character.portrait
	
	
func _on_start_button_pressed() -> void:
	print("Start new Run with %s" % current_character.character_name)
	
	run_startup.type = RunStartup.Type.NEW_RUN    #表示新游戏的启动类型
	run_startup.picked_character = current_character  #将当前选择的角色传递给启动配置 
	get_tree().change_scene_to_packed(RUN_SCENE)  #切换到运行场景
	
#战士按钮被按下 设置当前角色为战士 下面都是一样
func _on_warrior_button_pressed() -> void:
	current_character = WARRIOR_STATS


func _on_wizard_button_pressed() -> void:
	current_character = WIZARD_STATS


func _on_assassin_button_pressed() -> void:
	current_character = ASSASSIN_STATS
