extends Card


const TRUE_STRENGTH_FORM_STATUS = preload("res://statuses/true_strength_form.tres")

#_modifiers : 下划线表示“未使用”
func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	#根据自己的逻辑做任何想做的事
	var status_effect := StatusEffect.new()
	var true_strength := TRUE_STRENGTH_FORM_STATUS.duplicate()
	status_effect.status = true_strength
	status_effect.execute(targets)
	
	
