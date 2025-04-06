extends Control

@onready var scroll: TextureRect = $Scroll
@onready var previous_season: TextureRect = $PreviousSeason
@onready var next_season: TextureRect = $NextSeason

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(previous_season, "self_modulate", Color("ffffff", 0), 1.25)
	tween.tween_callback(previous_season.queue_free)
	
	tween.tween_interval(1.25)
	
	tween.tween_property(scroll, "position", Vector2(-960, -540), 0.25)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
