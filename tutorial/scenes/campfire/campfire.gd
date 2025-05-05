class_name Campfire
extends Control

@export var char_stats: CharacterStats  #连接到玩家的数据，恢复玩家血量

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rest_button: Button = %RestButton

#按钮响应， 按下时 实现“玩家血量恢复逻辑”
func _on_rest_button_pressed() -> void:
	rest_button.disabled = true #按下后，按钮消失，避免多次回复
	char_stats.heal(ceili(char_stats.max_health * 0.3))
	animation_player.play("fade_out") #播放淡出动画


# This is called from the AnimationPlayer
# at the end of 'fade-out'.
func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
