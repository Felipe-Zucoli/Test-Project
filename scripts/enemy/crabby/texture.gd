extends EnemyTexture
class_name CrabbyTexture


const ATTACK_EFFECT: PackedScene = preload("res://scenes/effect/general_effects/crabby_attack_effect_template.tscn")
var can_spawn_effect: bool = false

func animate(velocity: Vector2) -> void:
	if enemy.can_attack or enemy.can_hit or enemy.can_die:
		action_behavior()
	else:
		movement_behavior(velocity)
		


func  action_behavior() -> void:
	if enemy.can_die == true:
		animation.play("dead")
		enemy.can_hit = false
		enemy.can_attack = false
		attack_area_collision.set_deferred("disabled", true)
		print("can die")
	elif enemy.can_hit == true:
		print("Enemy can hit")
		animation.play("hit")
		enemy.can_attack = false
		attack_area_collision.set_deferred("disabled", true)
		print("can hit")
	elif enemy.can_attack:
		if can_spawn_effect:
			spawn_attack_effect()
			can_spawn_effect = false
			
		animation.play("attack" + enemy.attack_animation_suffix)
		#print("can attack")

func movement_behavior(velocity: Vector2) -> void:
	if velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
		

func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"attack_right":
			can_spawn_effect = true
			enemy.can_attack = false
			enemy.set_physics_process(true)
			
		"attack_left":
			can_spawn_effect = true
			enemy.can_attack = false
			enemy.set_physics_process(true)
		
		"hit":
			enemy.can_hit = false
			enemy.can_attack = false
			enemy.set_physics_process(true)
		
		"dead":
			enemy.kill_enemy()
			enemy.set_physics_process(false)
			
		"kill":
			enemy.queue_free()
			
			
func spawn_attack_effect () -> void:
	var effect = ATTACK_EFFECT.instantiate()
	get_tree().root.call_deferred("add_child", effect)
	effect.global_position = global_position
	effect.player_effect()
