extends State

class_name PlayerState

var player: Player

#玩家Player的引用
func _ready() -> void:
	await owner.ready
	player = owner as Player
