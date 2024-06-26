extends Control

@onready var label_name: Label = $background/name
@onready var portrait: TextureRect = $background/portrait
@onready var text_label: RichTextLabel = $background/text_label
@onready var animation: AnimationPlayer = $animation
@onready var timer: Timer = $Timer

@export var wait_timer: float = 0.02

signal finished

var can_skip_dialog: bool = false

var dialog_size: int
var dialog_index: int = 0

var dialog_list: Dictionary = {
	"dialog": [
		"Ola, aventureiro!, Em que posso te ajudar?",
		"entendo, aventureiro!",
	],
	"portrait": null,
	"name": ""
}

func _ready() -> void:
	animation.play("fade_in")
	dialog_size = dialog_list["dialog"].size()
	
	if dialog_list["portrait"] != null:
		label_name.text = dialog_list["name"]
		text_label.rect_position = Vector2(47, 24)
		portrait.texture = load(dialog_list["portrait"])
		
	show_dialog()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and can_skip_dialog:
		can_skip_dialog = false
		show_dialog()
		
		
func show_dialog() -> void:
	if dialog_index == dialog_size:
		animation.play("fade_out")
		await animation.animation_finished
		emit_signal("finished")
		queue_free()
		return
		
	text_label.visible_characters = 0
	text_label.text = dialog_list["dialog"][dialog_index]
	
	dialog_index += 1
	
	while text_label.visible_characters < len(text_label.text):
		text_label.visible_characters += 1
		timer.start(wait_timer)
		await timer.timeout
		
	can_skip_dialog = true
