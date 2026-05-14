extends PlayerState
class_name PlayerStateIdle

func enter_state() -> void:
	player.play_direction_anim("idle")

func _input(event: InputEvent) -> void:
	if player.is_moving():
		fsm.transition_to("Walk")
