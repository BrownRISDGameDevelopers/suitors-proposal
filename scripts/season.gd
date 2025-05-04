extends Control

@onready var scroll: TextureRect = $Scroll
@onready var previous_season: TextureRect = $PreviousSeason
@onready var next_season: TextureRect = $NextSeason

const SUMMER = preload("res://assets/seasons/backgrounds/summer.png")
const AUTUMN = preload("res://assets/seasons/backgrounds/autumn.png")
const WINTER = preload("res://assets/seasons/backgrounds/winter.png")
const SPRING = preload("res://assets/seasons/backgrounds/spring.png")

const SUMMER_SCROLL = preload("res://assets/seasons/scrolls/summer.png")
const AUTUMN_SCROLL = preload("res://assets/seasons/scrolls/autumn.png")
const WINTER_SCROLL = preload("res://assets/seasons/scrolls/winter.png")
const SPRING_SCROLL = preload("res://assets/seasons/scrolls/spring.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_transition_season("fall")

## _TRANSITION_SEASON() --> Plays transition between seasons.
func play_transition_season(current_season: String) -> void:
	var interval
	
	if current_season == "summer":
		previous_season.texture = SUMMER
		next_season.texture = SUMMER
		scroll.texture = SUMMER_SCROLL
		
		interval = 0
		
	elif current_season == "fall":
		previous_season.texture = SUMMER
		next_season.texture = AUTUMN
		scroll.texture = AUTUMN_SCROLL
		
		interval = 1.25
		
	elif current_season == "winter":
		previous_season.texture = AUTUMN
		next_season.texture = WINTER
		scroll.texture = WINTER_SCROLL
		
		interval = 1.25
		
	else:
		previous_season.texture = WINTER
		next_season.texture = SPRING
		scroll.texture = SPRING_SCROLL
		
		interval = 1.25
	
	await get_tree().create_timer(1.5).timeout
	
	var tween = get_tree().create_tween()
	
	# Transition between seasons
	tween.tween_property(previous_season, "self_modulate", Color("ffffff", 0), 1.25)
	tween.tween_callback(previous_season.queue_free)
	
	tween.tween_interval(interval)
	
	# Scroll Transition
	tween.tween_property(scroll, "position", Vector2(-960, -540), 1)
	
	tween.tween_interval(2)
	
	# Season transition off-screen
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 3)
	
	await tween.finished
	queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
