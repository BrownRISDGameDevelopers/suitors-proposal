extends BitmaskedTextureButton

class_name MapPortrait

@export var letter_resource: LetterResource
@onready var popup: CountryPopup = $"../../Popup"

const OUTLINE = preload("res://assets/shaders/kingdom_outline.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material = OUTLINE.duplicate()
	material.set_shader_parameter("minLineWidth", 20)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func reset() -> void:
	material.queue_free()
	_ready()

func _on_mouse_entered() -> void:
	material.set_shader_parameter("enabled", true)
	popup.suitor = letter_resource
	
func _on_mouse_exited() -> void:
	material.set_shader_parameter("enabled", false)
	popup.suitor = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
