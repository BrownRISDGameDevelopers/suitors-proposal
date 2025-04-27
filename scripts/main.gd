extends Control

#const SETTINGS = preload("res://scenes/Settings.tscn")
const MAIN_MENU = preload("res://scenes/MainMenu.tscn")
const LETTER_SCENE = preload("res://scenes/Letter.tscn")
const MAP = preload("res://scenes/Map.tscn")
const SEASON = preload("res://scenes/Season.tscn")

var our_kingdom = preload("res://resources/kingdoms/OurKingdom.tres")

@onready var ui: Control = $UI

# Called wwhen the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_player_stats()
	_generate_letter_lists()
	_start_new_season()
#                                  ====================================
#                                  ====== PLAYER STAT GENERATION ======
#                                  ====================================	

func _generate_player_stats() -> void:
	
	var stat_max
	our_kingdom.mana = int(round(randf_range(1, 6)))
	our_kingdom.military = int(round(randf_range(1, 6)))
	our_kingdom.population = int(round(randf_range(1, 6)))
	our_kingdom.morale = int(round(randf_range(1, 4)))
	our_kingdom.resource = int(round(randf_range(1, 6)))
	
#                                  =================================================
#                                  ====== GENERATE LETTERS / LETTER FUNCTIONS ======
#                                  =================================================

# --- SEASONS
const summer = "summer"
const fall = "fall"
const winter = "winter"
const spring = "spring"

# --- SEASONAL LETTER TRACKERS & SEASONS
var letter_list = {summer: [], fall: [], winter: [], spring: []} # Values for all of these will be generated in _generate_letter_lists!
var seasons = [summer, fall, winter, spring]

# --- ARCHIVED LETTERS
var archived_letters = []

## _generate_letter_lists() --> Generates a list of 10 letters for each season.
## Global Variable(s): suitors - Array that holds all the suitors letter resources.
##                   advertisements - Array that holds all the filler letter resources.

# --- SUITOR LETTERS & FILLER LETTERS
var suitors = ["res://resources/letters/Dwarf_Techbro_Warlord_Letter.tres", "res://resources/letters/Vampire_King_Letter.tres",
"res://resources/letters/Skeleton_General_Letter.tres", "res://resources/letters/Dwarf_Councilwoman_Letter.tres", "res://resources/letters/Letter1.tres",
"res://resources/letters/Letter2.tres"]
var advertisements = []

func _generate_letter_lists() -> void:
	
	var suitors_to_visit = suitors.duplicate(true)
	# Generates all summer suitor letters.
	for i in range(2):
		suitors_to_visit.shuffle()
		var suitor_to_generate = suitors_to_visit.pop_front()
		letter_list[summer].append(suitor_to_generate)	


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
	
	if len(current_letter_stack) <= 3:
		letters_stack.texture_normal = FEW_LETTERS_STATIC
		letters_stack.texture_hover = FEW_LETTERS_HOVER
		
	elif len(current_letter_stack) <= 6:
		letters_stack.texture_normal = MIDDLE_LETTERS_STATIC
		letters_stack.texture_hover = MIDDLE_LETTERS_HOVER
	
	else:
		letters_stack.texture_normal = MANY_LETTERS_STATIC
		letters_stack.texture_hover = MANY_LETTERS_HOVER

	
## _START_SEASON() --> Begins a season cycle based on seasons list.
## Global Variables: current_letter_stack - Array holding all the letters relevant to the current_season
##                   current_season - String representing current season.

var current_letter_stack = []
var current_season = ""

func _start_new_season() -> void:
	
	current_season = seasons.pop_front()
	
	var season_instance = SEASON.instantiate()
	ui.add_child(season_instance)
	season_instance.play_transition_season(current_season)
	
	current_letter_stack.clear()
	
	current_letter_stack = letter_list[current_season]	


## _END_SEASON() --> Ends a season cycle. In this context, will be called when 
##                   current_letter_stack is empty.
func _end_season() -> void:
	
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
	var tween = create_tween()
	tween.tween_property(letters_stack, "scale", Vector2(1, 1.01), 0.1)
	tween.tween_property(letters_stack, "scale", Vector2(1, 1), 0.1)
	
	if not current_letter_stack:
		_end_season()
		_start_new_season()
	
	else:	
		var letter_shown = current_letter_stack.pop_back()
		_update_letter_portrait()
		_instantiate_letter(load(letter_shown))
		

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
