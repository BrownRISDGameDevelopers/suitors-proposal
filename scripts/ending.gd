extends Control

class_name Ending

@onready var texture_rect: TextureRect = $TextureRect
@onready var play_again_button: TextureButton = $PlayAgain

const SUCCESS = preload("res://assets/endings/success.png")
const OVERTHROWN = preload("res://assets/endings/overthrown.png")
const ASSASSINATED = preload("res://assets/endings/assassinated.png")

const MAINMENU = preload("res://scenes/MainMenu.tscn")

const OUTLINE = preload("res://assets/shaders/kingdom_outline.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()

func setup() -> void:
	print("ending", Global.ending_val)
	play_again_button.material = OUTLINE.duplicate()

	if Global.ending_val == 1:
		texture_rect.texture = SUCCESS
	elif Global.ending_val == 2:
		texture_rect.texture = OVERTHROWN
	elif Global.ending_val == 3:
		texture_rect.texture = ASSASSINATED
	else:
		print("Invalid ending_val type:", Global.ending_val)
		return
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_packed(MAINMENU)


func _on_play_again_mouse_exited() -> void:
	play_again_button.material.set_shader_parameter("enabled", false)


func _on_play_again_mouse_entered() -> void:
	play_again_button.material.set_shader_parameter("enabled", true)
