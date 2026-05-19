extends CharacterBody2D

class_name Player

@export_group("Stats")
@export var	max_health: float = 10.0
@export var	max_mana: float = 10.0
@export var	move_speed: float = 60.0
@export var	damage: float = 5.0
@export var	crit_chance: float = 0.0
@export var	crit_damage: float = 0.0

@export_group("Exp")
@export var base_exp: float = 100.0
@export var exp_multiplier: float = 2.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var health_component: HealthComponent = $HealthComponent

@onready var enemy_area: Area2D = %EnemyAttackArea

#把有限状态系统，放进玩家类里面
@onready var fsm: FSM = $FSM
@onready var weapon: Node2D = $Weapon

@onready var attack_positions: Dictionary = {
	"up": %Up,
	"down": %Down,
	"left": %Left,
	"right": %Right
}

var curr_exp: float

#下一级所需经验量
var next_level_exp: float

var curr_level: int = 1
var curr_points: int = 0

var curr_mana:float
var last_direction: String = "down"

#测试增加经验
#func _ready() -> void:
	#setup()
	#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#add_exp(300)

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
			last_direction = "right"
		else:
			last_direction = "left"
	else :
		if input_vector.y >0:
			last_direction = "down"
		else:
			last_direction = "up"

func play_direction_anim(anim_name: String) ->void:
	animated_sprite.play("%s_%s" % [anim_name,last_direction])

func add_exp(value:float)->void:
	curr_exp += value
	while curr_exp >= next_level_exp:
		level_up()
	
	#新等级，用于更新经验条	
	EventBus.on_player_new_level.emit(curr_exp,next_level_exp)

func level_up() ->void:
	curr_exp -= next_level_exp
	curr_level += 1
	curr_points += 4
	next_level_exp *= exp_multiplier
	EventBus.on_player_stats_updated.emit()
	
func setup()->void:
	rest_health()
	rest_mana()
	next_level_exp = base_exp

func rest_health() ->void:
	health_component.setup(max_health)
	EventBus.on_player_health_updated.emit(max_health,max_health)

func rest_mana() ->void:
	curr_mana = max_mana
	EventBus.on_player_mana_updated.emit(max_mana,max_mana)

func use_mana(value:float) ->void:
	curr_mana -= value
	curr_mana = max(curr_mana,0)
	EventBus.on_player_mana_updated.emit(curr_mana,max_mana)

func enable_weapon_collision(value: bool) -> void:
	
	#敌人区域监控
	enemy_area.monitoring = value
