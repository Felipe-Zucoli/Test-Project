extends TextureRect

class_name StatsLeftContainer

@onready var grid_container: GridContainer = $GridContainer

@export var stats_info: TextureRect = null

func _ready() -> void:
	for container in grid_container.get_children():
		default_bonus_value(container)
		container.connect("mouse_exited", Callable(self, "mouse_interaction").bind("exited", container))
		container.connect("mouse_entered", Callable(self, "mouse_interaction").bind("entered", container))
		
		
func default_bonus_value(container: HBoxContainer) -> void:
	container.get_node("bonus").text = ""
		
func mouse_interaction(state: String, container: HBoxContainer) -> void:
	match state:
		"entered":
			container.modulate.a = 0.5
			stats_info.play_animation("show_container")
			match container.name:
				"health_container":
					update_stats_info_container("health")
				
				"mana_container":
					update_stats_info_container("mana")
					
				"attack_container":
					update_stats_info_container("attack")
				
				"magic_attack_container":
					update_stats_info_container("magic attack")
					
				"defense_container":
					update_stats_info_container("defense")
					
		"exited":
			container.modulate.a = 1.0
			stats_info.play_animation("hide_container")
			
func update_stats_info_container(stats: String) -> void:
	stats_info.update_container(stats)

func update_stats(stats_list: Array, bonus_stats_list: Array):
	for index in grid_container.get_child_count():
		var target_stat_text: Label = grid_container.get_child(index).get_node("text")
		var target_bonus_stat_text: Label = grid_container.get_child(index).get_node("bonus")
		
		if bonus_stats_list[index] != 0:
			target_stat_text.text = str(stats_list[index]) + " + "
			target_bonus_stat_text.text = str(bonus_stats_list[index])
		
		else:
			target_stat_text.text = str(stats_list[index])
			target_bonus_stat_text.text = ""
			
func update_bonus_stats(bonus_dict: Dictionary, state: bool) -> void:
	for key in bonus_dict.keys():
		get_tree().call_group("player_stats", "update_bonus_stats", key, bonus_dict[key], state)
		
func reset() -> void:
	for container in grid_container.get_children():
		if container.modulate.a != 1.0:
			container.modulate.a = 1.0
			stats_info.play_animation("hide_container")
