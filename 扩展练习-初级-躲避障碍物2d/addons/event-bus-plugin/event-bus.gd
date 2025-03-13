extends Node

## 所有的监听事件
var _listeners: Dictionary[String, Array] = {}

## 绑定事件
func on(event_name: String, listener: Callable):
	if not _listeners.has(event_name):
		_listeners[event_name] = []
	_listeners[event_name].append(listener)
	print("The event has been bound. event: %s, listener: %s" % [event_name, listener.get_method()])

## 解除事件绑定
func off(event_name: String, listener: Callable):
	if not _listeners.has(event_name):
		return
	_listeners[event_name].erase(listener)
	if _listeners[event_name].is_empty():
		_listeners.erase(event_name)
	print("The event has been unbound. event: %s, listener: %s" % [event_name, listener.get_method()])

## 发送事件 传递参数
## args是传递给监听事件的参数数组
func emitv(event_name: String, arg):
	if not _listeners.has(event_name):
		print("The sent event does not exist. event: %s" % [event_name])
		return
	for listener in _listeners[event_name]:
		var c = listener as Callable
		var arg_count = c.get_argument_count()
		if arg != null and arg_count == 1:
			c.call(arg)
		elif arg != null and arg_count != 1:
			c.call()
			push_warning("There are extra parameters in the sent event. event: %s" % [event_name])
		elif arg == null and arg_count == 1:
			push_error("There are some parameters missing in the sent event. event: %s" % [event_name])
		else:
			c.call()

## 发送事件 不传递参数
func emit(event_name: String):
	self.emitv(event_name, null)
