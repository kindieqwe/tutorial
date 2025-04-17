extends Area2D

signal hit

var health := 1

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var is_death := 0
func _ready():
	
	screen_size = get_viewport_rect().size
	#在游戏开始时隐藏玩家
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if health == 1:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
	if health == 0:
		pass

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#$ 是 get_node() 的简写。因此在上面的代码中，$AnimatedSprite2D.play() 
		#与 get_node("AnimatedSprite2D").play() 相同
		$AnimatedSprite2D.play() 
	else:
		if health == 1:
			$AnimatedSprite2D.stop()
		if health == 0:
			$AnimatedSprite2D.play()
	#现在我们有了一个运动方向，我们可以更新玩家的位置了。我们也可以使用 clamp() 来防止它离开屏幕。
	#clamp 一个值意味着将其限制在给定范围内。将以下内容添加到 _process 函数的底部：
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#我们的“walk”动画显示的是玩家向右走。向左移动时就应该使用 flip_h 属性将这个动画进行水平翻转。
	#我们还有向上的“up”动画，向下移动时就应该使用 flip_v 将其进行垂直翻转
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0  #一个逻辑值
	
	if health == 0:
		$AnimatedSprite2D.animation = "death"
		await  $AnimatedSprite2D.animation_finished
		hide()
		
	
func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	
	#hide() # Player disappears after being hit.
	hit.emit()  #确保一次性只有一次碰撞
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	health -= 1 
	
	print(health)
	

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	if health == 0:
		health += 1
	print(health)
	
