extends Node

#Card-related events
signal  card_drag_started(card_ui: CardUI)
signal  card_drag_ended(card_ui: CardUI)
signal  card_aim_started(card_ui: CardUI)
signal  card_aim_ended(card_ui: CardUI)
signal  card_played(card: Card)   #卡牌打出信号
signal card_tooltip_requested(card: Card) #卡牌提示框请求
signal tooltip_hide_requested()

#player-related events
signal player_hand_drawn   #在回合开始时抽取卡牌触发
signal player_hand_discarded  #玩家弃牌时触发
signal player_turn_ended       #玩家结束回合时触发
signal player_hit      #玩家受到伤害时触发
signal player_died     #玩家死亡发出信号

#Enemy-related events
signal enemy_action_completed(enemy: Enemy)  #敌人的行动完成释放信号
signal enemy_turn_ended    #敌人结束回合时触发

#Battle-related events
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal battle_won  #战斗胜利信号

#Map-related events
signal map_exited  #退出地图信号

#商店相关事件
signal shop_exited #退出商店

#战斗奖励相关事件
signal battle_reward_exited

#Treasure Room-related events 宝箱房间事件
signal treasure_room_exited

#战斗奖励相关事件
signal campfire_exited
