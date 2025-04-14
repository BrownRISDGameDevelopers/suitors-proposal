extends TextureRect

@onready var letter: TextureRect = $"."

@onready var greeting: Label = $MarginContainer/VBoxContainer/Greeting
@onready var content: RichTextLabel = $MarginContainer/VBoxContainer/Content
@onready var signoff: Label = $MarginContainer/VBoxContainer/Signoff

@onready var suitor_portrait: TextureRect = $SuitorPortrait



const LETTER_1 = preload("res://resources/letters/Letter1.tres")
func _ready():
	_generate_content("summer", LETTER_1)

## Generates content of letter based on entered season and letter resource file.

## Parameters: season - String representing string, should only be "spring", "summer",
##                      "winter", or "fall"
##             letter_resource - LetterResource object representing letter that should
##                               be generated

func _generate_content(season: String, letter_resource: LetterResource) -> void:

	greeting.text = letter_resource.greeting
	signoff.text = letter_resource.signoff
	
	# If it is a proposal, generate the portrait and shift positions of objects!
	if letter_resource.is_proposal:
		
		var letter_position = letter.position
		var portrait_position = suitor_portrait.position
		
		suitor_portrait.texture = letter_resource.portrait
		letter.set_position(letter_position + Vector2(-225, 0)) # Need to find out what Vector2 shift will center this!
		suitor_portrait.set_position(portrait_position + Vector2(600, -150))
		
		if season == "summer":
			content.text = letter_resource.summerVersion
			
		elif season == "fall":
			content.text = letter_resource.fallVersion
			
		elif season == "winter":
			content.text = letter_resource.winterVersion
			
		elif season == "spring":
			content.text = letter_resource.springVersion
			
	else:
		content.text = letter_resource.regularContent
		
