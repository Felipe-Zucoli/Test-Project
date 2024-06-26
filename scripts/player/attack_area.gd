extends Area2D

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_attack_area_entered"))

func _on_attack_area_entered(area: Area2D) -> void:
	print("Attack area entered: " + str(area))
