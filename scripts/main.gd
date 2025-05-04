extends Control

#const SETTINGS = preload("res://scenes/Settings.tscn")
const MAIN_MENU = preload("res://scenes/MainMenu.tscn")
const LETTER_SCENE = preload("res://scenes/Letter.tscn")
const MAP = preload("res://scenes/Map.tscn")
const SEASON = preload("res://scenes/Season.tscn")
const MISC_LIT = preload("res://scenes/MiscLit.tscn")

var OUR_KINGDOM = preload("res://resources/kingdoms/OurKingdom.tres")
const OUTLINE = preload("res://assets/shaders/kingdom_outline.tres")

var game_should_end = false
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
	Seasons.SUMMER: 4,
	Seasons.FALL: 3,
	Seasons.WINTER: 3,
	Seasons.SPRING: 0
}

# --- ARCHIVED LETTERS
var archived_letters = []

# --- SUITOR LETTERS & FILLER LETTERS
var suitors = []
var letter_list = {Seasons.SUMMER: [], Seasons.FALL: [], Seasons.WINTER: [], Seasons.SPRING: []} # Values for all of these will be generated in _generate_letter_lists!
var misc_lits = {Seasons.SUMMER: [], Seasons.FALL: [], Seasons.WINTER: [], Seasons.SPRING: []}

@onready var ui: Control = $UI

#								  ====================================
#								  ====== PLAYER STAT GENERATION ======
#								  ====================================	

func _generate_player_stats() -> void:
	var starting_points = randi_range(11, 13)

	OUR_KINGDOM.mana = 1
	OUR_KINGDOM.military = 1
	OUR_KINGDOM.population = 1
	OUR_KINGDOM.morale = 1
	OUR_KINGDOM.resource = 1

	for i in range(starting_points):
		var stat = randi_range(0, 4) # Changed to 0-4 since there are 5 stats
		
		# Try each stat until we find one that's not maxed
		for j in range(5): # Try all 5 stats at most once each
			match stat:
				0:
					if OUR_KINGDOM.mana < 6:
						OUR_KINGDOM.mana += 1
						break
				1:
					if OUR_KINGDOM.military < 6:
						OUR_KINGDOM.military += 1
						break
				2:
					if OUR_KINGDOM.population < 6:
						OUR_KINGDOM.population += 1
						break
				3:
					if OUR_KINGDOM.morale < 6:
						OUR_KINGDOM.morale += 1
						break
				4:
					if OUR_KINGDOM.resource < 6:
						OUR_KINGDOM.resource += 1
						break
			stat = (stat + 1) % 5
	
	print("final stats: ", OUR_KINGDOM.mana, OUR_KINGDOM.military, OUR_KINGDOM.population, OUR_KINGDOM.morale, OUR_KINGDOM.resource)
	
#								  =================================================
#								  ====== GENERATE LETTERS / LETTER FUNCTIONS ======
#								  =================================================


func load_resources() -> void:
	var letters_dir = DirAccess.open("res://resources/letters")
	var misc_lit_dir = DirAccess.open("res://resources/misc_lit")

	if not letters_dir:
		print("Error: Could not open letters directory.")
		return

	if not misc_lit_dir:
		print("Error: Could not open misc_lit directory.")
		return

	letters_dir.list_dir_begin()
	var letter_file = letters_dir.get_next()
	while letter_file != "":
		if letter_file.ends_with(".tres"):
			var letter = load("res://resources/letters/" + letter_file)
			suitors.append(letter)
		letter_file = letters_dir.get_next()
	letters_dir.list_dir_end()

	misc_lit_dir.list_dir_begin()
	var misc_lit_file = misc_lit_dir.get_next()
	while misc_lit_file != "":
		if misc_lit_file.ends_with(".tres"):
			var misc_lit = load("res://resources/misc_lit/" + misc_lit_file) as MiscLitResource

			for lit in misc_lit.literatures:
				misc_lits[misc_lit.season].append(lit)
		misc_lit_file = misc_lit_dir.get_next()
	misc_lit_dir.list_dir_end()
	

## _generate_letter_lists() --> Generates a list of 10 letters for each season.
## Global Variable(s): suitors - Array that holds all the suitors letter resources.
##				   misc_lits - Array that holds all the filler letter resources.

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
##					  a letter scene
## Global Variable(s): current_letter_file - Will be initialized as a letter scene, representing the 
##										   latest letter initialized.
##					 current_letter_resource - Saved for _close_current_letter, so it can be saved
##											   in the archive.

var current_letter_file: Letter
var current_letter_resource

func _instantiate_letter(letter: LetterResource) -> void:
	if current_letter_file:
		current_letter_file.queue_free()
	
	var letter_instance = LETTER_SCENE.instantiate() as Letter
	letter_instance.letter_closed.connect(_close_current_letter)
	ui.add_child(letter_instance)
	letter_instance.generate_content(current_season, letter)
	
	current_letter_file = letter_instance
	current_letter_resource = letter

func _close_current_letter() -> void:
	archived_letters.push_front(current_letter_resource)

## _UPDATE_LETTER_PORTRAIT() --> Updates current letter sprite based on the 
##							   amount of letters in current_letter_stack.
## Global Variable(s): letters_stack - references the LettersStack button in the Main Scene
##					 [blank]_LETTERS_[STATIC/HOVER] - sprite that shows MANY, MIDDLE, FEW
##													  amount of letters

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
##				   current_season - String representing current season.
@onready var curr_season_banner: TextureRect = $CurrentSeason

var current_letter_stack = []
var current_season

var seasonal_banners = {
	Seasons.SUMMER: preload("res://assets/ui/seasons_indicators/summer.png"),
	Seasons.FALL: preload("res://assets/ui/seasons_indicators/autumn.png"),
	Seasons.WINTER: preload("res://assets/ui/seasons_indicators/winter.png"),
	Seasons.SPRING: preload("res://assets/ui/seasons_indicators/spring.png")
}

func _start_new_season() -> void:
	disable_table()

	current_season = seasons_order.pop_front()
	
	var season_instance = SEASON.instantiate()
	ui.add_child(season_instance)

	curr_season_banner.texture = seasonal_banners[current_season]
	
	season_instance.play_transition_season(current_season)
	
	current_letter_stack.clear()
	
	current_letter_stack = letter_list[current_season]

	enable_table()


## _END_SEASON() --> Ends a season cycle. In this context, will be called when 
##				   current_letter_stack is empty.
func _end_season() -> void:
	if not seasons_order:
		# end of game
		pass

	pass

#									 ================================================
#									 ====== BUTTON FUNCTIONS / SCENE SWITCHING ======
#									 ================================================
@onready var map_button: BitmaskedTextureButton = $Map
@onready var archive_button: BitmaskedTextureButton = $Archive
@onready var news_button: BitmaskedTextureButton = $News

@onready var tab: TextureRect = $Banner
var map_tab = preload("res://assets/desk/Map tab.png")
var archive_tab = preload("res://assets/desk/Archive tab.png")
var inbox_tab = preload("res://assets/desk/Inbox tab.png")

func disable_table() -> void:
	$Map.disabled = true
	$LettersStack.disabled = true
	$Archive.disabled = true
	$News.disabled = true

func enable_table() -> void:
	$Map.disabled = false
	$LettersStack.disabled = false
	$Archive.disabled = false
	$News.disabled = false

func show_banner(new_tab) -> Tween:
	tab.show()
	tab.position = Vector2(-600, 132)
	tab.texture = new_tab
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(tab, "position", Vector2(0, 132), .5)
	return tween

func hide_banner() -> Tween:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(tab, "position", Vector2(-600, 132), .5)
	tween.tween_callback(tab.hide)
	return tween

@onready var map_instance = $UI/Map
@onready var map_close_button: BitmaskedTextureButton = $UI/Map/CloseButton

func hide_map() -> void:
	if not game_should_end:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_EXPO)
		tween.tween_property(map_instance, "position", Vector2(216.0, 1091.5), 0.5)
		tween.tween_callback(map_instance.hide)
		
		# await tween.finished

		await hide_banner().finished
		
		enable_table()

func _on_map_pressed() -> void:
	disable_table()

	map_instance.position = Vector2(216.0, 1091.0)

	show_banner(map_tab)

	map_instance.show()

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(map_instance, "position", Vector2(216.0, 121.5), 0.5)

## Checks if the letter button has been pressed, and loads the letter screen if true.
func hide_letter() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(current_letter_file, "position", Vector2(0, 1080), 0.5)
	tween.tween_callback(current_letter_file.queue_free)
	await hide_banner().finished
	enable_table()


func _on_letters_stack_pressed() -> void:
	# Button Clicked Animation
	# var tween = create_tween()
	# tween.tween_property(letters_stack, "scale", Vector2(1, 1.01), 0.1)
	# tween.tween_property(letters_stack, "scale", Vector2(1, 1), 0.1)
	if not current_letter_stack:
		pass
	
	else:
		disable_table()
		var letter_shown = current_letter_stack.pop_back()
		_update_letter_portrait()
		_instantiate_letter(letter_shown)

		current_letter_file.position = Vector2(0, 1080)
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_EXPO)
		tween.tween_property(current_letter_file, "position", Vector2(0, 0), 0.5)
		show_banner(inbox_tab)
		current_letter_file.letter_closed.connect(hide_letter)
		

func hide_archive() -> void:
	enable_table()
	pass

func _on_archive_pressed() -> void:
	pass

var misc_lit_inst

func hide_news() -> void:
	var tween = create_tween()
	tween.tween_property(misc_lit_inst, "position", Vector2(0, 1080), 0.5)
	tween.tween_callback(misc_lit_inst.queue_free)
	await hide_banner().finished
	enable_table()

func _on_news_pressed() -> void:
	disable_table()
	print("PRESSED")

	var next_lit = misc_lits[current_season].pop_front()
	print("next lit:", next_lit)
	if not next_lit:
		enable_table()
		return

	misc_lit_inst = MISC_LIT.instantiate()
	ui.add_child(misc_lit_inst)
	misc_lit_inst.setup(next_lit)
	misc_lit_inst.position = Vector2(0, 1080)
	misc_lit_inst.misc_lit_closed.connect(hide_news)

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(misc_lit_inst, "position", Vector2(0, 0), 0.5)
	
	show_banner(inbox_tab)

#								  				   ========================
#												  ====== ANIMATIONS ======
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
@onready var season_change_button: TextureButton = $SeasonChangeButton

func _on_pause_button_mouse_entered() -> void:
	print("active")
	pause_button.material.set_shader_parameter("enabled", true)

func _on_pause_button_mouse_exited() -> void:
	print("inactive")
	pause_button.material.set_shader_parameter("enabled", false)

# EVENT HANDLING

# Called wwhen the node enters the scene tree for the first time.
func _ready() -> void:
	# generate shader for pause button
	pause_button.material = OUTLINE.duplicate()

	map_close_button.connect("pressed", hide_map)

	# create dir of suitors
	

	tab.hide()

	load_resources()
	_generate_player_stats()
	_generate_letter_lists()
	_start_new_season()
	_update_letter_portrait()
	

func _on_season_change_button_pressed() -> void:
	if (current_season == "spring") and not current_letter_stack:
		game_should_end = true
		disable_table()

		map_instance.position = Vector2(216.0, 1091.0)

		show_banner(map_tab)

		map_instance.show()

		var tween = create_tween()
		tween.set_trans(Tween.TRANS_EXPO)
		tween.tween_property(map_instance, "position", Vector2(216.0, 121.5), 0.5)
	else:
		_end_season()
		_start_new_season()

func _process(delta: float) -> void:
	#season_change_button.show()
	#season_change_button.disabled = false
	if not current_letter_stack and not misc_lits[current_season]:
		season_change_button.show()
		season_change_button.disabled = false
	else:
		season_change_button.hide()
		season_change_button.disabled = true


func _on_map_suitor_chosen(suitor: int, otherKingdom: Kingdom) -> void:
	if game_should_end:
		# picked an assassin
		if (otherKingdom.name == "ForestKingdom" && suitor == 1) or (otherKingdom.name == "CloudKingdom" && suitor == 1) or (otherKingdom.name == "UnderwaterKingdom" && suitor == 2):
			pass
		# didn't pick someone who complements your kingdom
		elif (OUR_KINGDOM.mana + otherKingdom.mana < 5) or (OUR_KINGDOM.military + otherKingdom.military < 5) or (OUR_KINGDOM.morale + otherKingdom.morale < 5) or (OUR_KINGDOM.population + otherKingdom.population < 5) or (OUR_KINGDOM.resource + otherKingdom.resource < 5):
			pass
		# picked a good suitor!
		else:
			pass
	else:
		pass
