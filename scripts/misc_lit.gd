extends Control

class_name MiscLit

signal misc_lit_closed

@onready var literature_text = $Literature
@onready var close_button: TextureButton = $CloseButton

const OUTLINE = preload("res://assets/shaders/kingdom_outline.tres")

# Called when the node enters the scene tree for the first time.
func setup(text: Texture) -> void:
	literature_text.texture = text

func _ready() -> void:
	close_button.material = OUTLINE.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	misc_lit_closed.emit()


func _on_close_button_mouse_entered() -> void:
	close_button.material.set_shader_parameter("enabled", true)
	close_button.size = close_button.size * 1.1

func _on_close_button_mouse_exited() -> void:
	close_button.material.set_shader_parameter("enabled", false)
	close_button.size = close_button.size / 1.1
