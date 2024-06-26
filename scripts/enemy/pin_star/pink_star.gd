extends EnemyTemplate
class_name PinkStar

func _ready() -> void:
	randomize()
	drop_list = {
		"Health Potion": [
			"res://assets/item/consumable/health_potion.png",
			15,
			"Health",
			5,
			2
		],
		"Mana Potion": [
			"res://assets/item/consumable/mana_potion.png",
			15,
			"Mana",
			5,
			2
		],
		"Pink Star Mouth": [
			"res://assets/item/resource/pink_star/pink_star_mouth.png",
			20,
			"Resource",
			{},
			10
		],
		"Pink Star Belt": [
			"res://assets/item/equipment/pink_star_belt.png",
			50000,
			"Equipment",
			{
				"Health": 5,
				"Attack": 2
			},
			30
		],
		"Pink Star Bow": [
			"res://assets/item/equipment/pink_star_bow.png",
			4,
			"Weapon",
			{
				"Attack": 5
			},
			60
		],
		"Pink Star Shield": [
			"res://assets/item/equipment/pink_star_shield.png",
			4,
			"Weapon",
			{
				"Health": 3,
				"Deffense": 2
			},
			75
		]
	}
