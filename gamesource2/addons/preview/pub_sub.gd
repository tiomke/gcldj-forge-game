# 中心化的消息订阅发布接口
class_name PubSub

enum Key {
	ApplyCard, # 应用卡牌
	EndTurn, # 结束玩家回合
}
# 中心化的消息管理对象
static var pub_sub_obj:Object = Object.new()

static var list=[{"name":"args","type":TYPE_DICTIONARY}]

# 监听某个事件
static func sub(eventName,callable):
	eventName = str(eventName)
	if !pub_sub_obj.has_user_signal(eventName):
		pub_sub_obj.add_user_signal(eventName,list)
	pub_sub_obj.connect(eventName,callable)
	
# 发布某个事件
static func pub(eventName,args:Dictionary={}):
	pub_sub_obj.emit_signal(str(eventName),args)
	
	

