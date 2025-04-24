# meta-name: Card Logic 
# meta-description: What happens when a card is played
extends Card

@export var optional_sound: AudioStream


func apply_effects(targets: Array[Node]) -> void:
	#根据自己的逻辑做任何想做的事
	print("My awesome card has been played")
	print("Targets: %s " % targets)
	
