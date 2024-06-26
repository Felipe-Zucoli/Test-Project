extends Area2D
class_name CollisionArea

@onready var timer = get_node("Timer")

@export var health: int
@export var invulnerability_timer: float

@export var enemy_bar_path: NodePath
@onready var enemy_bar = get_node(enemy_bar_path) as Control

@export var enemy_path: NodePath
@onready var enemy = get_node(enemy_path) as CharacterBody2D

func _ready() -> void:
	enemy_bar.init_bar(health)

func _on_area_entered(area: Area2D) -> void:
	if not area.name  == "AttackArea" or area.name == "spell_area":
		return
		
	if area.get_parent() is Player:
		var player_stats: Node = area.get_parent().get_node("Stats")
		var player_attack: int = player_stats.base_attack + player_stats.bonus_attack
		update_healt(player_attack)
	elif area is FireSpell:
		update_healt(area.spell_damage)
		set_deferred("monitoring", false)
		timer.start(invulnerability_timer)

func update_healt(damage: int) -> void:
	health -= damage
	enemy_bar.update_bar(health)
	enemy.spawn_floating_text("-", "Damage", damage)
	if health <= 0:
		enemy.can_die = true
		return
	
	enemy.can_hit = true




func _on_timer_timeout() -> void:
	set_deferred("monitoring", true)
