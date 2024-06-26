extends TextureRect

class_name StatsInfo

@onready var animation: AnimationPlayer = $animation
@onready var stats_texture: TextureRect = $stats
@onready var target_stats: TextureRect = $target_stats

var stats_image_list: Dictionary = {
	"attack": "res://assets/interface/stats/text/stats_text/small/attack.png",
	"defense": "res://assets/interface/stats/text/stats_text/small/defense.png",
	"health": "res://assets/interface/stats/text/stats_text/small/health.png",
	"magic attack": "res://assets/interface/stats/text/stats_text/small/magic_attack.png",
	"mana": "res://assets/interface/stats/text/stats_text/small/mana.png"
}

func update_container(stats: String) -> void:
	stats_texture.texture = load(stats_image_list[stats])
	target_stats.texture = load(stats_image_list[stats])
	

func play_animation(anim_name: String) -> void:
	animation.play(anim_name)
