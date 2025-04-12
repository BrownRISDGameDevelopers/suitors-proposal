extends TextureRect

@export var popup: CountryPopup = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popup.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	popup.show()


func _on_mouse_exited() -> void:
	popup.hide()
