extends TextureRect
class_name  StatsRightContainer

@onready var v_container: VBoxContainer = $v_container

var stats_points: int = 0

@export var points_info: TextureRect = null

func _ready() -> void:
	if FileAccess.file_exists(data_management.save_path):
		data_management.load_data()
		stats_points = data_management.data_dictionary.avaliable_points
		
	points_info.update_text_value(str(stats_points))
	for children in v_container.get_children():
		var button: TextureButton = children.get_node("plus")
		
		button.connect("pressed", Callable(self, "verify_stats").bind(children.name))
		button.connect("mouse_exited", Callable(self, "mouse_interaction").bind("exited", button))
		button.connect("mouse_entered", Callable(self, "mouse_interaction").bind("entered", button))
		
		
func mouse_interaction(type: String, button) -> void:
	match type:
		"exited":
			button.modulate.a = 1.0
			points_info.play_animation("hide_container")
		
		"entered":
			button.modulate.a = 0.5
			points_info.play_animation("show_container")
			
func verify_stats(stats: String) -> void:
	match stats:
		"health_container":
			aplly_weight(1, "Health")
			
		"mana_container":
			aplly_weight(1, "Mana")
			
		"attack_container":
			aplly_weight(3, "Attack")
			
		"magic_attack_container":
			aplly_weight(3, "Magic Attack")
		
		"defense_container":
			aplly_weight(5, "Defense")
			
func aplly_weight(weight: int, stats: String) -> void:
	if stats_points >= weight:
		stats_points -= weight
		points_info.update_text_value(str(stats_points))
		get_tree().call_group("player_stats", "update_stats", stats)
		
		data_management.data_dictionary.avaliable_points = stats_points
		data_management.save_data()

func reset() -> void:
	for children in v_container.get_children():
		var button: TextureButton = children.get_node("plus")
		if button.modulate.a != 1.0:
			button.modulate.a = 1.0
			points_info.play_animation("hide_container")

func update_avaliable_points(value: int) -> void:
	stats_points += value
	points_info.update_text_value(str(stats_points))
	data_management.data_dictionary.avaliable_points = stats_points
	data_management.save_data
