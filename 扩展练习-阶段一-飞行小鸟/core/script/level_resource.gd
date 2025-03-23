extends Resource
class_name LevelResource

## 等级名称
@export var name: String = ""

@export_group("障碍物", "wood_")
## 生成速度
@export_range(1, 5, 0.1) var wood_generate_speed: float = 1.0
## 移动速度
@export_range(1, 500, 0.1) var wood_speed: float = 1.0
