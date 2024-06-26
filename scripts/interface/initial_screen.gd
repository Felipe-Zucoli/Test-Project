extends Control

@onready var menu: Control = $menu
@onready var button_container: VBoxContainer = $menu/button_container
@onready var continue_button: Button = $menu/button_container/continue
@onready var skin_select: Control = $skin_select

func _ready() -> void:
	print("Control _ready called")
	print("menu path:", menu)
	print("button_container path:", button_container)
	print("continue_button path:", continue_button)
	print("skin_select path:", skin_select)
	
	for button in button_container.get_children():
		if button is Button:
			button.add_to_group("button")
			print("Added button to group:", button.name)
	
	for button in get_tree().get_nodes_in_group("button"):
		print("Found button in group:", button.name)
		button.connect("pressed", Callable(self, "on_button_pressed").bind(button.name))
		button.connect("mouse_exited", Callable(self, "mouse_interaction").bind(button, "exited"))
		button.connect("mouse_entered", Callable(self, "mouse_interaction").bind(button, "entered"))
		
	has_save()

	
func has_save() -> void:
	if FileAccess.file_exists(data_management.save_path):
		continue_button.disabled = false
		return
		
	continue_button.modulate.a = 0.5
	
func on_button_pressed(button_name: String) -> void:
	print("Button pressed:", button_name)
	match button_name:
		"play":
			button_container.hide()
			skin_select.show()
		"continue":
			transition_screen.scene_path = "res://scenes/management/level.tscn"
			transition_screen.fade_in()
			
		"quit":
			get_tree().quit()
			
		"back_button":
			skin_select.hide()
			button_container.show()
		"red":
			send_skin_and_start_game("res://assets/player/char_red.png")
			
		"blue":
			send_skin_and_start_game("res://assets/player/char_blue.png")
			
		"green":
			send_skin_and_start_game("res://assets/player/char_green.png")
			
		"purple":
			send_skin_and_start_game("res://assets/player/char_purple.png")
		
	# Only call reset if the tree is initialized
	if get_tree():
		reset()
	else:
		print("Warning: Tree not initialized, skipping reset")


func mouse_interaction(button: Button, type: String) -> void:
	if button.disabled:
		return
	match type:
		"exited":
			button.modulate.a = 1.0
		"entered":
			button.modulate.a = 0.5
			
			
func reset() -> void:
	print("Reset called")
	var buttons = get_tree().get_nodes_in_group("button")
	if buttons:
		print("Buttons in group:", buttons)
		for button in buttons:
			print("Resetting button:", button.name)
			mouse_interaction(button, "exited")
	else:
		print("Error: No buttons found in group 'button'")



func send_skin_and_start_game(skin: String) -> void:
	data_management.data_dictionary.player_texture = skin
	transition_screen.scene_path = "res://scenes/management/level.tscn"
	transition_screen.fade_in()
	data_management.save_data()
