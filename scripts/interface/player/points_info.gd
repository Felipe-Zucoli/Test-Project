extends TextureRect
class_name PointsInfo

@onready var animation: AnimationPlayer = $animation
@onready var avaliable_points: Label = $avaliable_points

func update_text_value(points: String) -> void:
	avaliable_points.text = points
	
func play_animation(anim_name: String) -> void:
	animation.play(anim_name)
