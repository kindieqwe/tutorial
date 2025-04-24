extends Card

#@export var optional_sound: AudioStream


func apply_effects(targets: Array[Node]) -> void:
	#根据自己的逻辑做任何想做的事
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 4
	damage_effect.sound = sound
	damage_effect.execute(targets)
