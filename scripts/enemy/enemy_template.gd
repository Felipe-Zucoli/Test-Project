extends CharacterBody2D
class_name  EnemyTemplate

signal kill

@onready var texture = get_node("Texture")
@onready var floor_ray = get_node("FloorRay")
@onready var animation = get_node("Animation")


var can_die: bool = false
var can_hit: bool = false
var can_attack: bool = false

var player_ref: Player = null
var drop_list: Dictionary
var drop_bonus: int = 1
var attack_animation_suffix: String = "_left"

@export var enemy_exp: int
@export var speed: int
@export var gravity_speed: int
@export var proximity_threshold: int
@export var ray_cast_default_position: int
@export var floating_text: PackedScene

func _physics_process(delta: float) -> void:
	gravity(delta)
	move_behavior()
	verify_position()
	texture.animate(velocity)
	move_and_slide()
	
func gravity(delta: float) -> void:
	velocity.y += gravity_speed * delta
	
func move_behavior() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		if abs(distance.x) <= proximity_threshold:
			velocity.x = 0
			can_attack = true
		elif floor_collision() and not can_attack:
			velocity.x = direction.x * speed
		else:
			velocity.x = 0
		
		return
		
	velocity.x = 0

func floor_collision() -> bool:
	if floor_ray.is_colliding():
		return true
		
	return false
	
	
func verify_position() -> void:
	if player_ref != null:
		var direction: float = sign(player_ref.global_position.x - global_position.x)
	
		if direction > 0:
			texture.flip_h = true
			attack_animation_suffix = "_right"
			floor_ray.position.x = abs(ray_cast_default_position)
		elif direction < 0:
			texture.flip_h = false
			attack_animation_suffix = "_left"
			floor_ray.position.x = ray_cast_default_position

func kill_enemy() -> void:
	emit_signal("kill")
	animation.play("kill")
	get_tree().call_group("player_stats", "update_exp", enemy_exp)
	spawn_item_probability()
	
func spawn_item_probability() -> void:
	var random_number: int = randi() % 21
	if random_number <= 6:
		drop_bonus = 1
	elif random_number >= 7 and random_number <= 13:
		drop_bonus = 2
	else:
		drop_bonus = 3
		
	print("Multiplicador de drop: " + str(drop_bonus))
	var potential_drops = []
	
	for key in drop_list.keys():
		var rng: int = randi() % 100 + 1
		if rng <= drop_list[key][1] * drop_bonus:
			potential_drops.append(key)
			
	if potential_drops.size() > 0:
		var selected_key = potential_drops[randi() % potential_drops.size()]
		var item_texture: CompressedTexture2D = load(drop_list[selected_key][0])
		var item_info: Array = [
			drop_list[selected_key][0],
			drop_list[selected_key][2],
			drop_list[selected_key][3],
			drop_list[selected_key][4],
			1
	]
		spawn_physic_item(selected_key, item_texture, item_info)
	else:
		print("nenhum drop")
			
func spawn_physic_item(key: String, item_texture: CompressedTexture2D, item_info: Array):
	var physic_item_scene = load("res://scenes/env/physic_item.tscn")
	var item: PhysicItem = physic_item_scene.instantiate()
	get_parent().call_deferred("add_child", item)
	item.global_position = position
	item.update_item_info(key, item_texture, item_info)

func spawn_floating_text(type_sign: String, type: String, value: int) -> void:
	var text: FloatingText = floating_text.instantiate()
	print(text)
	text.global_position = global_position
	text.type = type
	text.value = value
	text.type_sign = type_sign
	
	get_tree().root.call_deferred("add_child", text)
