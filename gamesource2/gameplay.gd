extends Node

#@export var cardList:Array
#@export var aa:int

static var NEWBIE_CARD_NUM=15 # 牌堆初始数量
static var NEWBIE_POINT=1 # 默认消耗点数
static var NEWBIE_CARD_HP = 10
static var NEWBIE_CARD_ATTACK = 2
static var NEWBIE_CARD_DEFEND = 1
static var NEWBIE_CARD_FATAL = 0.8 # 命中率 0-1，只影响攻击

static var PLAYER_BASE_PROP = [20,5,0] # HP,attack,defend
static var ENEMY_BASE_PROP = [10,4,0] #

static var DECK_CARD_NUM = 5 #牌桌卡牌数量
static var BASE_POINT = 5 

var cardList:Array=[] # [idx][idx]={attack,defend,fatal,point}
var cardsOnDeck:Array=[] #[idx]=card
var cardsOffDeck:Array=[]
var crntPoint:=0
var playerUnit:Array=[]
var enemyUnit:Array=[]
var crntLevel:=1

func init_units():
	playerUnit = PLAYER_BASE_PROP.duplicate()
	enemyUnit = ENEMY_BASE_PROP.duplicate()
	
func init_newbie_cards():
	cardList = []
	cardsOffDeck = []
	cardsOnDeck = []
	for i in range(NEWBIE_CARD_NUM):
		var bAddAttack = randf() < 0.6 # 添加攻击的概率高点
		var bAddOther = randf() < 0.2 # 一定概率也添加防御
		if bAddAttack:
			var attack = NEWBIE_CARD_ATTACK + randi_range(0,2)
			var defend = randi_range(1,2) if bAddOther else 0
			var fatal = NEWBIE_CARD_FATAL + randf_range(-0.1,0.1)
			var point = NEWBIE_POINT*maxi(1,attack+defend-NEWBIE_CARD_ATTACK) + (1 if randf() < 0.3 else 0) # 0.3 概率需要消耗两点
			cardList.append([attack,defend,fatal,point])
		else:
			var attack = randi_range(1,2) if bAddOther else 0
			var defend = NEWBIE_CARD_DEFEND + randi_range(0,2)
			var fatal = NEWBIE_CARD_FATAL + randf_range(-0.1,0.1)
			var point = NEWBIE_POINT*maxi(1,attack+defend-NEWBIE_CARD_DEFEND) + (1 if randf() < 0.3 else 0) # 0.3 概率需要消耗两点
			cardList.append([attack,defend,fatal,point])
			
		
func draw_cards():
	# TODO 无卡可用的处理
	for card in cardsOnDeck:
		cardsOffDeck.append(card)
	if cardList.size() < DECK_CARD_NUM:
		for card in cardsOffDeck:
			cardList.append(card)
		cardsOffDeck = []
	cardsOnDeck = []
	cardList.shuffle()
	for i in range(DECK_CARD_NUM):
		var card = cardList.pop_back()
		cardsOnDeck.append(card)
	prints("draw_cards",cardsOffDeck,cardsOffDeck,cardList)
func show_cards():
	print("show_cards")
	var page = %FightPage as FightPage
	page.cardNum = cardList.size()
	page.point = crntPoint
	for i in range(DECK_CARD_NUM):
		var desc = gen_card_desc(i)
		page.set_card(i,i,desc)
func gen_card_desc(index):
	var card = cardsOnDeck[index]
	if not card:
		return ""
	#{1:attack,2:defend,3:fatal,4:point}
	var ret = r"Cost：%s
	Att：%s
	Def：%s
	Fatal:%.2f" % [card[3],card[0],card[1],card[2]]
	return ret
func show_units():
	var punit = %PlayerArea as Unit
	var eunit = %EnemyArea as Unit
	#HP,attack,defend
	punit.hp = playerUnit[0]
	punit.attack = playerUnit[1]
	punit.defend = playerUnit[2]
	eunit.hp = enemyUnit[0]
	eunit.attack = enemyUnit[1]
	eunit.defend = enemyUnit[2]
	
func _on_apply_card(args):
	var bwin = false
	var card = cardsOnDeck[args.id]
	if crntPoint < card[3]: # 资源点不够
		args.wnd.disabled = false
		return
	crntPoint -= card[3]
	# {attack,defend,fatal,point}
	# 玩家给自己添加护盾
	if card[1] > 0:
		playerUnit[2] += card[1]
	#HP,attack,defend
	# 玩家攻击怪物
	if card[0] > 0 and randf() < card[2]:
		var remain = card[0]
		if enemyUnit[2] > remain:
			enemyUnit[2]-=remain
		else:
			remain -= enemyUnit[2]
			enemyUnit[2]=0
			enemyUnit[0] -= remain
			if enemyUnit[0] <= 0:
				enemyUnit[0] = 0
				bwin = true
	show_units()
	var page = %FightPage as FightPage
	page.point = crntPoint
	if bwin:
		game_win()
func _on_end_turn(args):
	var bfail = false
	# {attack,defend,fatal,point}
	#HP,attack,defend
	if enemyUnit[1] > 0 : # TODO 怪物没有命中率
		var remain = enemyUnit[1]
		if playerUnit[2] > remain:
			playerUnit[2]-=remain
		else:
			remain -= playerUnit[2]
			playerUnit[2]=0
			playerUnit[0] -= remain
			if playerUnit[0] <= 0:
				playerUnit[0] = 0
				bfail = true
	show_units()
	if bfail:
		game_fail()
	else:
		agenda_next_turn()
func restart():
	init_units()
	init_newbie_cards()
	draw_cards() # 抽卡
	crntPoint = BASE_POINT
	show_cards()
	show_units()
# Called when the node enters the scene tree for the first time.
func _ready():
	PubSub.sub(PubSub.Key.ApplyCard,_on_apply_card)
	PubSub.sub(PubSub.Key.EndTurn,_on_end_turn)
	restart()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func agenda_fight():	
	pass
func agenda_next_turn():
	draw_cards()	
	crntPoint = BASE_POINT
	show_cards()
	show_units()
func game_fail():
	print("game_fail")
func game_win():
	print("game_win")
	
