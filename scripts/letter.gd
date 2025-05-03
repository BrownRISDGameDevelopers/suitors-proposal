extends Control

class_name Letter

signal letter_closed

@onready var letter: TextureRect = $Letter
@onready var greeting: Label = $Letter/MarginContainer/VBoxContainer/Greeting
@onready var content: RichTextLabel = $Letter/MarginContainer/VBoxContainer/Content
@onready var signoff: Label = $Letter/MarginContainer/VBoxContainer/Signoff
@onready var suitor_portrait: TextureRect = $SuitorPortrait
@onready var close_button: TextureButton = $Letter/CloseButton
@onready var ref_border: TextureRect = $REFERENCE_BORDER
const CLOSE_OUTLINE = preload("res://assets/shaders/close_outline.tres")

var resource: LetterResource
var scroll_speed

var MIN_POS = -413.0
var MAX_POS = 518.0

var SCROLL_SENSITIVITY := 200.0
var SCROLL_FRICTION := 5.0
var SCROLL_VELOCITY := 0.0

func generate_content(season: String, letter_resource: LetterResource) -> void:
	resource = letter_resource
	greeting.text = resource.greeting
	signoff.text = resource.signoff

	_setup_proposal_layout()
	_setup_seasonal_content(season)

	content.bbcode_enabled = true

func _setup_proposal_layout() -> void:
	var letter_position = letter.position
	var portrait_position = suitor_portrait.position

	# suitor_portrait.texture = resource.portrait
	# letter.position = letter_position + Vector2(-225, 0)
	# suitor_portrait.position = portrait_position + Vector2(600, -150)

## _SETUP_SEASONAL_CONTENT() --> Based on season, generates content of letter.

func _setup_seasonal_content(season: String) -> void:
	var version_text
	var clickable_content
	
	match season:
		"summer": version_text = resource.summerVersion
		"fall": version_text = resource.fallVersion
		"winter": version_text = resource.winterVersion
		"spring": version_text = resource.springVersion
		_: version_text = ""

	match season:
		"summer": clickable_content = resource.summerClickableContent
		"fall": clickable_content = resource.fallClickableContent
		"winter": clickable_content = resource.winterClickableContent
		"spring": clickable_content = resource.springClickableContent
		_: clickable_content = []

	for text_entry in clickable_content:
		var base_text = text_entry.text
		var stats = ",".join(text_entry.revealedStat)
		var url_code = "[url=" + stats + "]" + base_text + "[/url]"
		# url_code = "[hint=Reveals " + stats.to_upper() + " for " + resource.kingdom.name.to_upper() + "]" + url_code + "[/hint]"
		version_text = version_text.replace(base_text, url_code)

	content.text = version_text

func _ready() -> void:
	if Engine.is_editor_hint():
		var sample_letter: LetterResource = load("res://resources/letters/Letter1.tres")
		generate_content("summer", sample_letter)

	ref_border.queue_free()
	close_button.material = CLOSE_OUTLINE.duplicate()

# BUTTONS

func _on_close_button_pressed() -> void:
	letter_closed.emit()

func _on_content_meta_clicked(meta: Variant) -> void:
	print(meta)
	var parsed = meta.split(",")
	for stat in parsed:
		resource.kingdom[stat + "Known"] = true
		print(stat + " is known")

	print(resource.kingdom.manaKnown, resource.kingdom.militaryKnown, resource.kingdom.populationKnown, resource.kingdom.resourceKnown, resource.kingdom.moraleKnown)

# BUTTON ANIMATIONS

func _on_content_meta_hover_started(meta: Variant) -> void:
	pass # Replace with function body.

func _on_content_meta_hover_ended(meta: Variant) -> void:
	pass # Replace with function body.

func _on_close_button_mouse_entered() -> void:
	close_button.material.set_shader_parameter("enabled", true)
	close_button.size = close_button.size * 1.1

func _on_close_button_mouse_exited() -> void:
	close_button.material.set_shader_parameter("enabled", false)
	close_button.size = close_button.size / 1.1


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ScrollUp"):
		SCROLL_VELOCITY -= SCROLL_SENSITIVITY
	elif Input.is_action_just_pressed("ScrollDown"):
		SCROLL_VELOCITY += SCROLL_SENSITIVITY
	elif event is InputEventPanGesture:
		SCROLL_VELOCITY += event.delta.y * SCROLL_SENSITIVITY * -1

func _process(delta: float) -> void:
	if abs(SCROLL_VELOCITY) > 0.1:
		letter.position.y = clamp(letter.position.y + SCROLL_VELOCITY * delta, MIN_POS, MAX_POS)
		SCROLL_VELOCITY = lerp(SCROLL_VELOCITY, 0.0, SCROLL_FRICTION * delta)
