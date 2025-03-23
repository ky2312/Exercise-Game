extends Node
class_name Section

signal finish

static var last_index: int = 0

var index: int = 0

var avatar: Avatar

## 文本
var text: String = ""

## 前面节点
## 为null则表示头节点
var prev: Section

## 后续节点
var next: Section

var buttons: Dictionary[String, Callable]

func _init(text: String, avatar: Avatar = null) -> void:
	self.avatar = avatar
	self.text = text
	self.index = Section.last_index
	Section.last_index += 1

func _to_string() -> String:
	var avatar: String = ""
	if self.avatar:
		avatar = self.avatar.to_string()
	var nextindexstr: String = str(self.next.index)
	var nextstr: String = self.next.to_string()
	return "index: "+ str(self.index) +"\navatar: "+ avatar +"\ntext: "+ self.text +"\nnext index: "+ nextindexstr +"\n\n"+ nextstr

func pipe(section: Section) -> Section:
	self.next = section
	section.prev = self
	return section

#func pipe_arr(sections: Array[Section]) -> Section:
	#for section in sections:
		#self.next.push_back(section)
	#return self

func to_top() -> Section:
	var prev: Section = self
	while prev:
		if prev.prev:
			prev = prev.prev
		else:
			break
	return prev

func add_buttons(buttons: Dictionary[String, Callable]) -> Section:
	self.buttons = buttons
	return self

class Avatar:
	enum {
		DIRECTION_LEFT = -1,
		DIRECTION_CENTER = 0,
		DIRECTION_RIGHT = 1,
	}
	
	## 头像方位
	var direction: int = DIRECTION_CENTER
	
	var avatar_name: String = ""
	
	var image: Resource
	
	func _init(avatar_name: String, image: Resource, direction: int) -> void:
		self.image = image
		self.avatar_name = avatar_name
		self.direction = direction
	
	func _to_string() -> String:
		var str: String = "name: "+ self.avatar_name +" direction: "
		match self.direction:
			self.DIRECTION_LEFT:
				str += "左"
			self.DIRECTION_RIGHT:
				str += "右"
		return str
