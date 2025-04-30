class_name MapRoom
extends Area2D

signal selected(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.MONSTER: [preload("res://art/tile_0103.png"), Vector2.ONE],
	Room.Type.TREASURE: [preload("res://art/tile_0089.png"), Vector2.ONE],
	Room.Type.CAMPFIRE: [preload("res://art/player_heart.png"), Vector2(0.6, 0.6)],
	Room.Type.SHOP: [preload("res://art/gold.png"), Vector2(0.6, 0.6)],
	Room.Type.BOSS: [preload("res://art/tile_0105.png"), Vector2(1.25, 1.25)],
	#Room.Type.EVENT: [preload("res://art/rarity.png"), Vector2(0.9, 0.9)],
}
#三个引用变量
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available   #可用标志
var room: Room : set = set_room

#测试代码
#func _ready() -> void:
	#var test_room := Room.new() #实例化的是一个普通类对象（如自定义的Room类）
	#test_room.type = Room.Type.CAMPFIRE
	#test_room.position = Vector2(100, 100)
	#room = test_room
	#
	#await  get_tree().create_timer(3).timeout
	#available = true
	#

func set_available(new_value: bool) -> void:
	available = new_value
	
	if available:   #如果available 为true的话，播放高亮动画
		animation_player.play("highlight")
	elif not room.selected: #如果selected 为false的话，重置动画  
		animation_player.play("RESET")

#设置房间属性 
func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position #2D 地图房间节点的位置 设置为 我们房间资源中储存的位置
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]

#显示选中 设置线条的透明度为不透明的白色
func show_selected() -> void:
	line_2d.modulate = Color.WHITE

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return

	room.selected = true
	#clicked.emit(room)
	animation_player.play("select")	

#在动画界面播放的最后一帧 调用这个方法
func _on_map_room_selected() -> void:
	selected.emit(room)
