extends AnimatedSprite2D
class_name  EffectTemplate

func player_effect() -> void:
	play()

func _on_animation_finished() -> void:
	queue_free()
