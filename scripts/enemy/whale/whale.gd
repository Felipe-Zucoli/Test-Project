extends EnemyTemplate
class_name  Whale

func _ready() -> void:
	randomize()
	drop_list = {
		"Heal Potion": [
			"res://assets/item/consumable/+1_health_potion.png",
			20,
			"Health",
			5,
			2
		],
		"Mana Potion": [
			"res://assets/item/consumable/+1_mana_potion.png",
			15,
			"Mana",
			5,
			5
		],
		"Whale Mouth": [
			"res://assets/item/resource/whale/whale_mouth.png",
			45,
			"Resource",
			{},
			2
		],
		"Whale Eyes": [
			"res://assets/item/resource/whale/whale_eye.png",
			20,
			"Resource",
			{},
			6
		],
		"Whale Tail": [
			"res://assets/item/resource/whale/whale_tail.png",
			10,
			"Resource",
			{},
			10
		],
		"Whale Mask": [
			"res://assets/item/equipment/whale_mask.png",
			2,
			"Equipement",
			{
				"Mana": 5,
				"Magic Attack": 3
			},
			50
		]
	}
