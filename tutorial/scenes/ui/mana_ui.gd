class_name ManaUI
extends Panel

@export var char_stats: CharacterStats : set = _set_char_stats  #角色的属性

@onready var mana_label: Label = $ManaLabel   #mana_label :跟踪蓝量


#测试代码  
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	char_stats.mana = 3

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	
	if not char_stats.stats_changed.is_connected(_on_stats_changed):
		char_stats.stats_changed.connect(_on_stats_changed)
		
	if not is_node_ready():
		await ready
		
	_on_stats_changed()
		

func _on_stats_changed() -> void:
	mana_label.text = "%s/%s" % [char_stats.mana, char_stats.max_mana]  #设置 3/3 的标签显示
	
	
	
