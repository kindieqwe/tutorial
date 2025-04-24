extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var timer: Timer = $Timer


func _ready() -> void:
	Events.player_hit.connect(_on_player_hit)    #连接受伤信号响应函数
	timer.timeout.connect(_on_timer_timeout)     #连接计时器超时信号 计时器结束计时？
	

func _on_player_hit() -> void:
	color_rect.color.a = 0.2   #设置颜色矩形的透明度为 0.2
	timer.start()         #启动计时器
	

func _on_timer_timeout() -> void:
	color_rect.color.a = 0.0   #设置颜色矩形的透明度为 0.0 变得不可见
