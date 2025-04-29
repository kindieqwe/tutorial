class_name RunStats
extends Resource

signal gold_changed  #金币改变的信号

const STARTING_GOLD := 70  #初始金币
const BASE_CARD_REWARDS := 3  #基础卡牌奖励

const BASE_COMMON_WEIGHT := 6.0  #普通卡牌权重
const BASE_UNCOMMON_WEIGHT := 3.7  #不普通卡牌的权重
const BASE_RARE_WEIGHT := 0.3    #稀有卡牌的权重

@export var gold := STARTING_GOLD : set = set_gold   #导出金币变量 并设置发生改变时自动响应函数
#对应上面的常量
@export var card_rewards := BASE_CARD_REWARDS 
@export_range(0.0, 10.0) var common_weight := BASE_COMMON_WEIGHT
@export_range(0.0, 10.0) var uncommon_weight := BASE_UNCOMMON_WEIGHT
@export_range(0.0, 10.0) var rare_weight := BASE_RARE_WEIGHT

#外部对glod做出修改时 自动发出 ui界面进而做出修改
func set_gold(new_amount: int) -> void:
	gold = new_amount
	gold_changed.emit()  #发出金币改变信号 
	

func reset_weights() -> void:
	common_weight = BASE_COMMON_WEIGHT
	uncommon_weight = BASE_UNCOMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT
