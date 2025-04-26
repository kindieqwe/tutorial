extends Control

#退出按钮按下时 发出地图退出信号
func _on_button_pressed() -> void:
	Events.map_exited.emit()
