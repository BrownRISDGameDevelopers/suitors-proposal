extends Node2D

const SETTINGS = preload("res://scenes/Settings.tscn")
const MAIN_MENU = preload("res://scenes/MainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#                       ====== BUTTON FUNCTIONS / SCENE SWITCHING ======

func _on_map_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Map.tscn")

func _on_letters_button_pressed() -> void:
	var letter_scene = preload("res://scenes/Letter.tscn").instantiate()
	var ui: CanvasLayer = $UI
	ui.add_child(letter_scene)

#                       ====== ANIMATIONS ======

var tween
# Hover function for all items on desk.
func _hover_on(sprite) -> void:
	tween = create_tween()
	var button_location = sprite.position()
	# tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite, "position", button_location + Vector2(0, 50),  1)

func _hover_off() -> void:
	if tween and tween.is_running():
		tween.kill()

func _on_map_button_mouse_entered() -> void:
	var map_button = %MapButton
	_hover_on(map_button) # Replace with function body.

func _on_map_button_mouse_exited() -> void:
	_hover_off()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#testEsc()
#
#func pauseGame() -> void:
	#var settingsScreen = SETTINGS.instantiate()
	#add_child(settingsScreen)

#func testEsc():
	#if Input.is_action_just_pressed("Escape") and get_tree().paused == false:
		#pauseGame()
	#elif Input.is_action_just_pressed("Escape") and get_tree().paused == true:
		#pass

#func _on_settings_button_pressed() -> void:
	#print("pres'd")
	#pauseGame()
