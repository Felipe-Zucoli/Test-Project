extends TextureRect
class_name ConsumableContainer

@onready var consumable_item: TextureRect = $item
@onready var consumable_amount: Label = $amount

var consumable_item_name: String = ""
var consumable_item_type: String = ""
var consumable_texture_path: String = ""

var consumable_item_price: int
var consumable_item_amount: int
var consumable_item_type_value: int

var can_click: bool = false

func _ready() -> void:
	if FileAccess.file_exists(data_management.save_path):
		data_management.load_data()
		if data_management.data_dictionary.consumable_container.is_empty():
			return
			
		var data: Array = data_management.data_dictionary.consumable_container
		var item_texture: CompressedTexture2D = load(data[0])
		update_consumable_slot(item_texture, data)
		
func update_consumable_slot(item_texture: CompressedTexture2D, item_info: Array) -> void:
	print("Updating consumable slot with item_info: ", item_info)

	# Ensure item_info[2] is a string before comparison
	if str(item_info[1]) == consumable_item_name:
		consumable_item_amount += int(item_info[2])
		
		if consumable_item_amount > 9:
			var leftover: int = consumable_item_amount - 9
			item_info[2] = leftover
			consumable_item_amount = 9
			
			get_tree().call_group(
				"inventory",
				"update_slot",
				consumable_item_name,
				consumable_item.texture,
				[
					consumable_texture_path,
					consumable_item_type,
					consumable_item_type_value,
					consumable_item_price,
					leftover
				]
			)
		consumable_amount.text = str(consumable_item_amount)
		print("Updated consumable item amount (after merging): ", consumable_item_amount)
		return
		
	if consumable_item_name != "":
		get_tree().call_group(
			"inventory",
			"update_slot",
			consumable_item_name,
			consumable_item.texture,
			[
				consumable_texture_path,
				consumable_item_type,
				consumable_item_type_value,
				consumable_item_price,
				consumable_item_amount
			]
		)
	
	# Update consumable slot with new item information
	consumable_texture_path = str(item_info[0])
	consumable_item_name = str(item_info[1])
	consumable_item_amount = int(item_info[2])
	consumable_item_type = str(item_info[3])
	consumable_item_type_value = int(item_info[4])
	consumable_item_price = int(item_info[5])
	
	consumable_amount.text = str(consumable_item_amount)
	consumable_item.texture = item_texture
	consumable_amount.show()
	
	data_management.data_dictionary.consumable_container = item_info
	data_management.save_data()
	
	print("Updated consumable item slot: ", consumable_item_name, consumable_item_amount, consumable_item_type, consumable_item_type_value, consumable_item_price)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_click:
		if consumable_item_amount > 0:  # Changed to strictly greater than zero
			match consumable_item_type:
				"Health":
					get_tree().call_group("player_stats", "update_health", "Increase", consumable_item_type_value)
				"Mana":
					get_tree().call_group("player_stats", "update_mana", "Increase", consumable_item_type_value)
			consumable_item_amount -= 1
			
			data_management.data_dictionary.consumable_container = [
				consumable_texture_path, 
				consumable_item_name, 
				consumable_item_amount,
				consumable_item_type, 
				consumable_item_type_value, 
				consumable_item_price 
			]
			data_management.save_data()
			if consumable_item_amount == 0:
				reset()
			
			consumable_amount.text = str(consumable_item_amount)

func _on_mouse_entered() -> void:
	can_click = true
	modulate.a = 0.5
	
func _on_mouse_exited() -> void:
	can_click = false
	modulate.a = 1.0
	
func reset() -> void:
	consumable_item_name = ""
	consumable_item_type = ""
	consumable_texture_path = ""
	
	consumable_item_price = 0
	consumable_item_type_value = 0
	
	consumable_amount.hide()
	consumable_item.texture = null

	data_management.data_dictionary.consumable_container =[]
	data_management.save_data()
