extends Control

signal letter_closed

@onready var letter: TextureRect = $Letter
@onready var greeting: Label = $Letter/MarginContainer/VBoxContainer/Greeting
@onready var content: RichTextLabel = $Letter/MarginContainer/VBoxContainer/Content
@onready var signoff: Label = $Letter/MarginContainer/VBoxContainer/Signoff
@onready var suitor_portrait: TextureRect = $SuitorPortrait
@onready var close_button: TextureButton = $CloseButton

var resource: LetterResource

func generate_content(season: String, letter_resource: LetterResource) -> void:
	resource = letter_resource

	greeting.text = resource.greeting
	signoff.text = resource.signoff

	if resource.is_proposal:
		_setup_proposal_layout()
		_setup_seasonal_content(season)
	else:
		content.text = resource.regularContent

	content.bbcode_enabled = true

func _setup_proposal_layout() -> void:
	var letter_position = letter.position
	var portrait_position = suitor_portrait.position

	suitor_portrait.texture = resource.portrait
	letter.position = letter_position + Vector2(-225, 0)
	suitor_portrait.position = portrait_position + Vector2(600, -150)

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
	var sample_letter: LetterResource = load("res://resources/letters/Letter1.tres")
	generate_content("summer", sample_letter)

func _on_close_button_pressed() -> void:
	letter_closed.emit()
	queue_free()

func _on_content_meta_clicked(meta: Variant) -> void:
	print(meta)
	var parsed = meta.split(",")
	for stat in parsed:
		resource.kingdom[stat + "Known"] = true
		print(stat + " is known")