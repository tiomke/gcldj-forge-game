# 按时序安排事件发展
class_name schedule

#[[0.5,callback],[0.6,callback]]
func Tw(callback):
	var tweener = Tween.new()
	tweener.tween_callback(callback).set_delay(0.5)



