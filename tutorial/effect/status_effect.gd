class_name StatusEffect
extends  Effect

var status: Status

#覆盖父类虚函数
func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.status_handler.add_status(status.duplicate())
