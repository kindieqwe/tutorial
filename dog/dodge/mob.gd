extends RigidBody2D



func _ready():
	#从 AnimatedSprite2D 的 sprite_frames 属性中获取动画名称的列表。返回的是一个数组，
	#该数组包含三个动画名称：["walk", "swim", "fly"]
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())

	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()

	
#让怪物在超出屏幕时删除自己
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
