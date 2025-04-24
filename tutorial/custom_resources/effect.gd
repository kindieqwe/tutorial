class_name Effect
extends RefCounted

var sound: AudioStream

#其他的效果子类型都会继承这个方法并复写这个方法：如 attack block
func execute(_targets: Array[Node]) -> void:
	pass
