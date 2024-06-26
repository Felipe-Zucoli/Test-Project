extends EnemyTexture
class_name  WhaleTexture

func animate(velocity: Vector2) -> void:
	if enemy.can_hit or enemy.can_die or enemy.can_attack:
		action_behavior()
	else:
		move_behavior(velocity)
	

func action_behavior() -> void:
	if enemy.can_die:
		animation.play("dead")
		enemy.can_hit = false
		enemy.can_attack = false
		print("can die")
	elif enemy.can_hit:
		animation.play("hit")
		enemy.can_attack = false
		print("can hit")
	elif enemy.can_attack:
		animation.play("attack")
		print("can attack")
func move_behavior(velocity: Vector2) -> void:
	if velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")

func _on_animation_finished(anim_name: StringName) -> void:
	match  anim_name:
		"hit":
			enemy.can_hit = false
			enemy.set_physics_process(true)
			
			
		"dead":
			enemy.kill_enemy()
			
		"kill":
			enemy.queue_free()
			enemy.can_attack = false
