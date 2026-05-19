extends PlayerState
class_name PlayerStateAttack

#创建字典存放武器旋转角度数据,
var weapon_rotations: Dictionary = {
	"down": 180.0,
	"left":-90,
	"right":90,
	"up":0.0
}

func enter_state() -> void:
	player.play_direction_anim("attack")
	position_weapon()
	player.animated_sprite.animation_finished.connect(_on_animation_finished)
	
func exit_state() -> void:
	if player.animated_sprite.animation_finished.is_connected(_on_animation_finished):
		player.animated_sprite.animation_finished.disconnect(_on_animation_finished)
		
func position_weapon() -> void:
	var direction_key: String = player.last_direction
	var marker: Marker2D = player.attack_positions[direction_key]
	player.weapon.global_position = marker.global_position
	
	#我不需要旋转武器
	#player.weapon.rotation_degrees = weapon_rotations[direction_key]
	
	player.weapon.show()
	player.enable_weapon_collision(true)

func _on_animation_finished()->void:
	player.enable_weapon_collision(false)
	
	#player.weapon.hide()
	fsm.transition_to("Idle")
