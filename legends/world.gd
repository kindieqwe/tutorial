extends Node2D

@export var bgm : AudioStream
@onready var tile_map: TileMap = $TileMap
@onready var camera_2d: Camera2D = $Player/Camera2D

@onready var bgm_player: AudioStreamPlayer2D = $BgmPlayer



#func play_bgm(stream :AudioStream) -> void:
	#bgm_player.stream = stream
	#bgm_player.play()

func _ready()-> void:
	#get_used_rect() 返回 TileMap 中实际使用的最小矩形区域
	var used := tile_map.get_used_rect().grow(-1)
	
	#将块单位转换为像素单位（tile_size）
	var tile_size := tile_map.tile_set.tile_size
	
	camera_2d.limit_top = used.position.y *tile_size.y
	camera_2d.limit_right = used.end.x*tile_size.x
	camera_2d.limit_bottom = used.end.y * tile_size.y
	camera_2d.limit_left = used.position.x * tile_size.x
	
	camera_2d.reset_smoothing()
	#play_bgm(bgm)
