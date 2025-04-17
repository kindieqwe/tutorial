extends CharacterBody2D



enum State {IDLE,RUNNING,JUMP,FALL,LANDING
 }


#固定 奔跑的速度和跳跃速度
const GROUND_STATES :=[State.IDLE,State.RUNNING]
const RUN_SPEED  :=160.0
const JUMP_VELOCITY :=-300.0
const FLOOR_ACCELERATION :=RUN_SPEED/0.2
const AIR_ACCELERATION :=RUN_SPEED/0.02
#鼠标左键拖进脚本，并按ctrl健
#创建动画，sprite2d 两个变量，后续与用户输入进行交互ddddd
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_request_timer: Timer = $JumpRequestTimer


#设置重力加速度，从自带方法中获取
var is_first_tick := false
var default_gravity := ProjectSettings.get("physics/2d/default_gravity")as float


func _unhandled_input(event: InputEvent)-> void:
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	
		
#设置方法控制物理过程
#delta：时间
#gravity ： 重力加速度
func tick_physics(state: State ,delta: float)-> void:
	match state:
		State .IDLE :
			move(default_gravity,delta)
		State.RUNNING:
			move(default_gravity,delta)
		State.JUMP :
			move(0.0 if is_first_tick else default_gravity,delta)
		State.FALL:
			move(default_gravity,delta)
		State.LANDING:
			#move(default_gravity,delta)
			stand(delta)
	is_first_tick = false		
func stand(delta:float)-> void:
	var acceleration :=FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += default_gravity * delta
	move_and_slide()

			
func move(gravity : float ,delta: float) -> void:
	#根据用户输入判断方向
	var direction := Input.get_axis("move_left","move_right")
	
	#设置竖直方向速度变化 ，“+=”： 初始值一直跌加 等号后面的值
	velocity.y += gravity * delta
	#velocity.x  =direction * RUN_SPEED
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x= move_toward(velocity.x, direction * RUN_SPEED, acceleration * delta)
	
	#判断人物是否执行跳跃操作，或地板
	#var can_jump := is_on_floor() or coyote_timer.time_left >0
	#var should_jump := can_jump and jump_request_timer.time_left > 0 
	#if should_jump:
		#velocity.y = JUMP_VELOCITY
		#coyote_timer.stop()
		#jump_request_timer.stop()
		#
	#if is_on_floor():
		##if用户方向操作为零 并且 水平方向速度为零
		#if is_zero_approx(direction) and is_zero_approx(velocity.x):
			##执行站立动画
			#animation_player.play("idle")
		#else:
			#animation_player.play("running")
	#elif velocity.y < 0: 
		#animation_player.play("jump")
	#else  :
		#animation_player.play("fall")
		
	if not is_zero_approx(direction):
		#动画翻转与否，避免太空步，当方向值为负数（向左移动）时，设置flip_h为True（人物水平翻转）
		sprite_2d.flip_h = direction < 0

	# 实现角色的平滑移动和跳跃
	
	#var was_on_floor :=is_on_floor()
	move_and_slide()
	#设置郊狼时间计时器，不在地面上时并且不是跳跃过程中启动,如果当前是否在地面的状态与上一帧的状态不同，则进入判断逻辑
	#if is_on_floor() != was_on_floor:
		#if was_on_floor and not should_jump:
			#coyote_timer.start()
		#else:
			#coyote_timer.stop()
			
func get_next_state(state: State)-> State:
	var can_jump :=is_on_floor() or coyote_timer.time_left > 0
	var should_jump := can_jump and jump_request_timer.time_left > 0
	if should_jump : 
		return State.JUMP
		
	var direction :=Input.get_axis("move_left","move_right")
	var is_still :=is_zero_approx(direction)and is_zero_approx(velocity.x)

	match state:
		State.IDLE:
			if not is_on_floor():
				return State.FALL
			if not is_still:
				return State.RUNNING
		State.RUNNING:
			if not is_on_floor():
				return State.FALL
			if is_still:
				return State.IDLE
		State.JUMP:
			if velocity.y >= 0:
				return State.FALL
		State.FALL:
			if is_on_floor():
				#return State.IDLE if is_still else State.RUNNING
				return State.LANDING if is_still else State.RUNNING
		State.LANDING:
			if not animation_player.is_playing():
				return State.IDLE
			
	return state
	
	
func transition_state(from: State,to: State) -> void:
	if from not in GROUND_STATES and to in GROUND_STATES:
		coyote_timer.stop()
	match to:
		State.IDLE:
			animation_player.play("idle")
		State.RUNNING:
			animation_player.play("running")
		State.JUMP:
			animation_player .play("jump")
			velocity.y = JUMP_VELOCITY
			coyote_timer.stop()
			jump_request_timer.stop()
		State.FALL:
			animation_player.play("fall")
			if from in GROUND_STATES: 
				coyote_timer.start()
		State.LANDING:
			animation_player.play("landing")
	is_first_tick = true

	
