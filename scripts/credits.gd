extends NinePatchRect

class_name Credits

@onready var close_button: TextureButton = $ClippingContainer/CloseButton

var CLOSED_POS = Vector2(72, 1100.0)
var OPENED_POS

var CLOSED_SIZE
var OPENED_SIZE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OPENED_SIZE = size
	size = Vector2(0, size.y)
	CLOSED_SIZE = size
	OPENED_POS = position
	position = CLOSED_POS
	
	print(CLOSED_POS, OPENED_POS)
	print(CLOSED_SIZE, OPENED_SIZE)
	pass # Replace with function body.

func open() -> void:
	print("opening")
	var tween = create_tween()
	print("pos")
	tween.tween_property(self, "position", OPENED_POS, 0.5)
	print("size")
	tween.tween_property(self, "size", OPENED_SIZE, 0.5)
	
func close() -> void:
	var tween = create_tween()
	tween.tween_property(self, "size", CLOSED_SIZE, 0.5)
	tween.tween_property(self, "position", CLOSED_POS, 0.5)
	await tween.finished
	
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_close_button_pressed() -> void:
	close()


func _on_close_button_mouse_entered() -> void:
	close_button.material.set_shader_parameter("enabled", true)


func _on_close_button_mouse_exited() -> void:
	close_button.material.set_shader_parameter("enabled", false)
