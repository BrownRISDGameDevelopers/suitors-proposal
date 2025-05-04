extends TextureButton

@export var kingdom: Kingdom
@onready var popup: CountryPopup = $"../Popup"

const OUTLINE = preload("res://assets/shaders/kingdom_outline.tres")
const BORDER_OFFSET = Vector2(2, 2)

var base_position: Vector2
var current_tween
#@onready var shader_mat := material as ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popup.hide()
	popup.update_stats(kingdom)
	base_position = position
	
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
	print("setting kingdom to", kingdom.name)
	popup.kingdom = kingdom

	z_index = 5
	
	current_tween = create_tween()
	current_tween.tween_property(self, "position", base_position - BORDER_OFFSET, 0.1)
	
	material.set_shader_parameter("enabled", true)
	
	
func _on_mouse_exited() -> void:
	var tween = create_tween()
	
	material.set_shader_parameter("enabled", false)
	z_index = 1
	popup.hide()
	
	current_tween = create_tween()
	current_tween.tween_property(self, "position", base_position + BORDER_OFFSET, 0.1)
