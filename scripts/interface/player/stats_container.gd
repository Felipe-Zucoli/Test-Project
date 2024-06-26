extends Control
class_name StatsContainer

@onready var animation: AnimationPlayer = $animation
@onready var left_container: TextureRect = $left_container
@onready var right_container: TextureRect = $right_container

var is_object_visible: bool = false

func _ready() -> void:
	update_avaliable_points()
	
func update_stats(stats_list: Array, bonus_stats_list: Array) -> void:
	left_container.update_stats(stats_list, bonus_stats_list)
	
	
func update_bonus_stats( bonus_dict: Dictionary, state: bool) -> void:
	left_container.update_bonus_stats(bonus_dict, state)
	
	
func reset () -> void:
	left_container.reset()
	right_container.reset()
	

func update_avaliable_points() -> void:
	right_container.update_avaliable_points(5)

