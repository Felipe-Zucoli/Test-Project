extends TextureRect
class_name ArmorContainer

@onready var armor_item: TextureRect = $item

var armor_dictionary: Dictionary = {}
var armor_name: String = ""
var armor_type: String = ""
var armor_texture_path: String = ""

var armor_price: int

func _ready() -> void:
	if FileAccess.file_exists(data_management.save_path):
		data_management.load_data()
		if data_management.data_dictionary.armor_container.is_empty():
			return
			
		var data: Array = data_management.data_dictionary.armor_container
		var item_texture: CompressedTexture2D = load(data[0])
		update_armor_slot(item_texture, data)
		
func update_armor_slot(item_texture: CompressedTexture2D, item_info: Array) -> void:
		if armor_name != "":
			get_tree().call_group(
				"inventory",
				"update_slot",
				armor_name,
				armor_item.texture, 
				[
					armor_texture_path,
					armor_type,
					armor_dictionary,
					armor_price,
					1
				]
			)
			
			reset()
			
		armor_item.texture = item_texture

		# Check and assign texture path
		if typeof(item_info[0]) == TYPE_STRING:
			armor_texture_path = item_info[0]
		else:
			print("Error: item_info[0] is not a String. It is: ", typeof(item_info[0]))
			armor_texture_path = ""
		
		# Check and assign armor name
		if typeof(item_info[1]) == TYPE_STRING:
			armor_name = item_info[1]
		else:
			print("Error: item_info[1] is not a String. It is: ", typeof(item_info[1]))
			armor_name = ""
		
		# Check and assign armor type
		if typeof(item_info[2]) == TYPE_STRING:
			armor_type = item_info[2]
		else:
			print("Error: item_info[2] is not a String. It is: ", typeof(item_info[2]))
			armor_type = ""
		
		# Check if item_info[3] is a Dictionary
		if typeof(item_info[3]) == TYPE_DICTIONARY:
			armor_dictionary = item_info[3]
		else:
			print("Error: item_info[3] is not a Dictionary. It is: ", typeof(item_info[3]))
			armor_dictionary = {}

		# Check and assign armor price
		if typeof(item_info[4]) == TYPE_INT:
			armor_price = item_info[4]
		else:
			print("Error: item_info[4] is not an int. It is: ", typeof(item_info[4]))
			armor_price = 0
		
		armor_item.show()
		get_tree().call_group("stats_hud", "update_bonus_stats", armor_dictionary, false)
		data_management.data_dictionary.armor_container = item_info
		data_management.save_data()
func reset() -> void:
	armor_name = ""
	armor_type = ""
	armor_texture_path = ""
	
	armor_price = 0
	armor_item.texture = null
	armor_dictionary.clear()

	data_management.data_dictionary.armor_container = []
	data_management.save_data()
