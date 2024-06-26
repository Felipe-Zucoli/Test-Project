extends Area2D
class_name FireSpell

var spell_damage: int

func _ready() -> void:
	for children in get_children():
		if children is GPUParticles2D and children.name != "explosion_particles":
			children.emitting = true

func _on_animation_finished(_anim_name: StringName) -> void:
	queue_free()
