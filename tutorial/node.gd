extends Node


var number: int : set = number_changed


func number_changed(value: int) -> void:
	number = value
	if number < 0:
		number -= 1  # 自动修正负值为0

	print_debug("Number is now:", number)
	

func _ready() -> void:
	number = -2
