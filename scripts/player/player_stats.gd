extends Node
class_name  PlayerStats

@onready var invencibility_timer: Timer = get_node("InvencibilityTimer")

var shielding: bool = false

var base_healt: int = 15
var base_mana: int = 10
var base_attack: int = 5
var base_magic_attack: int = 5
var base_defense: int = 1

var bonus_health: int = 0
var bonus_mana: int = 0
var bonus_attack: int = 0
var bonus_defense: int = 0
var bonus_magic_attack: int = 0

var current_mana: int
var current_healt: int

var max_mana: int
var max_healt: int

var current_exp: int = 0

var level: int = 1
var level_dict: Dictionary = {
	"1": 25,
	"2": 33,
	"3": 59,
	"4": 66,
	"5": 93,
	"6": 135,
	"7": 186,
	"8": 251,
	"9": 356,
}

@export var player_path: NodePath
@onready var player = get_node(player_path) as CharacterBody2D

@export var collision_area_path: NodePath
@onready var collision_area = get_node(collision_area_path) as Area2D

@export var floating_text: PackedScene

func _ready() -> void:
	if FileAccess.file_exists(data_management.save_path):
		data_management.load_data()
		
		level = data_management.data_dictionary.current_level
		current_exp = data_management.data_dictionary.current_exp
		
		current_healt = data_management.data_dictionary.current_health
		current_mana = data_management.data_dictionary.current_mana
		
		update_stats_with_seralized_data()
		
		get_tree().call_group("bar_container", "init_bar", max_healt, max_mana, level_dict[str(level)])
		get_tree().call_group("bar_container", "reset_exp_bar", level_dict[str(level)], current_exp)
		
		get_tree().call_group("bar_container", "update_bar", "HealthBar", current_healt)
		get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
		
	#update_stats_hud()


	
func update_stats(stats: String) -> void:
	match stats:
		"Attack":
			base_attack += 1
		
		"Mana":
			max_mana += 1
			base_mana += 1
			current_mana += 1
			
			get_tree().call_group("bar_container", "increase_max_value", "Mana", max_mana, current_mana)
			
		"Health":
			max_healt += 1
			base_healt += 1
			current_healt += 1
			
			get_tree().call_group("bar_container", "increase_max_value", "Health", max_healt, current_healt)
			
		"Magic Attack":
			base_magic_attack += 1
			
		"Defense":
			base_defense += 1
			
	update_stats_hud()
	
func update_bonus_stats(stats: String, value: int, reset: bool) -> void:
	match stats:
		"Health":
			if reset == true:
				bonus_health -= value
				
			if reset == false:
				bonus_health += value
				
			max_healt = bonus_health + base_healt
			get_tree().call_group("bar_container", "increase_max_value", "Health", max_healt, current_healt)
			
		"Mana":
			if reset == true:
				bonus_mana -= value
				
			if reset == false:
				bonus_mana += value
				
			max_mana = bonus_mana + base_mana
			get_tree().call_group("bar_container", "increase_max_value", "Mana", max_mana, current_mana)
		
		"Attack":
				if reset == true:
					bonus_attack -= value
					
				if reset == false:
					bonus_attack += value
					
		"Magic Attack":
				if reset == true:
					bonus_magic_attack -= value
				
				if reset == false:
					bonus_magic_attack += value
					
		"Defense":
				if reset == true:
					bonus_defense -= value
					
				if reset == false:
					bonus_defense += value
	
	update_stats_hud()
	
	
func update_stats_hud() -> void:
	get_tree().call_group("stats_hud",
	"update_stats",
	[
		base_healt,
		base_mana,
		base_attack,
		base_magic_attack,
		base_defense
	],
	[
		bonus_health,
		bonus_mana,
		bonus_attack,
		bonus_magic_attack,
		bonus_defense
	]
	)

	data_management.data_dictionary.base_stats =[
		base_healt,
		base_mana,
		base_attack,
		base_magic_attack,
		base_defense
	]
	data_management.save_data()
	
	if current_healt > max_healt:
		current_healt = max_healt
		
	if current_mana > max_mana:
		current_mana = max_mana
	

func update_stats_with_seralized_data() -> void:
	var base_stats: Array = data_management.data_dictionary.base_stats
	print(base_stats)
	base_mana = base_stats[1]
	base_healt = base_stats[0]
	base_attack = base_stats[2]
	base_magic_attack = base_stats[3]
	base_defense = base_stats[4]
	
	max_mana = base_mana + bonus_mana
	max_healt = base_healt + bonus_health


func update_exp(value: int) -> void:
	current_exp += value
	spawn_floating_text("+", "Exp", value)
	get_tree().call_group("bar_container", "update_bar", "ExpBar", current_exp)
	if current_exp >= level_dict[str(level)] and level < 9:
		var leftover: int = current_exp - level_dict[str(level)]
		current_exp = leftover
		on_level_up()
		level +=  1
		data_management.data_dictionary.current_level = level
		
	elif current_exp >= level_dict[str(level)] and level == 9:
		current_exp = level_dict[str(level)]
		
	data_management.data_dictionary.current_exp = current_exp
	data_management.save_data()
func on_level_up() -> void:
	current_mana = base_mana + bonus_mana
	current_healt = base_healt + bonus_health
	
	get_tree().call_group("stats_hud", "update_avaliable_points")
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_healt)
	
	await get_tree().create_timer(0.2).timeout
	get_tree().call_group("bar_container", "reset_exp_bar", level_dict[str(level)], current_exp)
	
func update_health(type: String, value: int) -> void:
	match type:
		"Increase":
			current_healt += value
			spawn_floating_text("+", "Heal", value)
			if current_healt >= max_healt:
				current_healt = max_healt
				
		"Decrease":
			verify_shield(value)
			if current_healt <= 0:
				player.dead = true
			else:
				player.on_hit = true
				player.attacking = false
				
	data_management.data_dictionary.current_health = current_healt
	data_management.save_data()
	get_tree().call_group("bar_container", "update_bar", "HealthBar", current_healt)
			
func verify_shield(value: int) -> void:
	if shielding:
		if (base_defense + bonus_defense) >= value:
			return
		
		var damage= abs((base_defense + bonus_defense)- value)
		spawn_floating_text("-", "Damage", damage)
		current_healt -= damage
	else:
		spawn_floating_text("-", "Damage", value)
		current_healt -= value
		
		
func update_mana(type: String, value: int) -> void:
	match type:
		"Increase":
			current_mana += value
			spawn_floating_text("+", "Mana", value)
			if current_mana >= max_mana:
				current_mana = max_mana
		"Decrease":
			current_mana -= value
			spawn_floating_text("-", "Mana", value)
			
	data_management.data_dictionary.current_mana = current_mana
	data_management.save_data()
	get_tree().call_group("bar_container", "update_bar", "ManaBar", current_mana)


func _on_collision_area_area_entered(area: Area2D) -> void:
	if area.name == "EnemyAttackArea":
		update_health("Decrease", area.damage)
		collision_area.set_deferred("monitoring", false)
		invencibility_timer.start(area.invencibility_timer)


func _on_invencibility_timer_timeout() -> void:
	collision_area.set_deferred("monitoring", true)
	
	
func spawn_floating_text(type_sign: String, type: String, value: int) -> void:
	var text: FloatingText = floating_text.instantiate()
	print(text)
	text.global_position = player.global_position
	print(text.global_position)
	print(player.position)
	text.type = type
	text.value = value
	text.type_sign = type_sign
	
	get_tree().root.call_deferred("add_child", text)
