class_name FSM extends RefCounted

var debugger: bool = false

var db: Dictionary[String, Variant]

var states: Dictionary[String, State]

var current_state_name: String

var current_state: State:
	get():
		return states.get(current_state_name)

## 状态使用的上下文
var _context: Context

func _init() -> void:
	self._context = Context.new(self)

func set_data(name: String, value: Variant):
	self.db.set(name, value)
	
func add_state(name: String, state: State):
	if states.has(name):
		push_warning("State repetition.")
		return
	state.context = _context
	states.set(name, state)

func add_states(obj: Dictionary[String, State]):
	for k in obj:
		add_state(k, obj[k])
	
func init_state(name: String):
	if not states.has(name):
		push_warning("The state does not exist.")
		return
	change_state(name)

func change_state(name: String):
	var enter = func(_name):
		if debugger:
			print("enter:{0}".format([_name]))
		var new = states.get(_name)
		current_state_name = _name
		new.enter()
	var exit = func(_name):
		if debugger:
			print("exit :{0}".format([_name]))
		var old = states.get(_name)
		old.exit()
	_change_state(current_state_name, name, enter, exit)

## 对比两个状态名称并有序退出和进入
func _change_state(old_name: String, new_name: String, enter_state_func: Callable, exit_state_func: Callable):
	var old_name_arr = old_name.split("/")
	var new_name_arr = new_name.split("/")
	var old_i = 0
	var new_i = 0
	while old_i < len(old_name_arr) and new_i < len(new_name_arr):
		if old_name_arr[old_i] != new_name_arr[new_i]:
			break
		old_i += 1
		new_i += 1
	# 同层
	if old_i == len(old_name_arr) - 1 and new_i == len(new_name_arr) - 1:
		var exit_state = old_name.trim_suffix("/")
		if exit_state:
			exit_state_func.call(exit_state)
		enter_state_func.call(new_name.trim_suffix("/"))
		return
	# 从旧状态退出
	var old_re_i = len(old_name_arr) - 1
	while old_i <= old_re_i:
		var _exit_state = ""
		var i = 0
		while i <= old_re_i:
			_exit_state += old_name_arr[i] + "/"
			i += 1
		var exit_state = _exit_state.trim_suffix("/")
		if exit_state:
			exit_state_func.call(exit_state)
		old_re_i -= 1
	# 进入新状态
	while new_i < len(new_name_arr):
		var _enter_state = ""
		var i = 0
		while i <= new_i:
			_enter_state += new_name_arr[i] + "/"
			i += 1
		enter_state_func.call(_enter_state.trim_suffix("/"))
		new_i += 1

func ui_update(delta: float):
	var state: State = states.get(current_state_name)
	while state:
		state.ui_update(delta)
		state = state.parent
	
func ui_input(event: InputEvent):
	var state: State = states.get(current_state_name)
	while state:
		state.ui_input(event)
		state = state.parent
	
	state = states.get(current_state_name)
	while state:
		if state.ui_unhandled_input(event):
			state = state.parent
		else:
			state = null

class Context extends RefCounted:
	var db: Dictionary[String, Variant]:
		get():
			return _fsm.db
	
	var _fsm: FSM
	
	func _init(fsm: FSM) -> void:
		_fsm = fsm
	
	func change_state(name: String):
		return _fsm.change_state(name)

class State extends RefCounted:
	var context: Context
	
	var parent: State
	
	func bind_parent(state: State) -> State:
		parent = state
		return self
	
	## 进入状态时调用
	func enter():
		pass
	
	## 每帧调用
	func ui_update(delta: float):
		pass
	
	## 退出状态时调用
	func exit():
		pass
	
	## 存在输入事件时调用
	func ui_input(event: InputEvent):
		pass
		
	## 存在未处理输入事件时调用
	func ui_unhandled_input(event: InputEvent) -> bool:
		# 是否需要向上冒泡
		return true
