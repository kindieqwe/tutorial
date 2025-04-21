extends Node

#Card-related events
signal  card_drag_started(card_ui: CardUI)
signal  card_drag_ended(card_ui: CardUI)
signal  card_aim_started(card_ui: CardUI)
signal  card_aim_ended(card_ui: CardUI)
signal  card_player(card: Card)   #卡牌打出信号
signal card_tooltip_requested(card: Card) #卡牌提示框请求
signal tooltip_hide_requested()
