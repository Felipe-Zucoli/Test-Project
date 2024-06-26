extends EnemyTemplate
class_name Crabby

func _ready() -> void:
	randomize()
	drop_list = {
		"Heal Potion": [
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
			5
		],
		"Craby Eyes": [
			"res://assets/item/resource/crabby/crab_eye.png",
			20,
			"Resource",
			{},
			10
		],
		"Crab Pincers": [
			"res://assets/item/resource/crabby/crab_pincers.png",
			20,
			"Resource",
			{},
			10
		],
		"Crabby Belt":[
			"res://assets/item/equipment/crabby_belt.png",
			4,
			"Equipment",
			{
				"Health": 3,
				"Attack": 1
			},
			30
		],
		"Crabby Axe": [
			"res://assets/item/equipment/crabby_axe.png",
			4,
			"Weapon",
			{
				"Attack": 3,
				"Defense": 1
			},
			40
		]
	}
