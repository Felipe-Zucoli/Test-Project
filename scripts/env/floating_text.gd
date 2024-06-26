extends Label
class_name FloatingText


var value: int 
var mass: int = 20

var velocity: Vector2
var gravity: Vector2 = Vector2.UP

var type: String = ""
var type_sign: String = ""

@export var exp_color: Color
@export var mana_color: Color
@export var heal_color: Color
@export var damage_color: Color

func _ready() -> void:
	randomize()
	velocity = Vector2(
		randi_range(-10, 10), 
		-30
	
	)
	
	floating_text()
	
func floating_text() -> void:
	text = type_sign + str(value)
	match  type:
		"Exp":
			modulate = exp_color
			
		"Heal":
			modulate = heal_color
		
		"Mana":
			modulate = mana_color
			
		"Damage":
			modulate = damage_color
		
	interpolete()
	
	
func interpolete() -> void:
	var tween = get_tree().create_tween()
	var scale_tween: Tween = get_tree().create_tween()
	tween.tween_property(
		self,
		"modulate:a",
		1.0,
		0.3
	).set_delay(0.7).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	
	scale_tween.tween_property(
		self,
		"scale",
		Vector2 (1.0, 1.0),
		0.3
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	
	scale_tween.tween_property(
		self,
		"scale",
		Vector2(0.4, 0.4),
		1.0
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	
	await tween.finished
	queue_free()
	
func _process(delta: float) -> void:
	velocity += gravity * mass * delta
	position += velocity * delta
