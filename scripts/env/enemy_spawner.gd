extends Node2D
class_name EnemySpawner

@onready var spawn_timer: Timer = get_node("Timer")

var enemy_count: int = 0

@export var enemy_list: Array[Array] = []
@export var spawn_cooldown: float

@export var enemy_amount: int
@export var left_gap_position: int
@export var right_gap_position: int
@export var can_respawn: bool

func _ready() -> void:
	randomize()
	spawn_enemy()
	
func spawn_enemy() -> void:
	if enemy_count >= enemy_amount:
		return
	
	var random_number: int = randi() % 100 + 1
	for enemy in enemy_list:
		if enemy[2] <= random_number and enemy[3] >= random_number:
			var enemy_scene = load(enemy[0])
			var enemy_instance = enemy_scene.instantiate()
			enemy_instance.connect("kill", Callable(self, "on_enemy_killed"))
			enemy_instance.global_position = Vector2(spawn_position(), enemy[1])
			add_child(enemy_instance)
			enemy_count += 1
			break

func spawn_position() -> float:
	return randf_range(left_gap_position, right_gap_position)
	
func on_enemy_killed() -> void:
	enemy_count -= 1
	if can_respawn:
		spawn_timer.start(spawn_cooldown)

func _on_spawner_timeout() -> void:
	if can_respawn:
		spawn_enemy()
