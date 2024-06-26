extends Sprite2D
class_name PlayerTexture

signal game_over

var normal_attack: bool = false
var sufix: String = "_right"
var shield_off: bool = false
var crouch_off: bool = false
var magic_attack: bool = false

@export var animation_path: NodePath
@onready var animation = get_node(animation_path) as AnimationPlayer

@export var player_path: NodePath
@onready var player = get_node(player_path) as CharacterBody2D

@export var attack_collision_path: NodePath
@onready var attack_collision = get_node(attack_collision_path) as CollisionShape2D


func _ready() -> void:
	data_management.load_data()
	if data_management.data_dictionary.player_texture != "":
		texture = load(data_management.data_dictionary.player_texture)
		return


func animate(direction: Vector2) -> void:
	verify_position(direction)
	if player.on_hit or player.dead: 
		hit_behavior()
		
	elif player.attacking or player.defending or player.crouching or player.next_to_wall():
		action_behavior()
		
	elif direction.y != 0:
		vertical_behavior(direction)
	elif player.landing == true:
		animation.play("landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)
		
func hit_behavior() -> void:
	player.set_physics_process(false)
	attack_collision.set_deferred("disabled", true)
	if player.dead:
		animation.play("dead")
	elif player.on_hit:
		animation.play("hit")

func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
		sufix ="_right"
		player.direction = -1
		player.spell_offset = Vector2(100, -50)
		player.flipped = false
		position = Vector2.ZERO
		player.wall_ray.target_position = Vector2 (5.5, 0)
	elif direction.x < 0:
		flip_h = true
		sufix ="_left"
		player.direction = 1
		player.spell_offset = Vector2(-100, -50)
		player.flipped = true
		position = Vector2 (-2, 0)
		player.wall_ray.target_position = Vector2 (-7.5, 0)

func action_behavior() -> void:
	if player.next_to_wall():
		animation.play("wall_slide")
	elif player.attacking and normal_attack:
		animation.play("attack" + sufix)
	elif player.attacking and magic_attack:
		animation.play("spell_attack")
	elif player.defending and shield_off:
		shield_off = false
		animation.play("shield")
	elif player.crouching and crouch_off:
		animation.play("crouch")
		crouch_off = false
	

func vertical_behavior(direction: Vector2) -> void:
	if direction.y > 0:
		player.landing = true
		animation.play("fall")
	
	elif direction.y < 0:
		animation.play("jump")

func horizontal_behavior(direction: Vector2) -> void:
	if direction.x != 0:
		animation.play("run" + sufix)
	else: 
		animation.play("idle")


func _on_animation_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"landing":
			player.landing = false
			player.set_physics_process(true)
		
		"attack_left": 
			normal_attack = false
			player.attacking = false
			
		"attack_right":
			normal_attack = false
			player.attacking = false
			
		"hit":
			player.on_hit = false
			player.set_physics_process(true)
			
			if player.defending:
				animation.play("shield")
				
			if player.crouching:
				animation.play("crouch")
				
		"dead":
			emit_signal("game_over")
		
		"spell_attack":
			magic_attack = false
			player.attacking = false
			
