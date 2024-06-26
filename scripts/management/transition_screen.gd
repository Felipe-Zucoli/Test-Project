extends CanvasLayer

@onready var animation: AnimationPlayer = $animation

var scene_path: String = ""

func fade_in() -> void:
	animation.play("fade_in")

func on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		var _change_scene: bool = get_tree().change_scene_to_file(scene_path)
		animation.play("fade_out")
