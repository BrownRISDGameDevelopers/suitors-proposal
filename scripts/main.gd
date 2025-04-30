extends Control

#const SETTINGS = preload("res://scenes/Settings.tscn")
const MAIN_MENU = preload("res://scenes/MainMenu.tscn")
const LETTER_SCENE = preload("res://scenes/Letter.tscn")
const MAP = preload("res://scenes/Map.tscn")
const SEASON = preload("res://scenes/Season.tscn")

var OUR_KINGDOM = preload("res://resources/kingdoms/OurKingdom.tres")
const OUTLINE = preload("res://assets/shaders/kingdom_outline.tres")

# --- SEASONS
var Seasons = {
	"SUMMER": "summer",
	"FALL": "fall",
	"WINTER": "winter",
	"SPRING": "spring"
}
# --- SEASONAL LETTER TRACKERS & SEASONS
var seasons_order = [Seasons.SUMMER, Seasons.FALL, Seasons.WINTER, Seasons.SPRING] # List of all seasons_order, used to cycle through them.
var letters_per_season = {
	Seasons.SUMMER: 3,
	Seasons.FALL: 3,
	Seasons.WINTER: 2,
	Seasons.SPRING: 2
}
var letter_list = {Seasons.SUMMER: [], Seasons.FALL: [], Seasons.WINTER: [], Seasons.SPRING: []} # Values for all of these will be generated in _generate_letter_lists!

# --- ARCHIVED LETTERS
var archived_letters = []

# --- SUITOR LETTERS & FILLER LETTERS
var suitors = []
var advertisements = []

@onready var ui: Control = self

# Called wwhen the node enters the scene tree for the first time.
func _ready() -> void:
	# generate shader for pause button
	pause_button.material = OUTLINE.duplicate()

	# create dir of suitors
	var dir = DirAccess.open("res://resources/letters")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var letter = load("res://resources/letters/" + file_name)
				suitors.append(letter)
				# advertisements.append(letter) <-- filler msgs are now pngs
			file_name = dir.get_next()
		dir.list_dir_end()

	_generate_player_stats()
	_generate_letter_lists()
	_start_new_season()
	_update_letter_portrait()
#                                  ====================================
#                                  ====== PLAYER STAT GENERATION ======
#                                  ====================================	

func _generate_player_stats() -> void:
	OUR_KINGDOM.mana = int(round(randf_range(1, 6)))
	OUR_KINGDOM.military = int(round(randf_range(1, 6)))
	OUR_KINGDOM.population = int(round(randf_range(1, 6)))
	OUR_KINGDOM.morale = int(round(randf_range(1, 4)))
	OUR_KINGDOM.resource = int(round(randf_range(1, 6)))
	
#                                  =================================================
#                                  ====== GENERATE LETTERS / LETTER FUNCTIONS ======
#                                  =================================================


## _generate_letter_lists() --> Generates a list of 10 letters for each season.
## Global Variable(s): suitors - Array that holds all the suitors letter resources.
##                   advertisements - Array that holds all the filler letter resources.

func _generate_letter_lists() -> void:
	var available_suitors = suitors.duplicate(true)
	available_suitors.shuffle()
	# Generates all suitors letters.
	for season in seasons_order:
		for i in range(letters_per_season[season]):
			var suitor = available_suitors.pop_front()
			letter_list[season].append(suitor)
			
	print(letter_list)


## _INSTANTIATE_LETTER() --> Initializes letter resource to put onto screen.
## Parameters: letter - LetterResource object that will be initialized into
##                      a letter scene
## Global Variable(s): current_letter_file - Will be initialized as a letter scene, representing the 
##                                           latest letter initialized.
##                     current_letter_resource - Saved for _close_current_letter, so it can be saved
##                                               in the archive.

var current_letter_file
var current_letter_resource

func _instantiate_letter(letter: LetterResource) -> void:
	if current_letter_file:
		current_letter_file.queue_free()
	
	var letter_instance = LETTER_SCENE.instantiate()
	letter_instance.letter_closed.connect(_close_current_letter)
	ui.add_child(letter_instance)
	letter_instance.generate_content(current_season, letter)
	
	current_letter_file = letter_instance
	current_letter_resource = letter

func _close_current_letter() -> void:
	archived_letters.push_front(current_letter_resource)

## _UPDATE_LETTER_PORTRAIT() --> Updates current letter sprite based on the 
##                               amount of letters in current_letter_stack.
## Global Variable(s): letters_stack - references the LettersStack button in the Main Scene
##                     [blank]_LETTERS_[STATIC/HOVER] - sprite that shows MANY, MIDDLE, FEW
##                                                      amount of letters

@onready var letters_stack: BitmaskedTextureButton = $LettersStack
const MANY_LETTERS_HOVER = preload("res://assets/desk/Many letters hover.PNG")
const MANY_LETTERS_STATIC = preload("res://assets/desk/Many letters static.PNG")
const MIDDLE_LETTERS_HOVER = preload("res://assets/desk/Middle letters hover.PNG")
const MIDDLE_LETTERS_STATIC = preload("res://assets/desk/Middle letters static.PNG")
const FEW_LETTERS_HOVER = preload("res://assets/desk/Few letters hover.PNG")
const FEW_LETTERS_STATIC = preload("res://assets/desk/Few letters static.PNG")

func _update_letter_portrait() -> void:
	print(current_season)
	print(len(current_letter_stack))

	if len(current_letter_stack) <= 3:
		letters_stack.texture_normal = FEW_LETTERS_STATIC
		letters_stack.texture_hover = FEW_LETTERS_HOVER
		
	elif len(current_letter_stack) <= 6:
		letters_stack.texture_normal = MIDDLE_LETTERS_STATIC
		letters_stack.texture_hover = MIDDLE_LETTERS_HOVER
	
	else:
		letters_stack.texture_normal = MANY_LETTERS_STATIC
		letters_stack.texture_hover = MANY_LETTERS_HOVER

	
## _START_SEASON() --> Begins a season cycle based on seasons_order list.
## Global Variables: current_letter_stack - Array holding all the letters relevant to the current_season
##                   current_season - String representing current season.

var current_letter_stack = []
var current_season

func _start_new_season() -> void:
	current_season = seasons_order.pop_front()
	
	var season_instance = SEASON.instantiate()
	ui.add_child(season_instance)
	season_instance.play_transition_season(current_season)
	
	current_letter_stack.clear()
	
	current_letter_stack = letter_list[current_season]


## _END_SEASON() --> Ends a season cycle. In this context, will be called when 
##                   current_letter_stack is empty.
func _end_season() -> void:
	if not seasons_order:
		# end of game
		pass

	pass

#                                     ================================================
#                                     ====== BUTTON FUNCTIONS / SCENE SWITCHING ======
#                                     ================================================

func _on_map_pressed() -> void:
	var map_instance = MAP.instantiate()
	ui.add_child(map_instance)

## Checks if the letter button has been pressed, and loads the letter screen if true.
func _on_letters_stack_pressed() -> void:
	# Button Clicked Animation
	# var tween = create_tween()
	# tween.tween_property(letters_stack, "scale", Vector2(1, 1.01), 0.1)
	# tween.tween_property(letters_stack, "scale", Vector2(1, 1), 0.1)
	if not current_letter_stack:
		_end_season()
		_start_new_season()
	
	else:
		var letter_shown = current_letter_stack.pop_back()
		_update_letter_portrait()
		_instantiate_letter(letter_shown)
		

#                                  				   ========================
#                                                  ====== ANIMATIONS ======
#												   ========================

#@onready var map_button: TextureButton = %MapButton
#@onready var letters_button: TextureButton = %LettersButton
#
### Hover function for all items on desk, simply moves it up a few pixels.
#func _hover_on(sprite, pos) -> void:
	#sprite.set_position(pos + Vector2(0, -20))
#
### Hover off function for all items on desk, simply moves it down a few pixels.
#func _hover_off(sprite, pos) -> void:
	#sprite.set_position(pos - Vector2(0, -20))
#
## Map Hover
#func _on_map_button_mouse_entered() -> void:
	#_hover_on(map_button, map_button.position)
#
#func _on_map_button_mouse_exited() -> void:
	#_hover_off(map_button, map_button.position)
#
## Letter Hover
#func _on_letters_button_mouse_entered() -> void:
	#_hover_on(letters_button, letters_button.position)
#
#func _on_letters_button_mouse_exited() -> void:
	#_hover_off(letters_button, letters_button.position)

@onready var pause_button: BitmaskedTextureButton = $PauseButton

func _on_pause_button_mouse_entered() -> void:
	print("active")
	pause_button.material.set_shader_parameter("enabled", true)

func _on_pause_button_mouse_exited() -> void:
	print("inactive")
	pause_button.material.set_shader_parameter("enabled", false)
