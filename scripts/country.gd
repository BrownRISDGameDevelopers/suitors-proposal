extends TextureRect

@export var kingdom: Kingdom = null
@onready var popup: CountryPopup = $"../Popup"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popup.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	popup.show()
	popup.kingdom = kingdom


func _on_mouse_exited() -> void:
	popup.hide()
