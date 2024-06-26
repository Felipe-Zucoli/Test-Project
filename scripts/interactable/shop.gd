extends Area2D

@onready var aux_animation: AnimationPlayer = $dialog_icon/aux_animation

var can_interact: bool = false
var player_ref: CharacterBody2D = null
var dialog_list: Dictionary = {
	"name": "Merchant",
	"portrait": "res://assets/interface/dialog/merchant_portrait.png",
	"dialog": [
		"hello, Adventurer... he he",
		"what do you want?"
	]
	
}

func on_shop_body_entered(body: CharacterBody2D) -> void:
	player_ref = body
	if can_interact:
		aux_animation.play("fade_in")



func on_shop_body_exited(body: CharacterBody2D) -> void:
	player_ref = null
	aux_animation.play("fade_out")

func _process(delta: float) -> void:
	if (
		player_ref != null and 
		Input.is_action_just_pressed("Interact") and
		 player_ref.is_on_floor() and
			can_interact
			):
				interactble_action()
				can_interact = false
				
func interactble_action() -> void:
	get_tree().call_group("hud", "spawn_dialog",dialog_list)
	aux_animation.play("fade_out")
	player_ref.reset(true)

func on_dialog_finished() -> void:
	can_interact = true
	player_ref.reset(false)
	aux_animation.play("fade_in")
	
