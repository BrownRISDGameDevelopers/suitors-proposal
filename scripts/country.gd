extends TextureButton

@export var kingdom: Kingdom = null
@onready var popup: CountryPopup = $"../Popup"

const OUTLINE = preload("res://assets/shaders/outline.tres")
const BORDER_OFFSET = Vector2(3, 3)
#@onready var shader_mat := material as ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popup.hide()
	var image = texture_normal.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap
	material = OUTLINE.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	popup.show()
	popup.kingdom = kingdom

	z_index = 2
	position -= BORDER_OFFSET
	material.set_shader_parameter("enabled", true)
	
	
func _on_mouse_exited() -> void:
	var tween = create_tween()
	
	position += BORDER_OFFSET
	material.set_shader_parameter("enabled", false)
	z_index = 1
	
	popup.hide()
