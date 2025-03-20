class_name FSM extends RefCounted

var database: Dictionary[String, Variant]

var states: Dictionary[String, State]

var current_state_name: String

var current_state: State:
	get():
		return states.get(current_state_name)

var _context: Context

func _init() -> void:
	self._context = Context.new(self)

func set_database(name: String, value: Variant):
	self.database.set(name, value)
	
func add_state(name: String, state: State):
	if states.has(name):
		push_warning("State repetition.")
		return
	state.context = _context
	states.set(name, state)

func add_states(obj: Dictionary[String, State]):
	for k in obj:
		add_state(k, obj[k])

func set_init(name: String):
	if not states.has(name):
		push_warning("The state does not exist.")
		return
	current_state_name = name

func change_state(name: String):
	var enter = func(name):
		#print("进入|{0}".format([name]))
		var new = states.get(name)
		current_state_name = name
		new.enter()
	var exit = func(name):
		#print("删除|{0}".format([name]))
		var old = states.get(name)
		old.exit()
	_change_state(current_state_name, name, enter, exit)
	
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
		#print("同层|{0} {1}".format([old_name, new_name]))
		exit_state_func.call(old_name.trim_suffix("/"))
		enter_state_func.call(new_name.trim_suffix("/"))
		return
	# 从旧状态退出
	var old_re_i = len(old_name_arr) - 1
	while old_i <= old_re_i:
		var str = ""
		var i = 0
		while i <= old_re_i:
			str += old_name_arr[i] + "/"
			i += 1
		#print("删除|{0}".format([str]))
		exit_state_func.call(str.trim_suffix("/"))
		old_re_i -= 1
	# 进入新状态
	while new_i < len(new_name_arr):
		var str = ""
		var i = 0
		while i <= new_i:
			str += new_name_arr[i] + "/"
			i += 1
		#print("进入|{0}".format([str]))
		enter_state_func.call(str.trim_suffix("/"))
		new_i += 1

func update(delta: float):
	var state: State = states.get(current_state_name)
	while state:
		state.update(delta)
		state = state.parent
	
func input(event: InputEvent):
	var state: State = states.get(current_state_name)
	while state:
		state.input(event)
		state = state.parent

class Context extends RefCounted:
	var database: Dictionary[String, Variant]:
		get():
			return _fsm.database
	
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
	
	func enter():
		pass
	
	func update(delta: float):
		pass
	
	func exit():
		pass
	
	func input(event: InputEvent):
		pass
