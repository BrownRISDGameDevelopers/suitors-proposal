extends TextureButton

@export var kingdom: Kingdom = null
@onready var popup: CountryPopup = $"../Popup"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popup.hide()
	var image = texture_normal.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	popup.show()
	popup.kingdom = kingdom

func _on_mouse_exited() -> void:
	popup.hide()
