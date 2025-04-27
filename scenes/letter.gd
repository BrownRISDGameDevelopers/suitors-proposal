extends TextureRect

func _ready():
	# Checks if the letter is to be closed out of.
	exit_button.pressed.connect(_on_exit_button_pressed)

@onready var letter: TextureRect = $"."

@onready var greeting: Label = $MarginContainer/VBoxContainer/Greeting
@onready var content: RichTextLabel = $MarginContainer/VBoxContainer/Content
@onready var signoff: Label = $MarginContainer/VBoxContainer/Signoff

@onready var suitor_portrait: TextureRect = $SuitorPortrait

@onready var exit_button: TextureButton = $ExitButton
signal letter_closed

## Generates content of letter based on entered season and letter resource file.

## Parameters: season - String representing string, should only be "spring", "summer",
##                      "winter", or "fall"
##             letter_resource - LetterResource object representing letter that should
##                               be generated

func generate_content(season: String, letter_resource: LetterResource) -> void:

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
			var sumVer = letter_resource.summerVersion
			for text in letter_resource.summerClickableContent:
			
				var base_text = text.text
				var stats = text.revealedStat
				stats = "|".join(stats)
				
				var url_code = "[url=" + stats + "]" + base_text + "[/url]"
				sumVer = sumVer.replace(base_text, url_code)
			
			content.text = sumVer
			print(sumVer)
			
		elif season == "fall":
			
			var fallVer = letter_resource.fallVersion
			for text in letter_resource.fallClickableContent:
			
				var base_text = text.text
				var stats = text.revealedStat
				stats = "|".join(stats)
				
				var url_code = "[url=" + stats + "]" + base_text + "[/url]"
				fallVer.replace(base_text, url_code)
			
			content.text = fallVer
			
		elif season == "winter":
			var wintVer = letter_resource.winterVersion
			for text in letter_resource.winterClickableContent:
			
				var base_text = text.text
				var stats = text.revealedStat
				stats = "|".join(stats)
				
				var url_code = "[url=" + stats + "]" + base_text + "[/url]"
				wintVer.replace(base_text, url_code)
			
			content.text = wintVer
			
		elif season == "spring":
			var sprVer = letter_resource.springVersionrVersion
			for text in letter_resource.springClickableContent:
			
				var base_text = text.text
				var stats = text.revealedStat
				stats = "|".join(stats)
				
				var url_code = "[url=" + stats + "]" + base_text + "[/url]"
				sprVer.replace(base_text, url_code)
			
			content.text = sprVer
			
	else:
		content.text = letter_resource.regularContent
	
	content.bbcode_enabled = true
			
			
			
		
func _on_exit_button_pressed() -> void:
	letter_closed.emit()
	queue_free()
