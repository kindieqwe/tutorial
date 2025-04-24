extends Node

#audio: 音频文件 single： 标志 默认不播放
func play(audio: AudioStream, single = false) -> void:
	if not audio:   #检查是否存在有效的音频文件
		return
		
	if single:   #如果single 是否为true 
		stop()   #停止所有音频播放
		
	for player in get_children():
		player = player as AudioStreamPlayer
		
		if not player.playing:  #如果播放器没有在播放
			player.stream = audio
			player.play()
			break
			
#停止所有播放器的播放
func stop() -> void:
	for player in get_children():
		player = player as AudioStreamPlayer
		player.stop()	
