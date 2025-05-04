extends Control

@onready var volume_slider: HSlider = $VolumeSlider
@onready var resume_button: TextureButton = $Resume
@onready var quit_button: TextureButton = $Quit

const OUTLINE = preload("res://assets/shaders/kingdom_outline.tres")

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_resume_mouse_entered() -> void:
	pass # Replace with function body.


func _on_resume_mouse_exited() -> void:
	pass # Replace with function body.


func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_quit_mouse_entered() -> void:
	pass # Replace with function body.


func _on_quit_mouse_exited() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	# Called when the node enters the scene tree for the first time.
	# Set the volume slider to the current volume
	var current_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	volume_slider.value = current_volume
