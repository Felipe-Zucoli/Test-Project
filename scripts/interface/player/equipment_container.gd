extends Control
class_name EquipmentContainer

@onready var consumable_container: TextureRect = $consumable_background
@onready var weapon_container: TextureRect = $v_container/weapon_background
@onready var armor_container: TextureRect = $v_container/armor_background

@onready var animation: AnimationPlayer = $animation

func consumable_slot (item_texture: CompressedTexture2D, item_info: Array) -> void:
	consumable_container.update_consumable_slot(item_texture, item_info)
	
func armor_slot (item_texture: CompressedTexture2D, item_info: Array) -> void:
	armor_container.update_armor_slot(item_texture, item_info)
	
func weapon_slot(item_texture: CompressedTexture2D, item_info: Array) -> void:
	weapon_container.update_weapon_slot(item_texture, item_info)
	
