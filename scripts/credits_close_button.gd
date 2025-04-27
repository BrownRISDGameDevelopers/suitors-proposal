extends BitmaskedTextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	material.set_shader_parameter("enabled", true)
	
	
func _on_mouse_exited() -> void:
	material.set_shader_parameter("enabled", false)
