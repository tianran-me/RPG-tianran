extends CharacterBody2D

class_name Player

@export_group("Stats")
@export var	max_health: float = 10.0
@export var	max_mana: float = 10.0
@export var	move_speed: float = 60.0
@export var	damage: float = 5.0
@export var	crit_chance: float = 0.0
@export var	crit_damage: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

#把有限状态系统，放进玩家类里面
@onready var fsm: FSM = $FSM

var last_direction: String = "down"

func _process(delta: float) -> void:
	
	#检查有限状态机处理
	if fsm.curr_state:
		fsm.curr_state.process_state(delta)
	
#检查是否移动
func is_moving() -> bool:
	var move_input = ["move_up","move_down","move_left","move_right"]
	for input in move_input:
		if Input.is_action_just_pressed(input):
			return true
	return false
	
#更新方向
func update_direction(input_vector: Vector2) -> void:
	if input_vector == Vector2.ZERO:
		return
		
	#四方向情况，上下或者左右移动二选一
	#在左右移动
	#TODO，后面更新为8方向动画
	if abs(input_vector.x) > abs(input_vector.y):
		if input_vector.x >0:
			last_direction = "right_down"
		else:
			last_direction = "left_down"
	else :
		if input_vector.y >0:
			last_direction = "down"
		else:
			last_direction = "up"

func play_direction_anim(anim_name: String) ->void:
	animated_sprite.play("%s_%s" % [anim_name,last_direction])
