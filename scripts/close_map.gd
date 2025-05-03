extends BitmaskedTextureButton

const OUTLINE = preload("res://assets/shaders/kingdom_outline.tres")

signal map_closed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material = OUTLINE.duplicate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_exited() -> void:
	material.set_shader_parameter("enabled", false)


func _on_mouse_entered() -> void:
	material.set_shader_parameter("enabled", true)


func _on_pressed() -> void:
	map_closed.emit()
