extends CanvasLayer

@onready var inventory_container: InventoryContainer = $inventory_container
@onready var stats_container: StatsContainer = $stats_container
@onready var equipment_container: EquipmentContainer = $equipment_container

var can_show_container: bool = true

const DIALOG_CONTAINER: PackedScene = preload("res://scenes/interface/general/dialog_container.tscn")

func _process(delta: float) -> void:
	if can_show_container:
		show_inventory()
		show_stats()

func show_inventory() -> void:
	if Input.is_action_just_pressed("inventory"):
		hide_equipment_container()
		inventory_container.is_object_visible = !inventory_container.is_object_visible
		
		if inventory_container.is_object_visible:
			inventory_container.animation.play("show_container")
		else:
			inventory_container.reset()
			inventory_container.animation.play("hide_container")
			equipment_container.animation.play("show_container")
				
		if stats_container.is_object_visible:
			stats_container.reset()
			stats_container.is_object_visible = false
			stats_container.animation.play("hide_container")

func show_stats() -> void:
	if Input.is_action_just_pressed("stats"):
		hide_equipment_container()
		stats_container.is_object_visible = !stats_container.is_object_visible
		
		if stats_container.is_object_visible:
			stats_container.animation.play("show_container")
		else:
			stats_container.reset()
			stats_container.animation.play("hide_container")
			equipment_container.animation.play("show_container")
		
		if inventory_container.is_object_visible:
			inventory_container.reset()
			inventory_container.is_object_visible = false
			inventory_container.animation.play("hide_container")
			
func hide_equipment_container() -> void:
	equipment_container.animation.play("hide_container")

func spawn_dialog(interactable: Object, dialog_list: Dictionary) -> void:
	var dialog = DIALOG_CONTAINER.instantiate()
	dialog.dialog_list = dialog_list
	dialog.connect("finished", Callable(interactable, "on_dialog_finished"))
	add_child(dialog)
