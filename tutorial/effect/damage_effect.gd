class_name  DamageEffect
extends Effect

var amount := 0  #通过技能创建的防御数值


func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.take_damage(amount, Modifier.Type.DMG_TAKEN)        #受到伤害
			SFXPlayer.play(sound)
