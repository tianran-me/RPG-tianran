extends Node
class_name FSM

#状态切换信号，把新状态名字传出去
signal on_state_transitioned(state_name :String)

#导出变量，初始状态,初始状态指定为Idle
@export var initial_state: NodePath

var curr_state: State

func _ready() -> void:
	
	#等所有者就绪
	await  owner.ready
	
	#遍历所有子节点（Idle, Walk, Attack...）
	for state: State in get_children():
		
		#把 FSM 节点本身，赋值给子节点里的 'fsm' 变量
		state.fsm = self
	
	#变为初始的Idle状态
	curr_state = get_node(initial_state)
	
	#预留，进行一些初始化操作
	curr_state.enter_state()

#切换到下一个状态
func transition_to(state_name: String) -> void:
	if not has_node(state_name):
		return
	
	curr_state.exit_state()
	curr_state = get_node(state_name)
	curr_state.enter_state()
	on_state_transitioned.emit(curr_state.name)
	
