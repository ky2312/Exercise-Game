extends Node
class_name BT

class AnimatedSprite extends RefCounted:
	var node: AnimatedSprite2D
	func _init(node: AnimatedSprite2D):
		self.node = node
		
	func flip_h(value: bool):
		node.flip_h = value
		
	func play_idle():
		node.play("idle")
	
	func play_run():
		node.play("run")
	
	func play_jump():
		node.play("jump")
	
	func play_roll():
		node.play("roll")

class BTContext extends RefCounted:
	var speed = 150.0
	
	var roll_speed = 300
	var roll_duration = 0.3
	var is_rolling = false
	var roll_timer = 0.0
	var roll_direction = 0
	
	var animated_sprite: AnimatedSprite

class BTManager extends RefCounted:
	var context: BTContext
	
	var root: BTNode
	
	func _init(context: BTContext):
		self.context = context
	
	func set_root(node: BTNode):
		root = node
		
	func tick(node) -> BTNode.Status:
		root.context = context
		return root.tick(node)

## 基础节点类
class BTNode extends RefCounted:
	enum Status {SUCCESS = 0, FAILURE = 1, RUNNING = 2}

	var context: BTContext
	
	func tick(node) -> Status:
		return Status.FAILURE

## 序列节点类
class SequenceNode extends BTNode:
	var children: Array[BTNode] = []
	
	func tick(node) -> Status:
		for child in children:
			child.context = context
			var status = child.tick(node)
			match status:
				Status.FAILURE:
					return Status.FAILURE
				Status.RUNNING:
					return Status.RUNNING
		return Status.SUCCESS

## 选择节点类
class SelectorNode extends BTNode:
	var children: Array[BTNode] = []

	func tick(node) -> Status:
		for child in children:
			child.context = context
			var status = child.tick(node)
			match status:
				Status.SUCCESS:
					return Status.SUCCESS
				Status.RUNNING:
					return Status.RUNNING
		return Status.FAILURE

## 动作节点类
class ActionNode extends BTNode:
	func action(node):
		pass

	func tick(node):
		action(node)
		return Status.SUCCESS

## 条件节点类
class ConditionNode extends BTNode:
	var _is_flip: bool = false
	
	func check(node):
		return false

	func to_flip():
		_is_flip = true
		return self

	func tick(node):
		var status: Status
		if check(node):
			status = Status.SUCCESS
		else:
			status = Status.FAILURE
		if _is_flip:
			match status:
				Status.SUCCESS:
					status = Status.FAILURE
				Status.FAILURE:
					status = Status.SUCCESS
		return status

# 以下为常用节点组

"""
选择 移动组
	顺序
		选择
			条件 是否按左键
			条件 是否按右键
		行为 移动
	顺序
		顺序
			条件 是否按左键 反
			条件 是否按右键 反
		行为 移动减速
"""
class MoveGroupNode extends RefCounted:
	var node: SelectorNode
	
	func _init():
		node = SelectorNode.new()
		var move_action = MoveAction.new()

		var move_sequence = SequenceNode.new()
		var left_right_selector = SelectorNode.new()
		var is_action_pressed_left_condition = IsActionPressedLeftCondition.new().to_just(false)
		var is_action_pressed_right_condition = IsActionPressedRightCondition.new().to_just(false)
		left_right_selector.children.push_back(is_action_pressed_left_condition)
		left_right_selector.children.push_back(is_action_pressed_right_condition)
		move_sequence.children.push_back(left_right_selector)
		move_sequence.children.push_back(move_action)
		
		var slow_move_sequence = SequenceNode.new()
		var left_right_sequence = SequenceNode.new()
		var is_not_action_pressed_left_condition = IsActionPressedLeftCondition.new().to_just(false).to_flip()
		var is_not_action_pressed_right_condition = IsActionPressedRightCondition.new().to_just(false).to_flip()
		left_right_sequence.children.push_back(is_not_action_pressed_left_condition)
		left_right_sequence.children.push_back(is_not_action_pressed_right_condition)
		slow_move_sequence.children.push_back(left_right_sequence)
		var slow_move_action = SlowMoveAction.new()
		slow_move_sequence.children.push_back(slow_move_action)
		
		node.children.push_back(move_sequence)
		node.children.push_back(slow_move_sequence)

"""
选择 滚动组
	顺序
		条件 是否滚动中 反
		条件 是否按滚动键
		选择
			条件 是否按左键
			条件 是否按右键
		行为 滚动
	顺序
		条件 是否滚动中
		行为 移动减速
"""
class RollGroupNode extends RefCounted:
	var node: SelectorNode
	
	func _init() -> void:
		node = SelectorNode.new()

		var roll_sequence = SequenceNode.new()
		var is_action_pressed_roll_condition = IsActionPressedRollCondition.new()
		var roll_action = RollAction.new()
		var slow_roll_action = SlowRollAction.new()
		var is_not_rolling_condition = IsRollingCondition.new().to_flip()
		var left_right_selector = SelectorNode.new()
		var is_action_pressed_left_condition = IsActionPressedLeftCondition.new().to_just(false)
		var is_action_pressed_right_condition = IsActionPressedRightCondition.new().to_just(false)
		left_right_selector.children.push_back(is_action_pressed_left_condition)
		left_right_selector.children.push_back(is_action_pressed_right_condition)
		roll_sequence.children.push_back(is_not_rolling_condition)
		roll_sequence.children.push_back(is_action_pressed_roll_condition)
		roll_sequence.children.push_back(left_right_selector)
		roll_sequence.children.push_back(roll_action)
		
		var slow_roll_sequence = SequenceNode.new()
		var is_rolling_condition = IsRollingCondition.new()
		slow_roll_sequence.children.push_back(is_rolling_condition)
		slow_roll_sequence.children.push_back(slow_roll_action)
		
		node.children.push_back(roll_sequence)
		node.children.push_back(slow_roll_sequence)

"""
选择 跳跃组
	顺序
		条件 是否在地面上
		条件 是否按跳跃键
		行为 跳跃
	顺序
		条件 是否在地面上 反
		行为 下落
"""
class JumpGroupNode extends RefCounted:
	var node: SelectorNode
	
	func _init() -> void:
		node = SelectorNode.new()
		
		var jump_sequence = SequenceNode.new()
		var is_on_floor_condition = IsOnFloorCondition.new()
		var is_action_pressed_jump_condition = IsActionPressedJumpCondition.new()
		var jump_action = JumpAction.new()
		jump_sequence.children.push_back(is_on_floor_condition)
		jump_sequence.children.push_back(is_action_pressed_jump_condition)
		jump_sequence.children.push_back(jump_action)
		#jump_sequence.children.push_back(move_group)
		
		var fall_sequence = SequenceNode.new()
		var is_not_on_floor_condition = IsOnFloorCondition.new().to_flip()
		var fall_action = FallAction.new()
		fall_sequence.children.push_back(is_not_on_floor_condition)
		fall_sequence.children.push_back(fall_action)
		#fall_sequence.children.push_back(move_group)
		
		node.children.push_back(jump_sequence)
		node.children.push_back(fall_sequence)

# 以下为常用基础节点

class ActionPressedConditionNode extends ConditionNode:
	var is_just: bool = true
	
	func to_just(is_just: bool) -> ActionPressedConditionNode:
		self.is_just = is_just
		return self

## 是否在地面上条件节点
class IsOnFloorCondition extends ConditionNode:
	func check(node):
		return node.is_on_floor()

## 是否点击了跳跃键条件节点
class IsActionPressedJumpCondition extends ActionPressedConditionNode:
	func check(node):
		if is_just:
			return Input.is_action_just_pressed("jump")
		else:
			return Input.is_action_pressed("jump")
		
## 是否点击了滚动键条件节点
class IsActionPressedRollCondition extends ActionPressedConditionNode:
	func check(node):
		if is_just:
			return Input.is_action_just_pressed("roll")
		else:
			return Input.is_action_pressed("roll")

## 是否点击了左键条件节点
class IsActionPressedLeftCondition extends ActionPressedConditionNode:
	func check(node):
		if is_just:
			return Input.is_action_just_pressed("left")
		else:
			return Input.is_action_pressed("left")
		
## 是否点击了右键条件节点
class IsActionPressedRightCondition extends ActionPressedConditionNode:
	func check(node):
		if is_just:
			return Input.is_action_just_pressed("right")
		else:
			return Input.is_action_pressed("right")
	
## 是否滚动中条件节点
class IsRollingCondition extends ConditionNode:
	func check(node):
		return self.context.is_rolling

## 移动动作节点
class MoveAction extends ActionNode:
	func action(node: CharacterBody2D):
		var direction := Input.get_axis("left", "right")
		node.velocity.x = direction * self.context.speed
		self.context.animated_sprite.play_run()
		if direction == 1:
			self.context.animated_sprite.flip_h(false)
		elif direction == -1:
			self.context.animated_sprite.flip_h(true)

## 减速移动动作节点
class SlowMoveAction extends ActionNode:
	func action(node: CharacterBody2D):
		#node.velocity.x = move_toward(node.velocity.x, 0, data.speed)
		node.velocity.x = lerp(node.velocity.x, 0.0, 0.25)
		self.context.animated_sprite.play_idle()

## 跳跃动作节点
class JumpAction extends ActionNode:
	func action(node: CharacterBody2D):
		node.velocity.y = node.jump_velocity
		self.context.animated_sprite.play_jump()

## 下落动作节点
class FallAction extends ActionNode:
	func action(node: CharacterBody2D):
		node.velocity += node.get_gravity() * node.get_physics_process_delta_time()

## 滚动动作节点
class RollAction extends ActionNode:
	func action(node: CharacterBody2D):
		self.context.roll_direction = Input.get_axis("left", "right")
		self.context.is_rolling = true
		self.context.roll_timer = self.context.roll_duration

## 减速滚动动作节点
class SlowRollAction extends ActionNode:
	func action(node: CharacterBody2D):
		self.context.animated_sprite.play_roll()
		self.context.roll_timer -= node.get_process_delta_time()
		if self.context.roll_timer <= 0:
			self.context.is_rolling = false
			self.context.roll_timer = 0
			self.context.roll_direction = 0
		else:
			node.velocity.x = self.context.roll_direction * self.context.roll_speed
			node.velocity.y = 0
