extends Resource
class_name Room
#房间类型
enum Type {NOT_ASSIGNED, MONSTER, TREASURE, CAMPFIRE, SHOP, BOSS, EVENT}

@export var type: Type #导出一个枚举 房间类型
@export var row: int    #位置
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]   #接下来的房间
@export var selected := false     #已选标记
## This is only used by the MONSTER and BOSS types
@export var battle_stats: BattleStats
## This is only used by the EVENT room type
#@export var event_scene: PackedScene

#打印出字典中 房间的首字母
func _to_string() -> String:
	return "%s (%s)" % [column, Type.keys()[type][0]]
