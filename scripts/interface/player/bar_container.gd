extends Control
class_name  BarContainer



@export var health_bar: TextureProgressBar = null
@export var mana_bar: TextureProgressBar = null
@export var exp_bar: TextureProgressBar = null


var current_exp: int
var current_mana: int
var current_healht:int

func init_bar(health: int, mana: int, max_exp_value: int) -> void:
	exp_bar.max_value = max_exp_value
	health_bar.max_value = health
	mana_bar.max_value = mana
	
	health_bar.value = health
	mana_bar.value = mana
	exp_bar.value = 0
	
	current_exp = 0
	current_mana = mana
	current_healht = health 


func increase_max_value(type: String, max_value: int, value: int) -> void:
	match  type:
		"Healht":
			health_bar.max_value = max_value
			health_bar.value = value
			current_healht = value
		
		"Mana":
			mana_bar.max_value = max_value
			mana_bar.value = value
			current_mana = value 

func update_bar (type: String, value: int) -> void:
	match type:
		"HealthBar":
			call_tween(health_bar, value)
			current_healht = value

		"ManaBar":
			call_tween(mana_bar, value)
			current_mana = value

		"ExpBar":
			call_tween(exp_bar, value)
			current_exp = value

func reset_exp_bar(max_exp: int, value: int) -> void:
	exp_bar.max_value = max_exp
	exp_bar.value = value
	current_exp = value
	
	call_tween(exp_bar, current_exp)

func call_tween(bar: TextureProgressBar, final_value: int) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(
		bar,
		"value",
		final_value,
		0.2
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
