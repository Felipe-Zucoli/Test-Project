extends Sprite2D
class_name  EnemyTexture

@export var animation_path: NodePath
@onready var animation = get_node(animation_path) as AnimationPlayer

@export var enemy_path: NodePath
@onready var enemy = get_node(enemy_path) as CharacterBody2D

@export var attack_area_collision_path: NodePath
@onready var attack_area_collision = get_node(attack_area_collision_path) as CollisionShape2D

func animate(velocity: Vector2) -> void:
	pass

func _on_animation_finished(_anim_name: StringName) -> void:
	pass
