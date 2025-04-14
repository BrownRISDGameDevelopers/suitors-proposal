extends Node2D

const SETTINGS = preload("res://scenes/Settings.tscn")
const MAIN_MENU = preload("res://scenes/MainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
#                       ====== GENERATE LETTERS ======

var summer = "summer"
var fall = "fall"
var winter = "winter"
var spring = "spring"

var letter_list = {summer: [], fall: [], winter: [], spring: []}
var seasons = [summer, fall, winter, spring] # empty this out until empty, then check if empty: do something?

## Generates a list of 10 letters based on the current season.

## Parameters: season - one of the seasons (must be sum, fall, wint, or spring ONLY)
## Returns: Array of randomized letters.

func _generate_letter_list(season) -> Array:
	# pseudo code:
	# check season:
	# if "season" 
	return []

#                       ====== BUTTON FUNCTIONS / SCENE SWITCHING ======

# Checks if the map button has been pressed, and loads the map screen if true.
func _on_map_button_pressed() -> void:
	var map_scene = preload("res://scenes/Map.tscn").instantiete()
	var ui: CanvasLayer = $UI
	ui.add_child(map_scene)

# Checks if the letter button has been pressed, and loads the letter screen if true.
func _on_letters_button_pressed() -> void:
	var letter_scene = preload("res://scenes/SuitorLetter.tscn").instantiate()
	var ui: CanvasLayer = $UI
	ui.add_child(letter_scene)

#                       ====== ANIMATIONS ======

@onready var map_button: TextureButton = %MapButton
@onready var letters_button: TextureButton = %LettersButton

# Hover function for all items on desk, simply moves it up a few pixels!
func _hover_on(sprite, pos) -> void:
	sprite.set_position(pos + Vector2(0, -20))

# Hover off function for all items on desk, simply moves it down a few pixels!
func _hover_off(sprite, pos) -> void:
	sprite.set_position(pos - Vector2(0, -20))

# Map Hover
func _on_map_button_mouse_entered() -> String:
	_hover_on(map_button, map_button.position)
	return "hovered"# Replace with function body.

func _on_map_button_mouse_exited() -> void:
	_hover_off(map_button, map_button.position)

# Letter Hover
func _on_letters_button_mouse_entered() -> void:
	_hover_on(letters_button, letters_button.position)

func _on_letters_button_mouse_exited() -> void:
	_hover_off(letters_button, letters_button.position)
