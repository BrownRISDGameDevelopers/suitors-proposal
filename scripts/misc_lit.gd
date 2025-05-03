extends Control

class_name MiscLit

@onready var literature_text = $Literature

# Called when the node enters the scene tree for the first time.
func setup(text: Texture) -> void:
	literature_text.texture = text

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
