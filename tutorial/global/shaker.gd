extends Node

# thing: 摇晃的对象 strength：摇晃的强度 duration: 摇晃持续的时间
func shake(thing: Node2D, strength: float, duration: float = 0.2) -> void:
	if not thing:
		return
		
	var orig_pos := thing.position   #摇晃的位置
	var shake_count := 10			#摇晃的次数
	var tween := create_tween()  #创建一个渐变动画
	
	for i in shake_count:
		var shake_offset := Vector2(randf_range(-1.0,1.0), randf_range(-1.0,1.0)) #设置二维偏移量
		var target := orig_pos + strength * shake_offset
		if i % 2 == 0:       #每个偶数摇晃时，把目标的位置归回到原位
			target = orig_pos
		#每次循环将thing位置渐变到 target位置上，动画时间为duration/次数 = 0.02秒
		tween.tween_property(thing, "position", target, duration / float(shake_count))
		strength *= 0.75  #每次摇晃的强度 = 上一次的3/4
	#摇晃动画播放完之后，链接匿名函数 ，thing对象设置为	 原始位置
	tween.finished.connect(func(): thing.position = orig_pos)  
